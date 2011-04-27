Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:50121 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755686Ab1D0Lkg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Apr 2011 07:40:36 -0400
Received: by mail-pv0-f174.google.com with SMTP id 12so1117897pvg.19
        for <linux-wireless@vger.kernel.org>; Wed, 27 Apr 2011 04:40:36 -0700 (PDT)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19896.333.282625.531581@gargle.gargle.HOWL> (sfid-20110427_134039_177705_E299CE9A)
Date: Wed, 27 Apr 2011 17:13:09 +0530
To: linville@tuxdriver.com
CC: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Subject: [PATCH 2/4] ath9k_htc: Remove unused WMI_AGGR_LIMIT_CMD
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <Sujith.Manoharan@atheros.com>

Signed-off-by: Sujith Manoharan <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/wmi.c |    2 --
 drivers/net/wireless/ath/ath9k/wmi.h |    1 -
 2 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/wmi.c b/drivers/net/wireless/ath/ath9k/wmi.c
index 8f095ad..463b76a 100644
--- a/drivers/net/wireless/ath/ath9k/wmi.c
+++ b/drivers/net/wireless/ath/ath9k/wmi.c
@@ -79,8 +79,6 @@ static const char *wmi_cmd_to_name(enum wmi_cmd_id wmi_cmd)
 		return "WMI_TX_STATS_CMDID";
 	case WMI_RX_STATS_CMDID:
 		return "WMI_RX_STATS_CMDID";
-	case WMI_AGGR_LIMIT_CMD:
-		return "WMI_AGGR_LIMIT_CMD";
 	}
 
 	return "Bogus";
diff --git a/drivers/net/wireless/ath/ath9k/wmi.h b/drivers/net/wireless/ath/ath9k/wmi.h
index 02ecb9f..5dfc213 100644
--- a/drivers/net/wireless/ath/ath9k/wmi.h
+++ b/drivers/net/wireless/ath/ath9k/wmi.h
@@ -111,7 +111,6 @@ enum wmi_cmd_id {
 	WMI_INT_STATS_CMDID,
 	WMI_TX_STATS_CMDID,
 	WMI_RX_STATS_CMDID,
-	WMI_AGGR_LIMIT_CMD = 0x0026,
 };
 
 enum wmi_event_id {
-- 
1.7.4.4

