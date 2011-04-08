Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:12162 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751144Ab1DHKB3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Apr 2011 06:01:29 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 08 Apr 2011 03:01:04 -0700
From: Senthil Balasubramanian <senthilkumar@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Senthil Balasubramanian <senthilkumar@atheros.com>
Subject: [PATCH 2/2] ath9k: Update gain table for AR9485
Date: Fri, 8 Apr 2011 15:30:35 +0530
Message-ID: <1302256836-4647-2-git-send-email-senthilkumar@atheros.com>
In-Reply-To: <1302256836-4647-1-git-send-email-senthilkumar@atheros.com>
References: <1302256836-4647-1-git-send-email-senthilkumar@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Update Tx gain 23 for all tx gain table.

Signed-off-by: Senthil Balasubramanian <senthilkumar@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ar9485_initvals.h |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9485_initvals.h b/drivers/net/wireless/ath/ath9k/ar9485_initvals.h
index f91f73e..fbdde29 100644
--- a/drivers/net/wireless/ath/ath9k/ar9485_initvals.h
+++ b/drivers/net/wireless/ath/ath9k/ar9485_initvals.h
@@ -396,7 +396,7 @@ static const u32 ar9485Modes_high_ob_db_tx_gain_1_1[][5] = {
 	{0x0000a54c, 0x7203feca, 0x7203feca, 0x51001865, 0x51001865},
 	{0x0000a550, 0x7703ff0b, 0x7703ff0b, 0x55001a86, 0x55001a86},
 	{0x0000a554, 0x7d06ffcb, 0x7d06ffcb, 0x57001ce9, 0x57001ce9},
-	{0x0000a558, 0x8407ff0b, 0x8407ff0b, 0x5a001eeb, 0x5a001eeb},
+	{0x0000a558, 0x8407ff0b, 0x8407ff0b, 0x5a001ceb, 0x5a001ceb},
 	{0x0000a55c, 0x8907ffcb, 0x8907ffcb, 0x5e001eeb, 0x5e001eeb},
 	{0x0000a560, 0x900fff0b, 0x900fff0b, 0x5e001eeb, 0x5e001eeb},
 	{0x0000a564, 0x960fffcb, 0x960fffcb, 0x5e001eeb, 0x5e001eeb},
@@ -469,7 +469,7 @@ static const u32 ar9485_modes_lowest_ob_db_tx_gain_1_1[][5] = {
 	{0x0000a54c, 0x7203feca, 0x7203feca, 0x51001865, 0x51001865},
 	{0x0000a550, 0x7703ff0b, 0x7703ff0b, 0x55001a86, 0x55001a86},
 	{0x0000a554, 0x7d06ffcb, 0x7d06ffcb, 0x57001ce9, 0x57001ce9},
-	{0x0000a558, 0x8407ff0b, 0x8407ff0b, 0x5a001eeb, 0x5a001eeb},
+	{0x0000a558, 0x8407ff0b, 0x8407ff0b, 0x5a001ceb, 0x5a001ceb},
 	{0x0000a55c, 0x8907ffcb, 0x8907ffcb, 0x5e001eeb, 0x5e001eeb},
 	{0x0000a560, 0x900fff0b, 0x900fff0b, 0x5e001eeb, 0x5e001eeb},
 	{0x0000a564, 0x960fffcb, 0x960fffcb, 0x5e001eeb, 0x5e001eeb},
@@ -635,7 +635,7 @@ static const u32 ar9485Modes_high_power_tx_gain_1_1[][5] = {
 	{0x0000a54c, 0x7203feca, 0x7203feca, 0x51001865, 0x51001865},
 	{0x0000a550, 0x7703ff0b, 0x7703ff0b, 0x55001a86, 0x55001a86},
 	{0x0000a554, 0x7d06ffcb, 0x7d06ffcb, 0x57001ce9, 0x57001ce9},
-	{0x0000a558, 0x8407ff0b, 0x8407ff0b, 0x5a001eeb, 0x5a001eeb},
+	{0x0000a558, 0x8407ff0b, 0x8407ff0b, 0x5a001ceb, 0x5a001ceb},
 	{0x0000a55c, 0x8907ffcb, 0x8907ffcb, 0x5e001eeb, 0x5e001eeb},
 	{0x0000a560, 0x900fff0b, 0x900fff0b, 0x5e001eeb, 0x5e001eeb},
 	{0x0000a564, 0x960fffcb, 0x960fffcb, 0x5e001eeb, 0x5e001eeb},
@@ -728,7 +728,7 @@ static const u32 ar9485_modes_green_ob_db_tx_gain_1_1[][5] = {
 	{0x0000a54c, 0x7203feca, 0x7203feca, 0x51001865, 0x51001865},
 	{0x0000a550, 0x7703ff0b, 0x7703ff0b, 0x55001a86, 0x55001a86},
 	{0x0000a554, 0x7d06ffcb, 0x7d06ffcb, 0x57001ce9, 0x57001ce9},
-	{0x0000a558, 0x8407ff0b, 0x8407ff0b, 0x5a001eeb, 0x5a001eeb},
+	{0x0000a558, 0x8407ff0b, 0x8407ff0b, 0x5a001ceb, 0x5a001ceb},
 	{0x0000a55c, 0x8907ffcb, 0x8907ffcb, 0x5e001eeb, 0x5e001eeb},
 	{0x0000a560, 0x900fff0b, 0x900fff0b, 0x5e001eeb, 0x5e001eeb},
 	{0x0000a564, 0x960fffcb, 0x960fffcb, 0x5e001eeb, 0x5e001eeb},
@@ -827,7 +827,7 @@ static const u32 ar9485Modes_low_ob_db_tx_gain_1_1[][5] = {
 	{0x0000a54c, 0x7203feca, 0x7203feca, 0x51001865, 0x51001865},
 	{0x0000a550, 0x7703ff0b, 0x7703ff0b, 0x55001a86, 0x55001a86},
 	{0x0000a554, 0x7d06ffcb, 0x7d06ffcb, 0x57001ce9, 0x57001ce9},
-	{0x0000a558, 0x8407ff0b, 0x8407ff0b, 0x5a001eeb, 0x5a001eeb},
+	{0x0000a558, 0x8407ff0b, 0x8407ff0b, 0x5a001ceb, 0x5a001ceb},
 	{0x0000a55c, 0x8907ffcb, 0x8907ffcb, 0x5e001eeb, 0x5e001eeb},
 	{0x0000a560, 0x900fff0b, 0x900fff0b, 0x5e001eeb, 0x5e001eeb},
 	{0x0000a564, 0x960fffcb, 0x960fffcb, 0x5e001eeb, 0x5e001eeb},
-- 
1.7.0.4

