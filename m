Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:34325 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752893Ab1KQWWQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Nov 2011 17:22:16 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: Hauke Mehrtens <hauke@hauke-m.de>,
	"Luis R. Rodriguez" <lrodriguez@qca.qualcomm.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH v2 1/4] compat: use separate CONFIG_COMPAT_KFIFO option for building kfifo.o
Date: Thu, 17 Nov 2011 17:20:39 -0500
Message-Id: <1321568442-22758-1-git-send-email-linville@tuxdriver.com> (sfid-20111117_232236_028037_C6FA83F2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 compat/Makefile |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/compat/Makefile b/compat/Makefile
index 2fb1893..fc43ba1 100644
--- a/compat/Makefile
+++ b/compat/Makefile
@@ -24,9 +24,9 @@ compat-$(CONFIG_COMPAT_KERNEL_2_6_29) += compat-2.6.29.o
 compat-$(CONFIG_COMPAT_KERNEL_2_6_32) += compat-2.6.32.o
 compat-$(CONFIG_COMPAT_KERNEL_2_6_33) += compat-2.6.33.o
 compat-$(CONFIG_COMPAT_KERNEL_2_6_35) += compat-2.6.35.o
-compat-$(CONFIG_COMPAT_KERNEL_2_6_36) += \
-	compat-2.6.36.o \
-	kfifo.o
+compat-$(CONFIG_COMPAT_KERNEL_2_6_36) += compat-2.6.36.o
+
+compat-$(CONFIG_COMPAT_KFIFO) += kfifo.o
 
 compat-$(CONFIG_COMPAT_KERNEL_2_6_37) += compat-2.6.37.o
 compat-$(CONFIG_COMPAT_KERNEL_2_6_38) += compat-2.6.38.o
-- 
1.7.4.4

