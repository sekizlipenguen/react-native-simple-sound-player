package com.sekizlipenguen.simplesoundplayer;

import android.content.Context;
import android.media.MediaPlayer;
import android.media.AudioAttributes;
import android.util.Log;

import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.bridge.Arguments;

import java.io.IOException;
import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

public class SimpleSoundPlayerModule extends ReactContextBaseJavaModule {
    public static final String NAME = "SimpleSoundPlayer";
    private final ReactApplicationContext reactContext;

    public SimpleSoundPlayerModule(ReactApplicationContext reactContext) {
        super(reactContext);
        this.reactContext = reactContext;
    }

    @Override
    public String getName() {
        return NAME;
    }

    @ReactMethod
    public void playSound(String fileName, Promise promise) {
        playSoundWithVolume(fileName, 0.5f, promise);
    }

    @ReactMethod
    public void playSoundWithVolume(String fileName, float volume, Promise promise) {
        playSoundWithVolumeInternal(fileName, volume, 3600, promise);
    }

    @ReactMethod
    public void playSoundWithVolumeAndCache(String fileName, float volume, int cacheDurationSeconds, Promise promise) {
        playSoundWithVolumeInternal(fileName, volume, cacheDurationSeconds, promise);
    }

    private void playSoundWithVolumeInternal(String fileName, float volume, int cacheDurationSeconds, Promise promise) {
        try {
            MediaPlayer mediaPlayer = new MediaPlayer();
            // Modern AudioAttributes kullan (deprecated API yerine)
            AudioAttributes audioAttributes = new AudioAttributes.Builder()
                .setUsage(AudioAttributes.USAGE_MEDIA)
                .setContentType(AudioAttributes.CONTENT_TYPE_MUSIC)
                .build();
            mediaPlayer.setAudioAttributes(audioAttributes);
            
            // Check if fileName is a URL (starts with http:// or https://)
            if (fileName.startsWith("http://") || fileName.startsWith("https://")) {
                // Remote URL - check cache first
                String cachedFilePath = getCachedFilePath(fileName, cacheDurationSeconds);
                
                if (cachedFilePath != null) {
                    // Use cached file
                    mediaPlayer.setDataSource(cachedFilePath);
                    Log.d("SimpleSoundPlayer", "Playing cached audio from: " + cachedFilePath);
                } else {
                    // Download and cache the file
                    Log.d("SimpleSoundPlayer", "Downloading audio from URL: " + fileName);
                    String downloadedFilePath = downloadAndCacheFile(fileName);
                    if (downloadedFilePath != null) {
                        mediaPlayer.setDataSource(downloadedFilePath);
                        Log.d("SimpleSoundPlayer", "Playing downloaded audio from: " + downloadedFilePath);
                    } else {
                        promise.reject("DOWNLOAD_ERROR", "Failed to download audio from URL: " + fileName);
                        return;
                    }
                }
            } else {
                // Local file from raw resources
                Context context = getReactApplicationContext();
                int resourceId = context.getResources().getIdentifier(
                    fileName.replace(".mp3", "").replace(".wav", "").replace(".ogg", ""),
                    "raw",
                    context.getPackageName()
                );

                if (resourceId == 0) {
                    promise.reject("FILE_NOT_FOUND", "Sound file '" + fileName + "' not found in raw resources");
                    return;
                }
                
                mediaPlayer.setDataSource(context.getResources().openRawResourceFd(resourceId));
                Log.d("SimpleSoundPlayer", "Playing local audio file: " + fileName);
            }
            
            mediaPlayer.setVolume(volume, volume);
            mediaPlayer.prepare();
            mediaPlayer.start();

            mediaPlayer.setOnCompletionListener(new MediaPlayer.OnCompletionListener() {
                @Override
                public void onCompletion(MediaPlayer mp) {
                    mp.release();
                }
            });

            mediaPlayer.setOnErrorListener(new MediaPlayer.OnErrorListener() {
                @Override
                public boolean onError(MediaPlayer mp, int what, int extra) {
                    mp.release();
                    promise.reject("PLAYBACK_ERROR", "Error playing sound: " + what + ", " + extra);
                    return true;
                }
            });

            WritableMap result = Arguments.createMap();
            result.putBoolean("success", true);
            result.putString("fileName", fileName);
            result.putDouble("volume", volume);
            promise.resolve(result);

        } catch (IOException e) {
            promise.reject("PLAYBACK_ERROR", "Error creating MediaPlayer: " + e.getMessage(), e);
        } catch (Exception e) {
            promise.reject("PLAYBACK_ERROR", "Unexpected error: " + e.getMessage(), e);
        }
    }

    // Cache fonksiyonları
    private String getCachedFilePath(String url, int cacheDurationSeconds) {
        try {
            String cacheKey = getCacheKey(url);
            File cacheDir = getCacheDirectory();
            File cachedFile = new File(cacheDir, cacheKey + ".mp3");
            
            if (cachedFile.exists()) {
                long fileAge = System.currentTimeMillis() - cachedFile.lastModified();
                long cacheDurationMs = cacheDurationSeconds * 1000L;
                
                if (fileAge < cacheDurationMs) {
                    // Cache is still valid
                    return cachedFile.getAbsolutePath();
                } else {
                    // Cache expired, remove it
                    cachedFile.delete();
                    Log.d("SimpleSoundPlayer", "Cache expired for URL: " + url);
                }
            }
        } catch (Exception e) {
            Log.e("SimpleSoundPlayer", "Error checking cache: " + e.getMessage());
        }
        
        return null;
    }

    private String downloadAndCacheFile(String url) {
        try {
            String cacheKey = getCacheKey(url);
            File cacheDir = getCacheDirectory();
            File cachedFile = new File(cacheDir, cacheKey + ".mp3");
            
            // Create cache directory if it doesn't exist
            if (!cacheDir.exists()) {
                cacheDir.mkdirs();
            }
            
            // Download file
            URL downloadUrl = new URL(url);
            HttpURLConnection connection = (HttpURLConnection) downloadUrl.openConnection();
            connection.setConnectTimeout(10000);
            connection.setReadTimeout(30000);
            
            InputStream inputStream = connection.getInputStream();
            FileOutputStream outputStream = new FileOutputStream(cachedFile);
            
            byte[] buffer = new byte[4096];
            int bytesRead;
            while ((bytesRead = inputStream.read(buffer)) != -1) {
                outputStream.write(buffer, 0, bytesRead);
            }
            
            inputStream.close();
            outputStream.close();
            connection.disconnect();
            
            Log.d("SimpleSoundPlayer", "File cached: " + cachedFile.getAbsolutePath());
            return cachedFile.getAbsolutePath();
            
        } catch (Exception e) {
            Log.e("SimpleSoundPlayer", "Error downloading file: " + e.getMessage());
            return null;
        }
    }

    private String getCacheKey(String url) {
        try {
            MessageDigest md = MessageDigest.getInstance("MD5");
            md.update(url.getBytes());
            byte[] digest = md.digest();
            StringBuilder sb = new StringBuilder();
            for (byte b : digest) {
                sb.append(String.format("%02x", b));
            }
            return "audio_" + sb.toString();
        } catch (NoSuchAlgorithmException e) {
            return "audio_" + String.valueOf(url.hashCode());
        }
    }

    private File getCacheDirectory() {
        Context context = getReactApplicationContext();
        File cacheDir = new File(context.getCacheDir(), "SimpleSoundPlayer");
        return cacheDir;
    }
}
