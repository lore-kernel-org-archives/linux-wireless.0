Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:33160 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756591Ab1FIWFO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jun 2011 18:05:14 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com, lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, jonas.gorski@gmail.com,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 3/5] compat: rename CONFIG_COMPAT_KERNEL_
Date: Fri, 10 Jun 2011 00:04:45 +0200
Message-Id: <1307657087-23900-3-git-send-email-hauke@hauke-m.de> (sfid-20110610_000519_843202_425A0A56)
In-Reply-To: <1307657087-23900-1-git-send-email-hauke@hauke-m.de>
References: <1307657087-23900-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

CONFIG_COMPAT_KERNEL_XX was renamed to CONFIG_COMPAT_KERNEL_2_6_XX in
compat-wireless to support kernel 3.XX, do the same in compat.

Add to compat-3.0-stable
---
 compat/Makefile |   38 +++++++++++++++++++-------------------
 1 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/compat/Makefile b/compat/Makefile
index ddfd88d..e2a6add 100644
--- a/compat/Makefile
+++ b/compat/Makefile
@@ -6,31 +6,31 @@ obj-$(CONFIG_COMPAT_FIRMWARE_CLASS) += compat_firmware_class.o
 compat-y += main.o
 
 # Compat kernel compatibility code
-compat-$(CONFIG_COMPAT_KERNEL_14) += compat-2.6.14.o
-compat-$(CONFIG_COMPAT_KERNEL_18) += compat-2.6.18.o
-compat-$(CONFIG_COMPAT_KERNEL_19) += compat-2.6.19.o
-compat-$(CONFIG_COMPAT_KERNEL_21) += compat-2.6.21.o
-compat-$(CONFIG_COMPAT_KERNEL_22) += compat-2.6.22.o
-compat-$(CONFIG_COMPAT_KERNEL_23) += compat-2.6.23.o
-compat-$(CONFIG_COMPAT_KERNEL_24) += compat-2.6.24.o
-compat-$(CONFIG_COMPAT_KERNEL_25) += \
+compat-$(CONFIG_COMPAT_KERNEL_2_6_14) += compat-2.6.14.o
+compat-$(CONFIG_COMPAT_KERNEL_2_6_18) += compat-2.6.18.o
+compat-$(CONFIG_COMPAT_KERNEL_2_6_19) += compat-2.6.19.o
+compat-$(CONFIG_COMPAT_KERNEL_2_6_21) += compat-2.6.21.o
+compat-$(CONFIG_COMPAT_KERNEL_2_6_22) += compat-2.6.22.o
+compat-$(CONFIG_COMPAT_KERNEL_2_6_23) += compat-2.6.23.o
+compat-$(CONFIG_COMPAT_KERNEL_2_6_24) += compat-2.6.24.o
+compat-$(CONFIG_COMPAT_KERNEL_2_6_25) += \
 	compat-2.6.25.o \
 	pm_qos_params.o
 
-compat-$(CONFIG_COMPAT_KERNEL_26) += compat-2.6.26.o
-compat-$(CONFIG_COMPAT_KERNEL_27) += compat-2.6.27.o
-compat-$(CONFIG_COMPAT_KERNEL_28) += compat-2.6.28.o
-compat-$(CONFIG_COMPAT_KERNEL_29) += compat-2.6.29.o
-compat-$(CONFIG_COMPAT_KERNEL_32) += compat-2.6.32.o
-compat-$(CONFIG_COMPAT_KERNEL_33) += compat-2.6.33.o
-compat-$(CONFIG_COMPAT_KERNEL_35) += compat-2.6.35.o
-compat-$(CONFIG_COMPAT_KERNEL_36) += \
+compat-$(CONFIG_COMPAT_KERNEL_2_6_26) += compat-2.6.26.o
+compat-$(CONFIG_COMPAT_KERNEL_2_6_27) += compat-2.6.27.o
+compat-$(CONFIG_COMPAT_KERNEL_2_6_28) += compat-2.6.28.o
+compat-$(CONFIG_COMPAT_KERNEL_2_6_29) += compat-2.6.29.o
+compat-$(CONFIG_COMPAT_KERNEL_2_6_32) += compat-2.6.32.o
+compat-$(CONFIG_COMPAT_KERNEL_2_6_33) += compat-2.6.33.o
+compat-$(CONFIG_COMPAT_KERNEL_2_6_35) += compat-2.6.35.o
+compat-$(CONFIG_COMPAT_KERNEL_2_6_36) += \
 	compat-2.6.36.o \
 	kfifo.o
 
-compat-$(CONFIG_COMPAT_KERNEL_37) += compat-2.6.37.o
-compat-$(CONFIG_COMPAT_KERNEL_38) += compat-2.6.38.o
-compat-$(CONFIG_COMPAT_KERNEL_39) += \
+compat-$(CONFIG_COMPAT_KERNEL_2_6_37) += compat-2.6.37.o
+compat-$(CONFIG_COMPAT_KERNEL_2_6_38) += compat-2.6.38.o
+compat-$(CONFIG_COMPAT_KERNEL_2_6_39) += \
 	compat-2.6.39.o \
 	kstrtox.o
 
-- 
1.7.4.1

