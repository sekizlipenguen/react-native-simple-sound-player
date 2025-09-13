package com.sekizlipenguen.simplesoundplayer;

import android.content.Context;
import android.media.MediaPlayer;
import android.media.AudioManager;
import android.util.Log;

import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.bridge.Arguments;

import java.io.IOException;

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
        try {
            MediaPlayer mediaPlayer = new MediaPlayer();
            mediaPlayer.setAudioStreamType(AudioManager.STREAM_MUSIC);
            
            // Check if fileName is a URL (starts with http:// or https://)
            if (fileName.startsWith("http://") || fileName.startsWith("https://")) {
                // Remote URL
                mediaPlayer.setDataSource(fileName);
                Log.d("SimpleSoundPlayer", "Playing remote audio from URL: " + fileName);
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
}
