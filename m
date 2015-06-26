Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f48.google.com ([209.85.220.48]:33976 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751568AbbFZGtO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Jun 2015 02:49:14 -0400
Received: by pabvl15 with SMTP id vl15so63783401pab.1
        for <linux-wireless@vger.kernel.org>; Thu, 25 Jun 2015 23:49:14 -0700 (PDT)
From: Sunghoon Cho <ywhsbliss@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
	johnny.kim@atmel.com, chris.park@atmel.com, Rachel.kim@atmel.com,
	dean.lee@atmel.com, ywhsbliss@gmail.com
Subject: [PATCH 2/3] staging: wilc1000: add a blank line after struct declaration
Date: Fri, 26 Jun 2015 15:48:15 +0900
Message-Id: <7d7c7a9ea2355d4a740c05d82e189b79bd23313c.1435300603.git.ywhsbliss@gmail.com> (sfid-20150626_084926_405244_DCBC76CF)
In-Reply-To: <41da67d312f5ddf70e2a401814df494d71c8a945.1435300603.git.ywhsbliss@gmail.com>
References: <41da67d312f5ddf70e2a401814df494d71c8a945.1435300603.git.ywhsbliss@gmail.com>
In-Reply-To: <41da67d312f5ddf70e2a401814df494d71c8a945.1435300603.git.ywhsbliss@gmail.com>
References: <41da67d312f5ddf70e2a401814df494d71c8a945.1435300603.git.ywhsbliss@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds a blank line right after a struct declaration.

Signed-off-by: Sunghoon Cho <ywhsbliss@gmail.com>
---
 drivers/staging/wilc1000/wilc_wfi_netdevice.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
index 22d7b85..8102ef0 100644
--- a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
+++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
@@ -95,6 +95,7 @@ struct wilc_wfi_key {
 	int seq_len;
 	u32 cipher;
 };
+
 struct wilc_wfi_wep_key {
 	u8 *key;
 	u8 key_len;
-- 
1.9.1

