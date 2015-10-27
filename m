Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f54.google.com ([209.85.220.54]:34905 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751147AbbJ0XTo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Oct 2015 19:19:44 -0400
Received: by pasz6 with SMTP id z6so235803735pas.2
        for <linux-wireless@vger.kernel.org>; Tue, 27 Oct 2015 16:19:43 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 03/10] staging: wilc1000: replace u8 with int.
Date: Wed, 28 Oct 2015 08:19:21 +0900
Message-Id: <1445987968-18974-3-git-send-email-chaehyun.lim@gmail.com> (sfid-20151028_001946_859862_E1A758B4)
In-Reply-To: <1445987968-18974-1-git-send-email-chaehyun.lim@gmail.com>
References: <1445987968-18974-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch changes data type of variable i from u8 to int.
It is used as index of an array to print its content. It's better
to use as data type of int.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index e0a4cf3..9a57d31a 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -3200,7 +3200,7 @@ int host_int_add_wep_key_bss_ap(struct host_if_drv *hif_drv,
 {
 	int result = 0;
 	struct host_if_msg msg;
-	u8 i;
+	int i;
 
 	if (!hif_drv) {
 		PRINT_ER("driver is null\n");
-- 
2.6.1

