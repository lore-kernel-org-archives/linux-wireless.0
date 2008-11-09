Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hostap.isc.org ([149.20.54.63]:41703 "EHLO hostap.isc.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755085AbYKIQjs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Nov 2008 11:39:48 -0500
Date: Sun, 9 Nov 2008 18:38:51 +0200
From: Jouni Malinen <j@w1.fi>
To: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] mac80211_hwsim: Update documentation (AP mode enabled)
Message-ID: <20081109163851.GI12829@jm.kir.nu> (sfid-20081109_173959_488855_44032E52)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

AP mode is now enabled in mac80211, so there is no need to point users
to an additional patch to enable the mode. In addition, add a pointer to
more hwsim test cases in hostap.git.

Signed-off-by: Jouni Malinen <j@w1.fi>


Index: wireless-testing/Documentation/networking/mac80211_hwsim/README
===================================================================
--- wireless-testing.orig/Documentation/networking/mac80211_hwsim/README
+++ wireless-testing/Documentation/networking/mac80211_hwsim/README
@@ -50,10 +50,6 @@ associates with the AP. hostapd and wpa_
 care of WPA2-PSK authentication. In addition, hostapd is also
 processing access point side of association.
 
-Please note that the current Linux kernel does not enable AP mode, so a
-simple patch is needed to enable AP mode selection:
-http://johannes.sipsolutions.net/patches/kernel/all/LATEST/006-allow-ap-vlan-modes.patch
-
 
 # Build mac80211_hwsim as part of kernel configuration
 
@@ -65,3 +61,8 @@ hostapd hostapd.conf
 
 # Run wpa_supplicant (station) for wlan1
 wpa_supplicant -Dwext -iwlan1 -c wpa_supplicant.conf
+
+
+More test cases are available in hostap.git:
+git://w1.fi/srv/git/hostap.git and mac80211_hwsim/tests subdirectory
+(http://w1.fi/gitweb/gitweb.cgi?p=hostap.git;a=tree;f=mac80211_hwsim/tests)

-- 
Jouni Malinen                                            PGP id EFC895FA
