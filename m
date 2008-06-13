Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hostap.isc.org ([149.20.54.63]:57033 "EHLO hostap.isc.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750729AbYFMQsl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Jun 2008 12:48:41 -0400
Message-Id: <20080613164757.587110304@localhost> (sfid-20080613_184844_920598_D6D4D281)
References: <20080613164445.542630279@localhost>
Date: Fri, 13 Jun 2008 19:44:46 +0300
From: Jouni Malinen <j@w1.fi>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: [PATCH 1/3] mac80211_hwsim: Clean up documentation
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Clean up the introduction and fix a typo.

Signed-off-by: Jouni Malinen <j@w1.fi>


Index: wireless-testing/Documentation/networking/mac80211_hwsim/README
===================================================================
--- wireless-testing.orig/Documentation/networking/mac80211_hwsim/README
+++ wireless-testing/Documentation/networking/mac80211_hwsim/README
@@ -9,13 +9,12 @@ published by the Free Software Foundatio
 Introduction
 
 mac80211_hwsim is a Linux kernel module that can be used to simulate
-arbitrary number of IEEE 802.11 radios for mac80211 on a single
-device. It can be used to test most of the mac80211 functionality and
-user space tools (e.g., hostapd and wpa_supplicant) in a way that
-matches very closely with the normal case of using real WLAN
-hardware. From the mac80211 view point, mac80211_hwsim is yet another
-hardware driver, i.e., no changes to mac80211 are needed to use this
-testing tool.
+arbitrary number of IEEE 802.11 radios for mac80211. It can be used to
+test most of the mac80211 functionality and user space tools (e.g.,
+hostapd and wpa_supplicant) in a way that matches very closely with
+the normal case of using real WLAN hardware. From the mac80211 view
+point, mac80211_hwsim is yet another hardware driver, i.e., no changes
+to mac80211 are needed to use this testing tool.
 
 The main goal for mac80211_hwsim is to make it easier for developers
 to test their code and work with new features to mac80211, hostapd,
@@ -26,7 +25,7 @@ since all radio operation is simulated, 
 tests regardless of regulatory rules.
 
 mac80211_hwsim kernel module has a parameter 'radios' that can be used
-to select how many radios are simulates (default 2). This allows
+to select how many radios are simulated (default 2). This allows
 configuration of both very simply setups (e.g., just a single access
 point and a station) or large scale tests (multiple access points with
 hundreds of stations).

--

-- 
Jouni Malinen                                            PGP id EFC895FA
