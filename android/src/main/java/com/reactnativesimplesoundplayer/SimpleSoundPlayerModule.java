package com.reactnativesimplesoundplayer;

import android.media.MediaPlayer;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;

public class SimpleSoundPlayerModule extends ReactContextBaseJavaModule {
    private static ReactApplicationContext reactContext;
    private MediaPlayer mediaPlayer;

    SimpleSoundPlayerModule(ReactApplicationContext context) {
        super(context);
        reactContext = context;
    }

    @Override
    public String getName() {
        return "SimpleSoundPlayer";
    }

    @ReactMethod
    public void playSound(String fileName) {
        try {
            // raw klasöründeki ses dosyasını bul
            int resID = reactContext.getResources().getIdentifier(fileName, "raw", reactContext.getPackageName());
            
            if (resID == 0) {
                System.out.println("Ses dosyası bulunamadı: " + fileName);
                return;
            }
            
            mediaPlayer = MediaPlayer.create(reactContext, resID);
            mediaPlayer.setVolume(0.5f, 0.5f); // Orta ses seviyesi
            mediaPlayer.start();
            
            // Ses bittiğinde kaynakları serbest bırak
            mediaPlayer.setOnCompletionListener(new MediaPlayer.OnCompletionListener() {
                @Override
                public void onCompletion(MediaPlayer mp) {
                    mp.release();
                }
            });
            
        } catch (Exception e) {
            System.out.println("Ses çalma hatası: " + e.getMessage());
        }
    }

    @ReactMethod
    public void playSoundWithVolume(String fileName, float volume) {
        try {
            // raw klasöründeki ses dosyasını bul
            int resID = reactContext.getResources().getIdentifier(fileName, "raw", reactContext.getPackageName());
            
            if (resID == 0) {
                System.out.println("Ses dosyası bulunamadı: " + fileName);
                return;
            }
            
            mediaPlayer = MediaPlayer.create(reactContext, resID);
            mediaPlayer.setVolume(volume, volume); // Özel ses seviyesi
            mediaPlayer.start();
            
            // Ses bittiğinde kaynakları serbest bırak
            mediaPlayer.setOnCompletionListener(new MediaPlayer.OnCompletionListener() {
                @Override
                public void onCompletion(MediaPlayer mp) {
                    mp.release();
                }
            });
            
        } catch (Exception e) {
            System.out.println("Ses çalma hatası: " + e.getMessage());
        }
    }
}
