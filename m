Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:5446 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754337Ab1JYHJu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Oct 2011 03:09:50 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH] ath9k_hw: Updated AR9462 initval table to improve rx performance
Date: Tue, 25 Oct 2011 12:40:38 +0530
Message-ID: <1319526638-12910-1-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20111025_091005_437488_2792D663)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The initval tables are updated as per system team input to improve
rx performance and power accuracy at 5GHz.

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 .../net/wireless/ath/ath9k/ar9462_2p0_initvals.h   |   26 ++++++++++----------
 1 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9462_2p0_initvals.h b/drivers/net/wireless/ath/ath9k/ar9462_2p0_initvals.h
index 9c51b39..259a6f3 100644
--- a/drivers/net/wireless/ath/ath9k/ar9462_2p0_initvals.h
+++ b/drivers/net/wireless/ath/ath9k/ar9462_2p0_initvals.h
@@ -43,16 +43,16 @@ static const u32 ar9462_2p0_baseband_postamble[][5] = {
 	/* Addr      5G_HT20     5G_HT40     2G_HT40     2G_HT20   */
 	{0x00009810, 0xd00a8005, 0xd00a8005, 0xd00a8011, 0xd00a8011},
 	{0x00009820, 0x206a022e, 0x206a022e, 0x206a012e, 0x206a012e},
-	{0x00009824, 0x5ac640d0, 0x5ac640d0, 0x5ac640d0, 0x5ac640d0},
-	{0x00009828, 0x06903081, 0x06903081, 0x06903881, 0x06903881},
+	{0x00009824, 0x5ac640de, 0x5ac640d0, 0x5ac640d0, 0x5ac640de},
+	{0x00009828, 0x0796be89, 0x0696b081, 0x0696b881, 0x0796be89},
 	{0x0000982c, 0x05eea6d4, 0x05eea6d4, 0x05eea6d4, 0x05eea6d4},
 	{0x00009830, 0x0000059c, 0x0000059c, 0x0000119c, 0x0000119c},
 	{0x00009c00, 0x000000c4, 0x000000c4, 0x000000c4, 0x000000c4},
 	{0x00009e00, 0x0372111a, 0x0372111a, 0x037216a0, 0x037216a0},
 	{0x00009e04, 0x001c2020, 0x001c2020, 0x001c2020, 0x001c2020},
 	{0x00009e0c, 0x6c4000e2, 0x6d4000e2, 0x6d4000e2, 0x6c4000e2},
-	{0x00009e10, 0x7ec88d2e, 0x7ec88d2e, 0x7ec84d2e, 0x7ec84d2e},
-	{0x00009e14, 0x37b95d5e, 0x37b9605e, 0x3039605e, 0x33795d5e},
+	{0x00009e10, 0x92c88d2e, 0x7ec88d2e, 0x7ec84d2e, 0x92c84d2e},
+	{0x00009e14, 0x37b95d5e, 0x37b9605e, 0x3379605e, 0x33795d5e},
 	{0x00009e18, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
 	{0x00009e1c, 0x0001cf9c, 0x0001cf9c, 0x00021f9c, 0x00021f9c},
 	{0x00009e20, 0x000003b5, 0x000003b5, 0x000003ce, 0x000003ce},
@@ -688,8 +688,8 @@ static const u32 ar9462_2p0_mac_postamble_emulation[][5] = {
 static const u32 ar9462_2p0_radio_postamble_sys3ant[][5] = {
 	/* Addr      5G_HT20     5G_HT40     2G_HT40     2G_HT20   */
 	{0x000160ac, 0xa4646c08, 0xa4646c08, 0x24645808, 0x24645808},
-	{0x00016140, 0x10804008, 0x10804008, 0x90804008, 0x90804008},
-	{0x00016540, 0x10804008, 0x10804008, 0x90804008, 0x90804008},
+	{0x00016140, 0x10804008, 0x10804008, 0x50804008, 0x50804008},
+	{0x00016540, 0x10804008, 0x10804008, 0x50804008, 0x50804008},
 };
 
 static const u32 ar9462_2p0_baseband_postamble_emulation[][5] = {
@@ -717,8 +717,8 @@ static const u32 ar9462_2p0_baseband_postamble_emulation[][5] = {
 static const u32 ar9462_2p0_radio_postamble_sys2ant[][5] = {
 	/* Addr      5G_HT20     5G_HT40     2G_HT40     2G_HT20   */
 	{0x000160ac, 0xa4646c08, 0xa4646c08, 0x24645808, 0x24645808},
-	{0x00016140, 0x10804008, 0x10804008, 0x90804008, 0x90804008},
-	{0x00016540, 0x10804008, 0x10804008, 0x90804008, 0x90804008},
+	{0x00016140, 0x10804008, 0x10804008, 0x50804008, 0x50804008},
+	{0x00016540, 0x10804008, 0x10804008, 0x50804008, 0x50804008},
 };
 
 static const u32 ar9462_common_wo_xlna_rx_gain_table_2p0[][2] = {
@@ -1059,7 +1059,7 @@ static const u32 ar9462_modes_low_ob_db_tx_gain_table_2p0[][5] = {
 
 static const u32 ar9462_2p0_soc_postamble[][5] = {
 	/* Addr      5G_HT20     5G_HT40     2G_HT40     2G_HT20   */
-	{0x00007010, 0x00002233, 0x00002233, 0x00002233, 0x00002233},
+	{0x00007010, 0x00000033, 0x00000033, 0x00000033, 0x00000033},
 };
 
 static const u32 ar9462_2p0_baseband_core[][2] = {
@@ -1257,8 +1257,8 @@ static const u32 ar9462_modes_high_ob_db_tx_gain_table_2p0[][5] = {
 	{0x0000a540, 0x48025e6c, 0x48025e6c, 0x38001660, 0x38001660},
 	{0x0000a544, 0x4e025e8e, 0x4e025e8e, 0x3b001861, 0x3b001861},
 	{0x0000a548, 0x53025eb2, 0x53025eb2, 0x3e001a81, 0x3e001a81},
-	{0x0000a54c, 0x59025eb2, 0x59025eb2, 0x42001a83, 0x42001a83},
-	{0x0000a550, 0x5f025ef6, 0x5f025ef6, 0x44001c84, 0x44001c84},
+	{0x0000a54c, 0x59025eb6, 0x59025eb6, 0x42001a83, 0x42001a83},
+	{0x0000a550, 0x5d025ef6, 0x5d025ef6, 0x44001c84, 0x44001c84},
 	{0x0000a554, 0x62025f56, 0x62025f56, 0x48001ce3, 0x48001ce3},
 	{0x0000a558, 0x66027f56, 0x66027f56, 0x4c001ce5, 0x4c001ce5},
 	{0x0000a55c, 0x6a029f56, 0x6a029f56, 0x50001ce9, 0x50001ce9},
@@ -1850,8 +1850,8 @@ static const u32 ar9462_modes_green_ob_db_tx_gain_table_2p0[][5] = {
 	{0x0000a540, 0x48025e6c, 0x48025e6c, 0x38001660, 0x38001660},
 	{0x0000a544, 0x4e025e8e, 0x4e025e8e, 0x3b001861, 0x3b001861},
 	{0x0000a548, 0x53025eb2, 0x53025eb2, 0x3e001a81, 0x3e001a81},
-	{0x0000a54c, 0x59025eb2, 0x59025eb2, 0x42001a83, 0x42001a83},
-	{0x0000a550, 0x5f025ef6, 0x5f025ef6, 0x44001c84, 0x44001c84},
+	{0x0000a54c, 0x59025eb6, 0x59025eb6, 0x42001a83, 0x42001a83},
+	{0x0000a550, 0x5d025ef6, 0x5d025ef6, 0x44001c84, 0x44001c84},
 	{0x0000a554, 0x62025f56, 0x62025f56, 0x48001ce3, 0x48001ce3},
 	{0x0000a558, 0x66027f56, 0x66027f56, 0x4c001ce5, 0x4c001ce5},
 	{0x0000a55c, 0x6a029f56, 0x6a029f56, 0x50001ce9, 0x50001ce9},
-- 
1.7.7

