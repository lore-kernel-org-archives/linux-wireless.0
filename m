Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:43315 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934546AbaGXUOF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jul 2014 16:14:05 -0400
Received: by mail-wi0-f177.google.com with SMTP id ho1so4649839wib.4
        for <linux-wireless@vger.kernel.org>; Thu, 24 Jul 2014 13:14:04 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 7/8] staging: vt6656: Remove unused macro MP_TEST_FLAGS
Date: Thu, 24 Jul 2014 21:13:19 +0100
Message-Id: <1406232800-3694-7-git-send-email-tvboxspy@gmail.com> (sfid-20140724_221413_055936_BBF8EB54)
In-Reply-To: <1406232800-3694-1-git-send-email-tvboxspy@gmail.com>
References: <1406232800-3694-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/device.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/staging/vt6656/device.h b/drivers/staging/vt6656/device.h
index 21f810e..2ec086c 100644
--- a/drivers/staging/vt6656/device.h
+++ b/drivers/staging/vt6656/device.h
@@ -402,8 +402,6 @@ struct vnt_private {
 		(uVar)++;				\
 }
 
-#define MP_TEST_FLAGS(_M, _F)            (((_M)->flags & (_F)) == (_F))
-
 int vnt_init(struct vnt_private *priv);
 
 #endif
-- 
2.0.1

