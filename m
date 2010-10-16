Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web56802.mail.re3.yahoo.com ([66.196.97.76]:35186 "HELO
	web56802.mail.re3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754300Ab0JPNUE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 Oct 2010 09:20:04 -0400
Message-ID: <756358.10174.qm@web56802.mail.re3.yahoo.com>
Date: Sat, 16 Oct 2010 06:20:02 -0700 (PDT)
From: Walter Goldens <goldenstranger@yahoo.com>
Subject: [PATCH] compat-wireless: unload modules list updated
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Added: wl1251, wl1271, iwmc3200wifi, b44 and
the whole orinoco family to wl/unload.sh scripts.


Signed-off-by: Walter Goldens <goldenstranger@yahoo.com>
---

--- a/scripts/wlunload.sh
+++ b/scripts/wlunload.sh
@@ -8,10 +8,13 @@ OLD_MODULES="$OLD_MODULES ieee80211softm
 OLD_MODULES="$OLD_MODULES bcm43xx rndis_wext iwl4965"
 MODULES="$OLD_MODULES"
 MODULES="$MODULES ipw2100 ipw2200 libipw"
+MODULES="$MODULES wl1251 wl1271 iwmc3200wifi"
 MODULES="$MODULES libertas_cs usb8xxx libertas libertas_sdio libertas_spi"
 MODULES="$MODULES libertas_tf libertas_tf_usb"
-MODULES="$MODULES adm8211 zd1211rw orinoco"
-MODULES="$MODULES b43 b43legacy brcm80211 ssb"
+MODULES="$MODULES adm8211 zd1211rw"
+MODULES="$MODULES orinoco_cs orinoco_nortel orinoco_pci orinoco_plx"
+MODULES="$MODULES orinoco_tld orinoco_usb spectrum_cs orinoco"
+MODULES="$MODULES b43 b44 b43legacy brcm80211 ssb"
 MODULES="$MODULES iwl3945 iwlagn iwlcore"
 MODULES="$MODULES ath9k ath9k_htc ath9k_common ath9k_hw "
 MODULES="$MODULES ath5k ath ath6kl ar9170usb carl9170"
--- a/scripts/unload.sh
+++ b/scripts/unload.sh
@@ -8,10 +8,13 @@ OLD_MODULES="$OLD_MODULES ieee80211softm
 OLD_MODULES="$OLD_MODULES bcm43xx rndis_wext iwl4965"
 MODULES="$OLD_MODULES"
 MODULES="$MODULES ipw2100 ipw2200 libipw"
+MODULES="$MODULES wl1251 wl1271 iwmc3200wifi"
 MODULES="$MODULES libertas_cs usb8xxx libertas libertas_sdio libertas_spi"
 MODULES="$MODULES libertas_tf libertas_tf_usb"
-MODULES="$MODULES adm8211 zd1211rw orinoco"
-MODULES="$MODULES b43 b43legacy brcm80211 ssb"
+MODULES="$MODULES adm8211 zd1211rw"
+MODULES="$MODULES orinoco_cs orinoco_nortel orinoco_pci orinoco_plx"
+MODULES="$MODULES orinoco_tld orinoco_usb spectrum_cs orinoco"
+MODULES="$MODULES b43 b44 b43legacy brcm80211 ssb"
 MODULES="$MODULES iwl3945 iwlagn iwlcore"
 MODULES="$MODULES ath9k ath9k_htc ath9k_common ath9k_hw "
 MODULES="$MODULES ath5k ath ath6kl ar9170usb carl9170"



      
