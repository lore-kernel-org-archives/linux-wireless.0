Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:45244 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753809Ab2DSLyh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Apr 2012 07:54:37 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, libertas-dev@lists.infradead.org,
	dcbw@redhat.com
Subject: [PATCH] libertas: add missing include
Date: Thu, 19 Apr 2012 13:54:12 +0200
Message-Id: <1334836452-75639-1-git-send-email-nbd@openwrt.org> (sfid-20120419_135441_154772_3032259B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Without it, I get compile errors due to missing TASK_NORMAL,
TASK_UNINTERRUPTIBLE and schedule.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/libertas/firmware.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/libertas/firmware.c b/drivers/net/wireless/libertas/firmware.c
index cd23f1a..77f6504 100644
--- a/drivers/net/wireless/libertas/firmware.c
+++ b/drivers/net/wireless/libertas/firmware.c
@@ -5,6 +5,7 @@
 #include <linux/firmware.h>
 #include <linux/firmware.h>
 #include <linux/module.h>
+#include <linux/sched.h>
 
 #include "dev.h"
 #include "decl.h"
-- 
1.7.3.2

