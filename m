Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:43471 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751960Ab1KQVXs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Nov 2011 16:23:48 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com, mcgrof@qca.qualcomm.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 1/3] compat-wireless: add support for kernel 3.2
Date: Thu, 17 Nov 2011 22:23:39 +0100
Message-Id: <1321565021-7290-1-git-send-email-hauke@hauke-m.de> (sfid-20111117_222351_965327_0CD3F0A9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Increase the maximum supported kernel version and generate COMPAT_3_3.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 config.mk |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/config.mk b/config.mk
index a71de4e..a7be820 100644
--- a/config.mk
+++ b/config.mk
@@ -16,7 +16,7 @@ endif
 
 ifneq ($(wildcard $(KLIB_BUILD)/Makefile),)
 
-COMPAT_LATEST_VERSION = 1
+COMPAT_LATEST_VERSION = 3
 
 KERNEL_VERSION := $(shell $(MAKE) -C $(KLIB_BUILD) kernelversion | sed -n 's/^\([0-9]\)\..*/\1/p')
 
-- 
1.7.4.1

