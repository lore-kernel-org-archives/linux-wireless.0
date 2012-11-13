Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:54986 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751721Ab2KMR3L (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Nov 2012 12:29:11 -0500
Received: by mail-ee0-f46.google.com with SMTP id b15so4133183eek.19
        for <linux-wireless@vger.kernel.org>; Tue, 13 Nov 2012 09:29:10 -0800 (PST)
From: Maxim Mikityanskiy <maxtram95@gmail.com>
To: greg@kroah.com, Larry.Finger@lwfinger.net,
	linux-wireless@vger.kernel.org
Cc: Maxim Mikityanskiy <maxtram95@gmail.com>
Subject: [PATCH 12/17] staging: rtl8187se: Removed unused arrays in r8180_rtl8225z2.c
Date: Tue, 13 Nov 2012 19:28:18 +0200
Message-Id: <1352827703-4659-13-git-send-email-maxtram95@gmail.com> (sfid-20121113_182918_726578_BD6F7B4C)
In-Reply-To: <1352827703-4659-1-git-send-email-maxtram95@gmail.com>
References: <1352827703-4659-1-git-send-email-maxtram95@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Maxim Mikityanskiy <maxtram95@gmail.com>
---
 drivers/staging/rtl8187se/r8180_rtl8225z2.c |   33 ---------------------------
 1 file changed, 33 deletions(-)

diff --git a/drivers/staging/rtl8187se/r8180_rtl8225z2.c b/drivers/staging/rtl8187se/r8180_rtl8225z2.c
index 315eece..eba9786 100644
--- a/drivers/staging/rtl8187se/r8180_rtl8225z2.c
+++ b/drivers/staging/rtl8187se/r8180_rtl8225z2.c
@@ -15,7 +15,6 @@
 
 #include "ieee80211/dot11d.h"
 
-
 static void write_rtl8225(struct net_device *dev, u8 adr, u16 data)
 {
 	int i;
@@ -76,22 +75,6 @@ static void write_rtl8225(struct net_device *dev, u8 adr, u16 data)
 	rtl8185_rf_pins_enable(dev);
 }
 
-static const u16 rtl8225bcd_rxgain[] = {
-	0x0400, 0x0401, 0x0402, 0x0403, 0x0404, 0x0405, 0x0408, 0x0409,
-	0x040a, 0x040b, 0x0502, 0x0503, 0x0504, 0x0505, 0x0540, 0x0541,
-	0x0542, 0x0543, 0x0544, 0x0545, 0x0580, 0x0581, 0x0582, 0x0583,
-	0x0584, 0x0585, 0x0588, 0x0589, 0x058a, 0x058b, 0x0643, 0x0644,
-	0x0645, 0x0680, 0x0681, 0x0682, 0x0683, 0x0684, 0x0685, 0x0688,
-	0x0689, 0x068a, 0x068b, 0x068c, 0x0742, 0x0743, 0x0744, 0x0745,
-	0x0780, 0x0781, 0x0782, 0x0783, 0x0784, 0x0785, 0x0788, 0x0789,
-	0x078a, 0x078b, 0x078c, 0x078d, 0x0790, 0x0791, 0x0792, 0x0793,
-	0x0794, 0x0795, 0x0798, 0x0799, 0x079a, 0x079b, 0x079c, 0x079d,
-	0x07a0, 0x07a1, 0x07a2, 0x07a3, 0x07a4, 0x07a5, 0x07a8, 0x07a9,
-	0x07aa, 0x07ab, 0x07ac, 0x07ad, 0x07b0, 0x07b1, 0x07b2, 0x07b3,
-	0x07b4, 0x07b5, 0x07b8, 0x07b9, 0x07ba, 0x07bb, 0x07bb
-
-};
-
 static const u8 rtl8225_agc[] = {
 	0x9e, 0x9e, 0x9e, 0x9e, 0x9e, 0x9e, 0x9e, 0x9e,
 	0x9d, 0x9c, 0x9b, 0x9a, 0x99, 0x98, 0x97, 0x96,
@@ -117,10 +100,6 @@ static const u32 rtl8225_chan[] = {
 	0x0400, 0x0480, 0x0500, 0x0580, 0x0600, 0x0680, 0x074A,
 };
 
-static const u8 rtl8225z2_threshold[] = {
-	0x8d, 0x8d, 0x8d, 0x8d, 0x9d, 0xad, 0xbd,
-};
-
 static const u8 rtl8225z2_gain_bg[] = {
 	0x23, 0x15, 0xa5, /* -82-1dBm */
 	0x23, 0x15, 0xb5, /* -82-2dBm */
@@ -157,18 +136,6 @@ static const u16 rtl8225z2_rxgain[] = {
 
 };
 
-static const u8 rtl8225z2_tx_power_ofdm[] = {
-	0x42, 0x00, 0x40, 0x00, 0x40
-};
-
-static const u8 rtl8225z2_tx_power_cck_ch14[] = {
-	0x36, 0x35, 0x2e, 0x1b, 0x00, 0x00, 0x00, 0x00
-};
-
-static const u8 rtl8225z2_tx_power_cck[] = {
-	0x36, 0x35, 0x2e, 0x25, 0x1c, 0x12, 0x09, 0x04
-};
-
 void rtl8225z2_set_gain(struct net_device *dev, short gain)
 {
 	const u8 *rtl8225_gain;
-- 
1.7.10.4

