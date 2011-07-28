Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:7743 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755772Ab1G1Rb1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jul 2011 13:31:27 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH 8/9] ath9k_hw: Update the radio parameters related to high_power
Date: Thu, 28 Jul 2011 22:59:35 +0530
Message-ID: <1311874176-27569-8-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20110728_193133_784707_25F104F7)
In-Reply-To: <1311874176-27569-1-git-send-email-rmanohar@qca.qualcomm.com>
References: <1311874176-27569-1-git-send-email-rmanohar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 .../net/wireless/ath/ath9k/ar9003_2p2_initvals.h   |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_2p2_initvals.h b/drivers/net/wireless/ath/ath9k/ar9003_2p2_initvals.h
index 28b44b0..275b53d 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_2p2_initvals.h
+++ b/drivers/net/wireless/ath/ath9k/ar9003_2p2_initvals.h
@@ -928,15 +928,15 @@ static const u32 ar9300Modes_high_power_tx_gain_table_2p2[][5] = {
 	{0x0000c2e0, 0x0000f800, 0x0000f800, 0x03ccc584, 0x03ccc584},
 	{0x0000c2e4, 0x03ff0000, 0x03ff0000, 0x03f0f800, 0x03f0f800},
 	{0x0000c2e8, 0x00000000, 0x00000000, 0x03ff0000, 0x03ff0000},
-	{0x00016044, 0x056db2e6, 0x056db2e6, 0x056db2e6, 0x056db2e6},
-	{0x00016048, 0xae480001, 0xae480001, 0xae480001, 0xae480001},
-	{0x00016068, 0x6eb6db6c, 0x6eb6db6c, 0x6eb6db6c, 0x6eb6db6c},
-	{0x00016444, 0x056db2e6, 0x056db2e6, 0x056db2e6, 0x056db2e6},
-	{0x00016448, 0xae480001, 0xae480001, 0xae480001, 0xae480001},
-	{0x00016468, 0x6eb6db6c, 0x6eb6db6c, 0x6eb6db6c, 0x6eb6db6c},
-	{0x00016844, 0x056db2e6, 0x056db2e6, 0x056db2e6, 0x056db2e6},
-	{0x00016848, 0xae480001, 0xae480001, 0xae480001, 0xae480001},
-	{0x00016868, 0x6eb6db6c, 0x6eb6db6c, 0x6eb6db6c, 0x6eb6db6c},
+	{0x00016044, 0x012492d4, 0x012492d4, 0x012492d4, 0x012492d4},
+	{0x00016048, 0x66480001, 0x66480001, 0x66480001, 0x66480001},
+	{0x00016068, 0x6db6db6c, 0x6db6db6c, 0x6db6db6c, 0x6db6db6c},
+	{0x00016444, 0x012492d4, 0x012492d4, 0x012492d4, 0x012492d4},
+	{0x00016448, 0x66480001, 0x66480001, 0x66480001, 0x66480001},
+	{0x00016468, 0x6db6db6c, 0x6db6db6c, 0x6db6db6c, 0x6db6db6c},
+	{0x00016844, 0x012492d4, 0x012492d4, 0x012492d4, 0x012492d4},
+	{0x00016848, 0x66480001, 0x66480001, 0x66480001, 0x66480001},
+	{0x00016868, 0x6db6db6c, 0x6db6db6c, 0x6db6db6c, 0x6db6db6c},
 };
 
 static const u32 ar9300Modes_high_ob_db_tx_gain_table_2p2[][5] = {
-- 
1.7.6

