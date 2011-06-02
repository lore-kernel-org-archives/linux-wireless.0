Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:51487 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751941Ab1FBQbX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Jun 2011 12:31:23 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com, lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 3/4] compat: rename CONFIG_COMPAT_KERNEL_
Date: Thu,  2 Jun 2011 18:31:03 +0200
Message-Id: <1307032264-14663-4-git-send-email-hauke@hauke-m.de> (sfid-20110602_183127_733192_8C65F832)
In-Reply-To: <1307032264-14663-1-git-send-email-hauke@hauke-m.de>
References: <1307032264-14663-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

CONFIG_COMPAT_KERNEL_XX was renamed to CONFIG_COMPAT_KERNEL_26XX in
compat-wireless to support kernel 3.XX, do the same in compat.

Add to compat-3.0-stable

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 compat/Makefile |   38 +++++++++++++++++++-------------------
 1 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/compat/Makefile b/compat/Makefile
index ddfd88d..eb3f15c 100644
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
+compat-$(CONFIG_COMPAT_KERNEL_2614) += compat-2.6.14.o
+compat-$(CONFIG_COMPAT_KERNEL_2618) += compat-2.6.18.o
+compat-$(CONFIG_COMPAT_KERNEL_2619) += compat-2.6.19.o
+compat-$(CONFIG_COMPAT_KERNEL_2621) += compat-2.6.21.o
+compat-$(CONFIG_COMPAT_KERNEL_2622) += compat-2.6.22.o
+compat-$(CONFIG_COMPAT_KERNEL_2623) += compat-2.6.23.o
+compat-$(CONFIG_COMPAT_KERNEL_2624) += compat-2.6.24.o
+compat-$(CONFIG_COMPAT_KERNEL_2625) += \
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
+compat-$(CONFIG_COMPAT_KERNEL_2626) += compat-2.6.26.o
+compat-$(CONFIG_COMPAT_KERNEL_2627) += compat-2.6.27.o
+compat-$(CONFIG_COMPAT_KERNEL_2628) += compat-2.6.28.o
+compat-$(CONFIG_COMPAT_KERNEL_2629) += compat-2.6.29.o
+compat-$(CONFIG_COMPAT_KERNEL_2632) += compat-2.6.32.o
+compat-$(CONFIG_COMPAT_KERNEL_2633) += compat-2.6.33.o
+compat-$(CONFIG_COMPAT_KERNEL_2635) += compat-2.6.35.o
+compat-$(CONFIG_COMPAT_KERNEL_2636) += \
 	compat-2.6.36.o \
 	kfifo.o
 
-compat-$(CONFIG_COMPAT_KERNEL_37) += compat-2.6.37.o
-compat-$(CONFIG_COMPAT_KERNEL_38) += compat-2.6.38.o
-compat-$(CONFIG_COMPAT_KERNEL_39) += \
+compat-$(CONFIG_COMPAT_KERNEL_2637) += compat-2.6.37.o
+compat-$(CONFIG_COMPAT_KERNEL_2638) += compat-2.6.38.o
+compat-$(CONFIG_COMPAT_KERNEL_2639) += \
 	compat-2.6.39.o \
 	kstrtox.o
 
-- 
1.7.4.1

