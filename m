Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:44536 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751698AbZA2GYA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Jan 2009 01:24:00 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 28 Jan 2009 22:24:00 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18817.19108.810825.356686@gargle.gargle.HOWL> (sfid-20090129_072407_161405_8332709C)
Date: Thu, 29 Jan 2009 11:50:20 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Jouni.Malinen@Atheros.com>,
	<Luis.Rodriguez@Atheros.com>
Subject: [PATCH] ath9k: Remove a bunch of unused macros
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

RX filter masks are already defined in enum ath9k_rx_filter
in ath9k.h

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath9k/reg.h |   11 -----------
 1 files changed, 0 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/ath9k/reg.h b/drivers/net/wireless/ath9k/reg.h
index 150eda5..c967b79 100644
--- a/drivers/net/wireless/ath9k/reg.h
+++ b/drivers/net/wireless/ath9k/reg.h
@@ -1198,18 +1198,7 @@ enum {
 #define AR_CFP_VAL          0x0000FFFF
 
 #define AR_RX_FILTER        0x803C
-#define AR_RX_FILTER_ALL    0x00000000
-#define AR_RX_UCAST         0x00000001
-#define AR_RX_MCAST         0x00000002
-#define AR_RX_BCAST         0x00000004
-#define AR_RX_CONTROL       0x00000008
-#define AR_RX_BEACON        0x00000010
-#define AR_RX_PROM          0x00000020
-#define AR_RX_PROBE_REQ     0x00000080
-#define AR_RX_MY_BEACON     0x00000200
 #define AR_RX_COMPR_BAR     0x00000400
-#define AR_RX_COMPR_BA      0x00000800
-#define AR_RX_UNCOM_BA_BAR  0x00001000
 
 #define AR_MCAST_FIL0       0x8040
 #define AR_MCAST_FIL1       0x8044
-- 
1.6.1

