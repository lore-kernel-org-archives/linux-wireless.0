Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:33383 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751730AbdC0GgT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 27 Mar 2017 02:36:19 -0400
Received: by mail-pg0-f67.google.com with SMTP id 79so10220212pgf.0
        for <linux-wireless@vger.kernel.org>; Sun, 26 Mar 2017 23:36:18 -0700 (PDT)
From: vaibhavddit@gmail.com
To: linux-wireless@vger.kernel.org
Cc: Vaibhav Kothari <vaibhavddit@gmail.com>
Subject: [PATCH] Fixing Style Problems
Date: Mon, 27 Mar 2017 12:06:19 +0530
Message-Id: <1490596579-22039-1-git-send-email-vaibhavddit@gmail.com> (sfid-20170327_083641_370555_362192BC)
In-Reply-To: <[PATCH 1/1] Fixing Coding style problems>
References: <[PATCH 1/1] Fixing Coding style problems>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Vaibhav Kothari <vaibhavddit@gmail.com>

- Corrected 80 characters column width

Signed-off-by: Vaibhav Kothari <vaibhavddit@gmail.com>
---
 drivers/staging/wilc1000/coreconfigurator.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/wilc1000/coreconfigurator.h b/drivers/staging/wilc1000/coreconfigurator.h
index 5256f40..794104b 100644
--- a/drivers/staging/wilc1000/coreconfigurator.h
+++ b/drivers/staging/wilc1000/coreconfigurator.h
@@ -123,7 +123,7 @@ struct disconnect_info {
 s32 wilc_parse_network_info(u8 *msg_buffer,
 			    struct network_info **ret_network_info);
 s32 wilc_parse_assoc_resp_info(u8 *buffer, u32 buffer_len,
-			       struct connect_resp_info **ret_connect_resp_info);
+			      struct connect_resp_info **ret_connect_resp_info);
 void wilc_scan_complete_received(struct wilc *wilc, u8 *buffer, u32 length);
 void wilc_network_info_received(struct wilc *wilc, u8 *buffer, u32 length);
 void wilc_gnrl_async_info_received(struct wilc *wilc, u8 *buffer, u32 length);
-- 
1.9.1
