Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:34566 "EHLO
	mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751010AbcCCF2f (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Mar 2016 00:28:35 -0500
Received: by mail-pf0-f193.google.com with SMTP id 184so723482pff.1
        for <linux-wireless@vger.kernel.org>; Wed, 02 Mar 2016 21:28:34 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 2/5] staging: wilc1000: remove unnecessary comment codes
Date: Thu,  3 Mar 2016 14:28:21 +0900
Message-Id: <1456982904-8063-2-git-send-email-chaehyun.lim@gmail.com> (sfid-20160303_062838_031625_118F74B2)
In-Reply-To: <1456982904-8063-1-git-send-email-chaehyun.lim@gmail.com>
References: <1456982904-8063-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes unnecessary comment code in struct sdio_cmd53_t.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/wilc_wlan_if.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan_if.h b/drivers/staging/wilc1000/wilc_wlan_if.h
index 99aaec7..dcde9ef 100644
--- a/drivers/staging/wilc1000/wilc_wlan_if.h
+++ b/drivers/staging/wilc1000/wilc_wlan_if.h
@@ -59,14 +59,12 @@ struct sdio_cmd52 {
 };
 
 typedef struct {
-	/* struct { */
 	u32 read_write:		1;
 	u32 function:		3;
 	u32 block_mode:		1;
 	u32 increment:		1;
 	u32 address:		17;
 	u32 count:		9;
-	/* } bit; */
 	u8 *buffer;
 	u32 block_size;
 } sdio_cmd53_t;
-- 
2.7.1

