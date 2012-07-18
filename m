Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:63705 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750863Ab2GROtU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Jul 2012 10:49:20 -0400
Received: by yhmm54 with SMTP id m54so1626046yhm.19
        for <linux-wireless@vger.kernel.org>; Wed, 18 Jul 2012 07:49:19 -0700 (PDT)
Message-ID: <5006CCE7.8090904@gmail.com> (sfid-20120718_164924_347494_173F0C03)
Date: Wed, 18 Jul 2012 22:49:11 +0800
From: Duan Jiong <djduanjiong@gmail.com>
MIME-Version: 1.0
To: dcbw@redhat.com, linville@tuxdriver.com
CC: libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: [RESEND] firmware.c: remove duplicated include
Content-Type: text/plain; charset=GB2312
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Duan Jiong <djduanjiong@gmail.com>
---
 drivers/net/wireless/libertas/firmware.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/wireless/libertas/firmware.c b/drivers/net/wireless/libertas/firmware.c
index 601f207..c0f9e7e 100644
--- a/drivers/net/wireless/libertas/firmware.c
+++ b/drivers/net/wireless/libertas/firmware.c
@@ -4,9 +4,7 @@
 
 #include <linux/sched.h>
 #include <linux/firmware.h>
-#include <linux/firmware.h>
 #include <linux/module.h>
-#include <linux/sched.h>
 
 #include "dev.h"
 #include "decl.h"
-- 
1.7.9.5

