package com.example.snifferapp;

import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

import java.io.BufferedReader;
import java.io.FileReader;
import java.util.ArrayList;

public class MainActivity extends FlutterActivity {
  private static final String CHANNEL = "services/networkinfo";

  @Override
  public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
    GeneratedPluginRegistrant.registerWith(flutterEngine);

    new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
            .setMethodCallHandler(
              (call, result) -> {
                  if (call.method.equals("getArpTable")) {
                    String arpTableContent = "";
                    ArrayList<String> arpEntries = new ArrayList<String>();
                    try {
                        String line;
                        BufferedReader br = new BufferedReader(new FileReader("/proc/net/arp"));
                        while ((line = br.readLine()) != null) {
                            arpTableContent += line;
                            arpEntries.add(line);
                        }
                        result.success(arpEntries);
//                        result.success(arpTableContent);
                    } catch (Exception e) {
                        result.error("UNAVAILBLE", e.toString(), e);
                    }
                  } else {
                      result.notImplemented();
                  }
              }
            );
  }
}
