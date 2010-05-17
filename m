Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:10970 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753404Ab0EQGax (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 May 2010 02:30:53 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Sun, 16 May 2010 23:30:53 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19440.58033.694345.932560@gargle.gargle.HOWL>
Date: Mon, 17 May 2010 12:01:13 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 1/5] ath9k_htc: Initvals update for AR9271
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Update from internal systems engineering team.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ar9002_initvals.h |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9002_initvals.h b/drivers/net/wireless/ath/ath9k/ar9002_initvals.h
index dae7f33..8ab24ee 100644
--- a/drivers/net/wireless/ath/ath9k/ar9002_initvals.h
+++ b/drivers/net/wireless/ath/ath9k/ar9002_initvals.h
@@ -4492,7 +4492,7 @@ static const u32 ar9287PciePhy_clkreq_off_L1_9287_1_1[][2] = {
 };
 
 
-/* AR9271 initialization values automaticaly created: 06/04/09 */
+/* AR9271 initialization values automaticaly created: 03/31/10 */
 static const u32 ar9271Modes_9271[][6] = {
     { 0x00001030, 0x00000230, 0x00000460, 0x000002c0, 0x00000160, 0x000001e0 },
     { 0x00001070, 0x00000168, 0x000002d0, 0x00000318, 0x0000018c, 0x000001e0 },
@@ -5011,7 +5011,7 @@ static const u32 ar9271Common_9271[][2] = {
     { 0x0000783c, 0x72ee0a72 },
     { 0x00007840, 0xbbfffffc },
     { 0x00007844, 0x000c0db6 },
-    { 0x00007848, 0x6db61b6f },
+    { 0x00007848, 0x6db6246f },
     { 0x0000784c, 0x6d9b66db },
     { 0x00007850, 0x6d8c6dba },
     { 0x00007854, 0x00040000 },
@@ -5218,7 +5218,7 @@ static const u32 ar9271Modes_high_power_tx_gain_9271[][6] = {
     { 0x00007824, 0x00d8a7ff, 0x00d8a7ff, 0x00d8a7ff, 0x00d8a7ff, 0x00d8a7ff },
     { 0x0000786c, 0x08609eb6, 0x08609eb6, 0x08609eba, 0x08609eba, 0x08609eb6 },
     { 0x00007820, 0x00000c00, 0x00000c00, 0x00000c00, 0x00000c00, 0x00000c00 },
-    { 0x0000a274, 0x0a22a652, 0x0a22a652, 0x0a212652, 0x0a212652, 0x0a22a652 },
+    { 0x0000a274, 0x0a22a652, 0x0a22a652, 0x0a214652, 0x0a214652, 0x0a22a652 },
     { 0x0000a278, 0x0e739ce7, 0x0e739ce7, 0x0e739ce7, 0x0e739ce7, 0x0e739ce7 },
     { 0x0000a27c, 0x05018063, 0x05038063, 0x05018063, 0x05018063, 0x05018063 },
     { 0x0000a394, 0x06318c63, 0x06318c63, 0x06318c63, 0x06318c63, 0x06318c63 },
-- 
1.7.1

