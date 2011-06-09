Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:33088 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756751Ab1FIWEU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jun 2011 18:04:20 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com, lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, jonas.gorski@gmail.com,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 09/11] compat-wireless: update enable-older-kernels patches
Date: Fri, 10 Jun 2011 00:03:40 +0200
Message-Id: <1307657022-23808-10-git-send-email-hauke@hauke-m.de> (sfid-20110610_000437_665644_6578DAF8)
In-Reply-To: <1307657022-23808-1-git-send-email-hauke@hauke-m.de>
References: <1307657022-23808-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add to compat-3.0-stable

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 enable-older-kernels/enable-2.6.21.patch |   12 ++++++------
 enable-older-kernels/enable-2.6.22.patch |   12 ++++++------
 enable-older-kernels/enable-2.6.23.patch |   12 ++++++------
 3 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/enable-older-kernels/enable-2.6.21.patch b/enable-older-kernels/enable-2.6.21.patch
index 2c16809..44a1bb2 100644
--- a/enable-older-kernels/enable-2.6.21.patch
+++ b/enable-older-kernels/enable-2.6.21.patch
@@ -1,15 +1,15 @@
 --- a/config.mk
 +++ b/config.mk
-@@ -25,9 +25,9 @@
+@@ -33,9 +33,9 @@ endif
  COMPAT_VERSIONS := $(shell I=$(COMPAT_LATEST_VERSION); while [ "$$I" -gt $(KERNEL_SUBLEVEL) ]; do echo $$I; I=$$(($$I - 1)); done)
- $(foreach ver,$(COMPAT_VERSIONS),$(eval CONFIG_COMPAT_KERNEL_$(ver)=y))
+ $(foreach ver,$(COMPAT_VERSIONS),$(eval CONFIG_COMPAT_KERNEL_3_$(ver)=y))
  
--ifdef CONFIG_COMPAT_KERNEL_24
+-ifdef CONFIG_COMPAT_KERNEL_2_6_24
 -$(error "ERROR: compat-wireless by default supports kernels >= 2.6.24, try enabling only one driver though")
--endif #CONFIG_COMPAT_KERNEL_24
-+ifdef CONFIG_COMPAT_KERNEL_21
+-endif #CONFIG_COMPAT_KERNEL_2_6_24
++ifdef CONFIG_COMPAT_KERNEL_2_6_21
 +$(error "ERROR: compat-wireless by default supports kernels >= 2.6.21, try enabling only one driver though")
-+endif #CONFIG_COMPAT_KERNEL_21
++endif #CONFIG_COMPAT_KERNEL_2_6_21
  
  ifeq ($(CONFIG_CFG80211),y)
  $(error "ERROR: your kernel has CONFIG_CFG80211=y, you should have it CONFIG_CFG80211=m if you want to use this thing.")
diff --git a/enable-older-kernels/enable-2.6.22.patch b/enable-older-kernels/enable-2.6.22.patch
index 92150e9..1273824 100644
--- a/enable-older-kernels/enable-2.6.22.patch
+++ b/enable-older-kernels/enable-2.6.22.patch
@@ -1,15 +1,15 @@
 --- a/config.mk
 +++ b/config.mk
-@@ -25,9 +25,9 @@
+@@ -33,9 +33,9 @@ endif
  COMPAT_VERSIONS := $(shell I=$(COMPAT_LATEST_VERSION); while [ "$$I" -gt $(KERNEL_SUBLEVEL) ]; do echo $$I; I=$$(($$I - 1)); done)
- $(foreach ver,$(COMPAT_VERSIONS),$(eval CONFIG_COMPAT_KERNEL_$(ver)=y))
+ $(foreach ver,$(COMPAT_VERSIONS),$(eval CONFIG_COMPAT_KERNEL_3_$(ver)=y))
  
--ifdef CONFIG_COMPAT_KERNEL_24
+-ifdef CONFIG_COMPAT_KERNEL_2_6_24
 -$(error "ERROR: compat-wireless by default supports kernels >= 2.6.24, try enabling only one driver though")
--endif #CONFIG_COMPAT_KERNEL_24
-+ifdef CONFIG_COMPAT_KERNEL_22
+-endif #CONFIG_COMPAT_KERNEL_2_6_24
++ifdef CONFIG_COMPAT_KERNEL_2_6_22
 +$(error "ERROR: compat-wireless by default supports kernels >= 2.6.22, try enabling only one driver though")
-+endif #CONFIG_COMPAT_KERNEL_22
++endif #CONFIG_COMPAT_KERNEL_2_6_22
  
  ifeq ($(CONFIG_CFG80211),y)
  $(error "ERROR: your kernel has CONFIG_CFG80211=y, you should have it CONFIG_CFG80211=m if you want to use this thing.")
diff --git a/enable-older-kernels/enable-2.6.23.patch b/enable-older-kernels/enable-2.6.23.patch
index 6266c17..7a95842 100644
--- a/enable-older-kernels/enable-2.6.23.patch
+++ b/enable-older-kernels/enable-2.6.23.patch
@@ -1,15 +1,15 @@
 --- a/config.mk
 +++ b/config.mk
-@@ -25,9 +25,9 @@
+@@ -33,9 +33,9 @@ endif
  COMPAT_VERSIONS := $(shell I=$(COMPAT_LATEST_VERSION); while [ "$$I" -gt $(KERNEL_SUBLEVEL) ]; do echo $$I; I=$$(($$I - 1)); done)
- $(foreach ver,$(COMPAT_VERSIONS),$(eval CONFIG_COMPAT_KERNEL_$(ver)=y))
+ $(foreach ver,$(COMPAT_VERSIONS),$(eval CONFIG_COMPAT_KERNEL_3_$(ver)=y))
  
--ifdef CONFIG_COMPAT_KERNEL_24
+-ifdef CONFIG_COMPAT_KERNEL_2_6_24
 -$(error "ERROR: compat-wireless by default supports kernels >= 2.6.24, try enabling only one driver though")
--endif #CONFIG_COMPAT_KERNEL_24
-+ifdef CONFIG_COMPAT_KERNEL_23
+-endif #CONFIG_COMPAT_KERNEL_2_6_24
++ifdef CONFIG_COMPAT_KERNEL_2_6_23
 +$(error "ERROR: compat-wireless by default supports kernels >= 2.6.23, try enabling only one driver though")
-+endif #CONFIG_COMPAT_KERNEL_23
++endif #CONFIG_COMPAT_KERNEL_2_6_23
  
  ifeq ($(CONFIG_CFG80211),y)
  $(error "ERROR: your kernel has CONFIG_CFG80211=y, you should have it CONFIG_CFG80211=m if you want to use this thing.")
-- 
1.7.4.1

