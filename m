Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f43.google.com ([209.85.220.43]:34057 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752229AbbJ0XUF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Oct 2015 19:20:05 -0400
Received: by padhk11 with SMTP id hk11so236259828pad.1
        for <linux-wireless@vger.kernel.org>; Tue, 27 Oct 2015 16:20:05 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 10/10] staging: wilc1000: fix line over 80 characters
Date: Wed, 28 Oct 2015 08:19:28 +0900
Message-Id: <1445987968-18974-10-git-send-email-chaehyun.lim@gmail.com> (sfid-20151028_002010_382883_B26BE2D0)
In-Reply-To: <1445987968-18974-1-git-send-email-chaehyun.lim@gmail.com>
References: <1445987968-18974-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes line over 80 characters found by checkpatch.

WARNING: line over 80 characters
FILE: drivers/staging/wilc1000/host_interface.h:424:

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index cae61a4..7b8b1c6 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -421,7 +421,9 @@ int host_int_add_wep_key_bss_sta(struct host_if_drv *hif_drv,
  *  @date		28 Feb 2013
  *  @version		1.0
  */
-int host_int_add_wep_key_bss_ap(struct host_if_drv *hif_drv, const u8 *key, u8 len, u8 index, u8 mode, enum AUTHTYPE auth_type);
+int host_int_add_wep_key_bss_ap(struct host_if_drv *hif_drv,
+				const u8 *key, u8 len, u8 index, u8 mode,
+				enum AUTHTYPE auth_type);
 
 /**
  *  @brief              adds ptk Key
-- 
2.6.1

