Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f43.google.com ([209.85.220.43]:35183 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752272AbbKIJB2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Nov 2015 04:01:28 -0500
Received: by pasz6 with SMTP id z6so198734824pas.2
        for <linux-wireless@vger.kernel.org>; Mon, 09 Nov 2015 01:01:27 -0800 (PST)
From: "Yin, Fengwei" <fengwei.yin@linaro.org>
To: andy.green@linaro.org, linux-wireless@vger.kernel.org,
	wcn36xx@lists.infradead.org, me@bobcopeland.com,
	k.eugene.e@gmail.com, bjorn.andersson@sonymobile.com
Cc: fengwei.yin@linaro.org
Subject: [PATCH 1/5] wcn36xx: introduce WCN36XX_HAL_AVOID_FREQ_RANGE_IND
Date: Mon,  9 Nov 2015 05:02:38 -0500
Message-Id: <1447063362-27322-2-git-send-email-fengwei.yin@linaro.org> (sfid-20151109_100131_126749_A63D6625)
In-Reply-To: <1447063362-27322-1-git-send-email-fengwei.yin@linaro.org>
References: <1447063362-27322-1-git-send-email-fengwei.yin@linaro.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Andy Green <andy.green@linaro.org>

From: Andy Green <andy.green@linaro.org>

WCN3620 firmware introduces a new async indication, we need to
add it as a known message type so we can accept it

Signed-off-by: Andy Green <andy.green@linaro.org>
---
 drivers/net/wireless/ath/wcn36xx/hal.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/ath/wcn36xx/hal.h b/drivers/net/wireless/ath/wcn36xx/hal.h
index a1f1127..b947de0 100644
--- a/drivers/net/wireless/ath/wcn36xx/hal.h
+++ b/drivers/net/wireless/ath/wcn36xx/hal.h
@@ -345,6 +345,8 @@ enum wcn36xx_hal_host_msg_type {
 	WCN36XX_HAL_DHCP_START_IND = 189,
 	WCN36XX_HAL_DHCP_STOP_IND = 190,
 
+	WCN36XX_HAL_AVOID_FREQ_RANGE_IND = 233,
+
 	WCN36XX_HAL_MSG_MAX = WCN36XX_HAL_MSG_TYPE_MAX_ENUM_SIZE
 };
 
-- 
2.1.4

