Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:36636 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753543AbbJ0LlF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Oct 2015 07:41:05 -0400
Received: by pacfv9 with SMTP id fv9so230468697pac.3
        for <linux-wireless@vger.kernel.org>; Tue, 27 Oct 2015 04:41:04 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 7/8] staging: wilc1000: fix line over 80 characters
Date: Tue, 27 Oct 2015 20:40:38 +0900
Message-Id: <1445946039-10390-7-git-send-email-chaehyun.lim@gmail.com> (sfid-20151027_124109_111987_715409D3)
In-Reply-To: <1445946039-10390-1-git-send-email-chaehyun.lim@gmail.com>
References: <1445946039-10390-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes line over 80 characters found by checkpatch.

WARNING: line over 80 characters
FILE: drivers/staging/wilc1000/host_interface.h:408:

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 1e134d4..a9f7d1d 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -405,7 +405,8 @@ int host_int_set_wep_default_key(struct host_if_drv *hif_drv, u8 index);
  *  @date		8 March 2012
  *  @version		1.0
  */
-int host_int_add_wep_key_bss_sta(struct host_if_drv *hif_drv, const u8 *key, u8 len, u8 index);
+int host_int_add_wep_key_bss_sta(struct host_if_drv *hif_drv,
+				 const u8 *key, u8 len, u8 index);
 /**
  *  @brief              host_int_add_wep_key_bss_ap
  *  @details    valid only in AP mode if External Supplicant support is enabled.
-- 
2.6.1

