package com.example.snifferapp;

import android.content.Context;

import android.net.Network;
import android.net.ConnectivityManager;
import android.net.LinkProperties;
import android.net.LinkAddress;
import android.net.RouteInfo;

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
                  try {
                      if (call.method.equals("getArpTable")) {
                          String arpTableContent = "";
                          ArrayList<String> arpEntries = new ArrayList<String>();

                          String line;
                          BufferedReader br = new BufferedReader(new FileReader("/proc/net/arp"));
                          while ((line = br.readLine()) != null) {
                              arpTableContent += line;
                              arpEntries.add(line);
                          }
                          result.success(arpEntries);

                      } else if (call.method.equals("getNetworkInterfaceInfo")) {
                          ConnectivityManager cm = (ConnectivityManager)getContext().getSystemService(Context.CONNECTIVITY_SERVICE);
                          Network[] networks = cm.getAllNetworks();
                          ArrayList<String> networkStrings = new ArrayList<String>();

                          for (int i = 0; i < networks.length; i++) {
                              networkStrings.add("|");
                              LinkProperties lp = cm.getLinkProperties(networks[i]);
                              networkStrings.add(lp.getInterfaceName());
                              // Retrieve network addresses
                              for (LinkAddress la : lp.getLinkAddresses()) {
                                  networkStrings.add(la.toString());
                              }
                              // Retrieve routing table
//                              for (RouteInfo ri : lp.getRoutes()) {
//                                  networkStrings.add(ri.toString());
//                              }
                          }
                          result.success(networkStrings);
                      } else {
                          result.notImplemented();
                      }
                  } catch (Exception e) {
                      result.error("ERROR", e.toString(), e);
                  }
              }
            );
  }
}
