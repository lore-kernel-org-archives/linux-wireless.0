Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:57225 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752240Ab1GHMmQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jul 2011 08:42:16 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH 1/4] ath9k_hw: Update AR9003 interval to improve 5G Tx EVM
Date: Fri, 8 Jul 2011 18:12:00 +0530
Message-ID: <1310128923-2778-1-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20110708_144225_721850_810D9D49)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The number of temperature reading samples to average
during a Tx packet is decreased to 1 from 2 to improve
5G Tx EVM with chain 0-only mode.

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 .../net/wireless/ath/ath9k/ar9003_2p2_initvals.h   |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_2p2_initvals.h b/drivers/net/wireless/ath/ath9k/ar9003_2p2_initvals.h
index e8ac70d..39efcbf 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_2p2_initvals.h
+++ b/drivers/net/wireless/ath/ath9k/ar9003_2p2_initvals.h
@@ -780,7 +780,7 @@ static const u32 ar9300_2p2_baseband_core[][2] = {
 	{0x0000a43c, 0x00100000},
 	{0x0000a440, 0x00000000},
 	{0x0000a444, 0x00000000},
-	{0x0000a448, 0x06000080},
+	{0x0000a448, 0x05000080},
 	{0x0000a44c, 0x00000001},
 	{0x0000a450, 0x00010000},
 	{0x0000a458, 0x00000000},
-- 
1.7.6

