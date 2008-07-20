Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from venema.h4ckr.net ([217.24.1.135]:39881 "EHLO venema.h4ckr.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755275AbYGTDmJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Jul 2008 23:42:09 -0400
Date: Sun, 20 Jul 2008 06:42:47 +0300
From: Nick Kossifidis <mick@madwifi.org>
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, jirislaby@gmail.com, mcgrof@gmail.com
Subject: [PATCH 7/12] ath5k: Add RF2425 initial rfgain values
Message-ID: <20080720034247.GG7440@makis> (sfid-20080720_054211_777958_16CCD2FF)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

 * Add initial RF gain settings for RF2425

 Changes-licensed-under: ISC
 Signed-off-by: Nick Kossifidis <mickflemm@gmail.com>

---
diff --git a/drivers/net/wireless/ath5k/phy.c b/drivers/net/wireless/ath5k/phy.c
index afd8689..66af70b 100644
--- a/drivers/net/wireless/ath5k/phy.c
+++ b/drivers/net/wireless/ath5k/phy.c
@@ -1020,6 +1020,74 @@ static const struct ath5k_ini_rfgain rfgain_2413[] = {
 	{ AR5K_RF_GAIN(63), { 0x000000f9 } },
 };
 
+/* Initial RF Gain settings for RF2425 */
+static const struct ath5k_ini_rfgain rfgain_2425[] = {
+	{ AR5K_RF_GAIN(0), { 0x00000000 } },
+	{ AR5K_RF_GAIN(1), { 0x00000040 } },
+	{ AR5K_RF_GAIN(2), { 0x00000080 } },
+	{ AR5K_RF_GAIN(3), { 0x00000181 } },
+	{ AR5K_RF_GAIN(4), { 0x000001c1 } },
+	{ AR5K_RF_GAIN(5), { 0x00000001 } },
+	{ AR5K_RF_GAIN(6), { 0x00000041 } },
+	{ AR5K_RF_GAIN(7), { 0x00000081 } },
+	{ AR5K_RF_GAIN(8), { 0x00000188 } },
+	{ AR5K_RF_GAIN(9), { 0x000001c8 } },
+	{ AR5K_RF_GAIN(10), { 0x00000008 } },
+	{ AR5K_RF_GAIN(11), { 0x00000048 } },
+	{ AR5K_RF_GAIN(12), { 0x00000088 } },
+	{ AR5K_RF_GAIN(13), { 0x00000189 } },
+	{ AR5K_RF_GAIN(14), { 0x000001c9 } },
+	{ AR5K_RF_GAIN(15), { 0x00000009 } },
+	{ AR5K_RF_GAIN(16), { 0x00000049 } },
+	{ AR5K_RF_GAIN(17), { 0x00000089 } },
+	{ AR5K_RF_GAIN(18), { 0x000001b0 } },
+	{ AR5K_RF_GAIN(19), { 0x000001f0 } },
+	{ AR5K_RF_GAIN(20), { 0x00000030 } },
+	{ AR5K_RF_GAIN(21), { 0x00000070 } },
+	{ AR5K_RF_GAIN(22), { 0x00000171 } },
+	{ AR5K_RF_GAIN(23), { 0x000001b1 } },
+	{ AR5K_RF_GAIN(24), { 0x000001f1 } },
+	{ AR5K_RF_GAIN(25), { 0x00000031 } },
+	{ AR5K_RF_GAIN(26), { 0x00000071 } },
+	{ AR5K_RF_GAIN(27), { 0x000001b8 } },
+	{ AR5K_RF_GAIN(28), { 0x000001f8 } },
+	{ AR5K_RF_GAIN(29), { 0x00000038 } },
+	{ AR5K_RF_GAIN(30), { 0x00000078 } },
+	{ AR5K_RF_GAIN(31), { 0x000000b8 } },
+	{ AR5K_RF_GAIN(32), { 0x000001b9 } },
+	{ AR5K_RF_GAIN(33), { 0x000001f9 } },
+	{ AR5K_RF_GAIN(34), { 0x00000039 } },
+	{ AR5K_RF_GAIN(35), { 0x00000079 } },
+	{ AR5K_RF_GAIN(36), { 0x000000b9 } },
+	{ AR5K_RF_GAIN(37), { 0x000000f9 } },
+	{ AR5K_RF_GAIN(38), { 0x000000f9 } },
+	{ AR5K_RF_GAIN(39), { 0x000000f9 } },
+	{ AR5K_RF_GAIN(40), { 0x000000f9 } },
+	{ AR5K_RF_GAIN(41), { 0x000000f9 } },
+	{ AR5K_RF_GAIN(42), { 0x000000f9 } },
+	{ AR5K_RF_GAIN(43), { 0x000000f9 } },
+	{ AR5K_RF_GAIN(44), { 0x000000f9 } },
+	{ AR5K_RF_GAIN(45), { 0x000000f9 } },
+	{ AR5K_RF_GAIN(46), { 0x000000f9 } },
+	{ AR5K_RF_GAIN(47), { 0x000000f9 } },
+	{ AR5K_RF_GAIN(48), { 0x000000f9 } },
+	{ AR5K_RF_GAIN(49), { 0x000000f9 } },
+	{ AR5K_RF_GAIN(50), { 0x000000f9 } },
+	{ AR5K_RF_GAIN(51), { 0x000000f9 } },
+	{ AR5K_RF_GAIN(52), { 0x000000f9 } },
+	{ AR5K_RF_GAIN(53), { 0x000000f9 } },
+	{ AR5K_RF_GAIN(54), { 0x000000f9 } },
+	{ AR5K_RF_GAIN(55), { 0x000000f9 } },
+	{ AR5K_RF_GAIN(56), { 0x000000f9 } },
+	{ AR5K_RF_GAIN(57), { 0x000000f9 } },
+	{ AR5K_RF_GAIN(58), { 0x000000f9 } },
+	{ AR5K_RF_GAIN(59), { 0x000000f9 } },
+	{ AR5K_RF_GAIN(60), { 0x000000f9 } },
+	{ AR5K_RF_GAIN(61), { 0x000000f9 } },
+	{ AR5K_RF_GAIN(62), { 0x000000f9 } },
+	{ AR5K_RF_GAIN(63), { 0x000000f9 } },
+};
+
 static const struct ath5k_gain_opt rfgain_opt_5112 = {
 	1,
 	8,
@@ -1588,8 +1656,8 @@ int ath5k_hw_rfgain(struct ath5k_hw *ah, unsigned int freq)
 		freq = 0; /* only 2Ghz */
 		break;
 	case AR5K_RF2425:
-		ath5k_rfg = rfgain_2413;
-		size = ARRAY_SIZE(rfgain_2413);
+		ath5k_rfg = rfgain_2425;
+		size = ARRAY_SIZE(rfgain_2425);
 		freq = 0; /* only 2Ghz */
 		break;
 	default:

