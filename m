Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:42459 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751460Ab0HAWDZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Aug 2010 18:03:25 -0400
Received: by mail-ey0-f174.google.com with SMTP id 25so1118027eya.19
        for <linux-wireless@vger.kernel.org>; Sun, 01 Aug 2010 15:03:24 -0700 (PDT)
From: Kshitij Kulshreshtha <kkhere.geo@gmail.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Hauke Mehrtens <hauke@hauke-m.de>
Cc: linux-wireless@vger.kernel.org,
	Kshitij Kulshreshtha <kkhere.geo@gmail.com>
Subject: [PATCH 3/3] compat: define struct va_format introduced in v2.6.36
Date: Mon,  2 Aug 2010 00:02:51 +0200
Message-Id: <1280700173-14690-4-git-send-email-kkhere.geo@gmail.com>
In-Reply-To: <4C55D22A.5040302@hauke-m.de>
References: <4C55D22A.5040302@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Kshitij Kulshreshtha <kkhere.geo@gmail.com>
---
 include/linux/compat-2.6.36.h |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/include/linux/compat-2.6.36.h b/include/linux/compat-2.6.36.h
index 0307108..b14c772 100644
--- a/include/linux/compat-2.6.36.h
+++ b/include/linux/compat-2.6.36.h
@@ -8,6 +8,11 @@
 #define kparam_block_sysfs_write(a)
 #define kparam_unblock_sysfs_write(a)
 
+struct va_format {
+	const char *fmt;
+	va_list *va;
+};
+
 #endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,36)) */
 
 #endif /* LINUX_26_36_COMPAT_H */
-- 
1.7.1

