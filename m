Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:32747 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752944AbbJHBuk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Oct 2015 21:50:40 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 10/14] staging: wilc1000: rename typedef from tenuCfgParam
Date: Thu, 8 Oct 2015 10:49:17 +0900
Message-ID: <1444268961-7551-10-git-send-email-tony.cho@atmel.com> (sfid-20151008_035042_631164_5783955A)
In-Reply-To: <1444268961-7551-1-git-send-email-tony.cho@atmel.com>
References: <1444268961-7551-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch rename typedef from the enum tenuCfgParamand
rename it to cfg_param.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 8e20c30..20d8a9e 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -126,7 +126,7 @@ struct cfg_param_val {
 
 };
 
-typedef enum {
+enum cfg_param {
 	RETRY_SHORT		= BIT(0),
 	RETRY_LONG		= BIT(1),
 	FRAG_THRESHOLD		= BIT(2),
@@ -146,7 +146,7 @@ typedef enum {
 	PASSIVE_SCANTIME	= BIT(16),
 	CURRENT_TX_RATE		= BIT(17),
 	HT_ENABLE		= BIT(18),
-} tenuCfgParam;
+};
 
 struct found_net_info {
 	u8 au8bssid[6];
-- 
1.9.1

