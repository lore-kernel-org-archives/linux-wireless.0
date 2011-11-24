Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:24691 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750735Ab1KXLcm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Nov 2011 06:32:42 -0500
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH] ath6kl: Increase the maximum number of connections in AP mode
Date: Thu, 24 Nov 2011 17:06:34 +0530
Message-ID: <1322134594-2524-1-git-send-email-vthiagar@qca.qualcomm.com> (sfid-20111124_123245_725504_334C58A8)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The maximum number of clients which ath6kl can support in AP mode
is 10. The limitation of 8 connections is only for older chipsets
which ath6kl does not support.

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/wmi.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/wmi.h b/drivers/net/wireless/ath/ath6kl/wmi.h
index 76342d5..9ca24af 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.h
+++ b/drivers/net/wireless/ath/ath6kl/wmi.h
@@ -1963,7 +1963,7 @@ struct wmi_tx_complete_event {
  * !!! Warning !!!
  * -Changing the following values needs compilation of both driver and firmware
  */
-#define AP_MAX_NUM_STA          8
+#define AP_MAX_NUM_STA          10
 
 /* Spl. AID used to set DTIM flag in the beacons */
 #define MCAST_AID               0xFF
-- 
1.7.0.4

