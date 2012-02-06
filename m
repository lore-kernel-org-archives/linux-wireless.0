Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:58339 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755326Ab2BFPmh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Feb 2012 10:42:37 -0500
Received: by qcqw6 with SMTP id w6so3440087qcq.19
        for <linux-wireless@vger.kernel.org>; Mon, 06 Feb 2012 07:42:37 -0800 (PST)
From: Rick Farina <sidhayn@gmail.com>
To: mcgrof@gmail.com
Cc: linux-wireless@vger.kernel.org, Rick Farina <sidhayn@gmail.com>
Subject: [PATCH] add missing =y to CONFIG_RT2X00_LIB_DEBUGFS
Date: Mon,  6 Feb 2012 10:42:16 -0500
Message-Id: <1328542936-20963-1-git-send-email-sidhayn@gmail.com> (sfid-20120206_164240_953675_62562151)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When editing config.mk with a sed script the missing =y on this line
causes issue. Since this line is commented out by default this means no
changes to the default behavior and sed scripts will be able to edit the
config.mk file much more easily.

Signed-of-By: Rick Farina <sidhayn@gmail.com>
---
 config.mk |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/config.mk b/config.mk
index 9433ce9..a9d189e 100644
--- a/config.mk
+++ b/config.mk
@@ -639,7 +639,7 @@ CONFIG_RT2X00_LIB_LEDS=y
 endif #CONFIG_LEDS_CLASS
 endif #CONFIG_COMPAT_KERNEL_2_6_25
 # CONFIG_RT2X00_DEBUG=y
-# CONFIG_RT2X00_LIB_DEBUGFS
+# CONFIG_RT2X00_LIB_DEBUGFS=y
 endif
 
 # p54
-- 
1.7.3.4

