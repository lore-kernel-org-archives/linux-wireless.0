Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:55937 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752789Ab0KTMGN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 20 Nov 2010 07:06:13 -0500
Received: by pvh1 with SMTP id 1so861892pvh.19
        for <linux-wireless@vger.kernel.org>; Sat, 20 Nov 2010 04:06:13 -0800 (PST)
From: Huang Weiyi <weiyi.huang@gmail.com>
To: nville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Huang Weiyi <weiyi.huang@gmail.com>
Subject: [PATCH 2/4] libertas: remove duplicated #include
Date: Sat, 20 Nov 2010 20:06:02 +0800
Message-Id: <1290254762-5036-1-git-send-email-weiyi.huang@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove duplicated #include('s) in
  drivers/net/wireless/libertas/cfg.c

Signed-off-by: Huang Weiyi <weiyi.huang@gmail.com>
---
 drivers/net/wireless/libertas/cfg.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/libertas/cfg.c b/drivers/net/wireless/libertas/cfg.c
index 373930a..efedcb7 100644
--- a/drivers/net/wireless/libertas/cfg.c
+++ b/drivers/net/wireless/libertas/cfg.c
@@ -9,8 +9,6 @@
 #include <linux/sched.h>
 #include <linux/wait.h>
 #include <linux/slab.h>
-#include <linux/sched.h>
-#include <linux/wait.h>
 #include <linux/ieee80211.h>
 #include <net/cfg80211.h>
 #include <asm/unaligned.h>
-- 
1.6.1.3

