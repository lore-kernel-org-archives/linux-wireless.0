Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:60531 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753413Ab1FBQf4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Jun 2011 12:35:56 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com, lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 9/9] compat-wireless: update enable-older-kernels patches
Date: Thu,  2 Jun 2011 18:35:25 +0200
Message-Id: <1307032525-18916-10-git-send-email-hauke@hauke-m.de> (sfid-20110602_183607_374568_99576BD1)
In-Reply-To: <1307032525-18916-1-git-send-email-hauke@hauke-m.de>
References: <1307032525-18916-1-git-send-email-hauke@hauke-m.de>
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
index 2c16809..b370483 100644
--- a/enable-older-kernels/enable-2.6.21.patch
+++ b/enable-older-kernels/enable-2.6.21.patch
@@ -1,15 +1,15 @@
 --- a/config.mk
 +++ b/config.mk
-@@ -25,9 +25,9 @@
+@@ -32,9 +32,9 @@ endif
  COMPAT_VERSIONS := $(shell I=$(COMPAT_LATEST_VERSION); while [ "$$I" -gt $(KERNEL_SUBLEVEL) ]; do echo $$I; I=$$(($$I - 1)); done)
- $(foreach ver,$(COMPAT_VERSIONS),$(eval CONFIG_COMPAT_KERNEL_$(ver)=y))
+ $(foreach ver,$(COMPAT_VERSIONS),$(eval CONFIG_COMPAT_KERNEL_3$(ver)=y))
  
--ifdef CONFIG_COMPAT_KERNEL_24
+-ifdef CONFIG_COMPAT_KERNEL_2624
 -$(error "ERROR: compat-wireless by default supports kernels >= 2.6.24, try enabling only one driver though")
--endif #CONFIG_COMPAT_KERNEL_24
-+ifdef CONFIG_COMPAT_KERNEL_21
+-endif #CONFIG_COMPAT_KERNEL_2624
++ifdef CONFIG_COMPAT_KERNEL_2621
 +$(error "ERROR: compat-wireless by default supports kernels >= 2.6.21, try enabling only one driver though")
-+endif #CONFIG_COMPAT_KERNEL_21
++endif #CONFIG_COMPAT_KERNEL_2621
  
  ifeq ($(CONFIG_CFG80211),y)
  $(error "ERROR: your kernel has CONFIG_CFG80211=y, you should have it CONFIG_CFG80211=m if you want to use this thing.")
diff --git a/enable-older-kernels/enable-2.6.22.patch b/enable-older-kernels/enable-2.6.22.patch
index 92150e9..28a0d70 100644
--- a/enable-older-kernels/enable-2.6.22.patch
+++ b/enable-older-kernels/enable-2.6.22.patch
@@ -1,15 +1,15 @@
 --- a/config.mk
 +++ b/config.mk
-@@ -25,9 +25,9 @@
+@@ -32,9 +32,9 @@ endif
  COMPAT_VERSIONS := $(shell I=$(COMPAT_LATEST_VERSION); while [ "$$I" -gt $(KERNEL_SUBLEVEL) ]; do echo $$I; I=$$(($$I - 1)); done)
- $(foreach ver,$(COMPAT_VERSIONS),$(eval CONFIG_COMPAT_KERNEL_$(ver)=y))
+ $(foreach ver,$(COMPAT_VERSIONS),$(eval CONFIG_COMPAT_KERNEL_3$(ver)=y))
  
--ifdef CONFIG_COMPAT_KERNEL_24
+-ifdef CONFIG_COMPAT_KERNEL_2624
 -$(error "ERROR: compat-wireless by default supports kernels >= 2.6.24, try enabling only one driver though")
--endif #CONFIG_COMPAT_KERNEL_24
-+ifdef CONFIG_COMPAT_KERNEL_22
+-endif #CONFIG_COMPAT_KERNEL_2624
++ifdef CONFIG_COMPAT_KERNEL_2622
 +$(error "ERROR: compat-wireless by default supports kernels >= 2.6.22, try enabling only one driver though")
-+endif #CONFIG_COMPAT_KERNEL_22
++endif #CONFIG_COMPAT_KERNEL_2622
  
  ifeq ($(CONFIG_CFG80211),y)
  $(error "ERROR: your kernel has CONFIG_CFG80211=y, you should have it CONFIG_CFG80211=m if you want to use this thing.")
diff --git a/enable-older-kernels/enable-2.6.23.patch b/enable-older-kernels/enable-2.6.23.patch
index 6266c17..a228b65 100644
--- a/enable-older-kernels/enable-2.6.23.patch
+++ b/enable-older-kernels/enable-2.6.23.patch
@@ -1,15 +1,15 @@
 --- a/config.mk
 +++ b/config.mk
-@@ -25,9 +25,9 @@
+@@ -32,9 +32,9 @@ endif
  COMPAT_VERSIONS := $(shell I=$(COMPAT_LATEST_VERSION); while [ "$$I" -gt $(KERNEL_SUBLEVEL) ]; do echo $$I; I=$$(($$I - 1)); done)
- $(foreach ver,$(COMPAT_VERSIONS),$(eval CONFIG_COMPAT_KERNEL_$(ver)=y))
+ $(foreach ver,$(COMPAT_VERSIONS),$(eval CONFIG_COMPAT_KERNEL_3$(ver)=y))
  
--ifdef CONFIG_COMPAT_KERNEL_24
+-ifdef CONFIG_COMPAT_KERNEL_2624
 -$(error "ERROR: compat-wireless by default supports kernels >= 2.6.24, try enabling only one driver though")
--endif #CONFIG_COMPAT_KERNEL_24
-+ifdef CONFIG_COMPAT_KERNEL_23
+-endif #CONFIG_COMPAT_KERNEL_2624
++ifdef CONFIG_COMPAT_KERNEL_2623
 +$(error "ERROR: compat-wireless by default supports kernels >= 2.6.23, try enabling only one driver though")
-+endif #CONFIG_COMPAT_KERNEL_23
++endif #CONFIG_COMPAT_KERNEL_2623
  
  ifeq ($(CONFIG_CFG80211),y)
  $(error "ERROR: your kernel has CONFIG_CFG80211=y, you should have it CONFIG_CFG80211=m if you want to use this thing.")
-- 
1.7.4.1

