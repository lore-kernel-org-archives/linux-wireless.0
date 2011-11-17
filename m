Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:34318 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751345Ab1KQWWP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Nov 2011 17:22:15 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: Hauke Mehrtens <hauke@hauke-m.de>,
	"Luis R. Rodriguez" <lrodriguez@qca.qualcomm.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH v2 1/4] compat-wireless: add CONFIG_COMPAT_KFIFO setting to config.mk
Date: Thu, 17 Nov 2011 17:21:08 -0500
Message-Id: <1321568471-23068-1-git-send-email-linville@tuxdriver.com> (sfid-20111117_232237_855715_DCE6E1A4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 config.mk |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/config.mk b/config.mk
index a71de4e..1bb2799 100644
--- a/config.mk
+++ b/config.mk
@@ -120,6 +120,10 @@ ifdef CONFIG_FW_LOADER
 endif #CONFIG_FW_LOADER
 endif #CONFIG_COMPAT_KERNEL_2_6_33
 
+ifdef CONFIG_COMPAT_KERNEL_2_6_36
+ CONFIG_COMPAT_KFIFO=y
+endif #CONFIG_COMPAT_KERNEL_2_6_36
+
 # Wireless subsystem stuff
 CONFIG_MAC80211=m
 
-- 
1.7.4.4

