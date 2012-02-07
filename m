Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog125.obsmtp.com ([74.125.149.153]:45138 "EHLO
	na3sys009aog125.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753706Ab2BGKjh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Feb 2012 05:39:37 -0500
Received: by mail-lpp01m010-f49.google.com with SMTP id m7so5539372laa.22
        for <linux-wireless@vger.kernel.org>; Tue, 07 Feb 2012 02:39:36 -0800 (PST)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: coelho@ti.com
Subject: [PATCH] wl12xx: fix typo in fwlog module param description
Date: Tue,  7 Feb 2012 12:39:28 +0200
Message-Id: <1328611168-22994-1-git-send-email-coelho@ti.com> (sfid-20120207_113941_113563_9531F53D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix a copy and paste bug in the MODULE_PARAM_DESC for fwlog.

Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/wl12xx/main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index b9c70c6..eb3eaae 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -5443,7 +5443,7 @@ module_param_named(debug_level, wl12xx_debug_level, uint, S_IRUSR | S_IWUSR);
 MODULE_PARM_DESC(debug_level, "wl12xx debugging level");
 
 module_param_named(fwlog, fwlog_param, charp, 0);
-MODULE_PARM_DESC(keymap,
+MODULE_PARM_DESC(fwlog,
 		 "FW logger options: continuous, ondemand, dbgpins or disable");
 
 module_param(bug_on_recovery, bool, S_IRUSR | S_IWUSR);
-- 
1.7.5.4

