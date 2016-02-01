Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:35166 "EHLO
	mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932143AbcBAM1T (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Feb 2016 07:27:19 -0500
Received: by mail-pf0-f195.google.com with SMTP id 66so7045247pfe.2
        for <linux-wireless@vger.kernel.org>; Mon, 01 Feb 2016 04:27:19 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 07/11] staging: wilc1000: linux_mon: insert blank line after a function
Date: Mon,  1 Feb 2016 21:26:43 +0900
Message-Id: <1454329607-9486-7-git-send-email-chaehyun.lim@gmail.com> (sfid-20160201_132727_414510_6583E240)
In-Reply-To: <1454329607-9486-1-git-send-email-chaehyun.lim@gmail.com>
References: <1454329607-9486-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch inserts a blank line afer function found by checkpatch.pl
CHECK: Please use a blank line after function/struct/union/enum
declarations

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/linux_mon.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/wilc1000/linux_mon.c b/drivers/staging/wilc1000/linux_mon.c
index 0c3dee3..53d0caf 100644
--- a/drivers/staging/wilc1000/linux_mon.c
+++ b/drivers/staging/wilc1000/linux_mon.c
@@ -152,6 +152,7 @@ static void mgmt_tx_complete(void *priv, int status)
 
 	kfree(pv_data);
 }
+
 static int mon_mgmt_tx(struct net_device *dev, const u8 *buf, size_t len)
 {
 	struct tx_complete_mon_data *mgmt_tx = NULL;
-- 
2.7.0

