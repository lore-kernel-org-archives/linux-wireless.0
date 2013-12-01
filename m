Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53084 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750900Ab3LAGk6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Dec 2013 01:40:58 -0500
Received: by mail-pb0-f46.google.com with SMTP id md12so16907074pbc.33
        for <linux-wireless@vger.kernel.org>; Sat, 30 Nov 2013 22:40:57 -0800 (PST)
From: Ujjal Roy <royujjal@gmail.com>
To: "'John W. Linville" <linville@tuxdriver.com>
Cc: ' <linux-wireless@vger.kernel.org>,
	'Johannes Berg <johannes@sipsolutions.net>,
	Ujjal Roy <royujjal@gmail.com>
Subject: TEST: testing how to send a patch from git repository
Date: Sun,  1 Dec 2013 12:10:49 +0530
Message-Id: <1385880049-5710-1-git-send-email-royujjal@gmail.com> (sfid-20131201_074113_494812_A938E3A6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Testing how to send an email through git to see the patch is exactly
submitted or not. Actually testing the tab characters. Please don't
mind.

Signed-off-by: Ujjal Roy <royujjal@gmail.com>
---
 net/wireless/sme.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/wireless/sme.c b/net/wireless/sme.c
index 5eeb8e0..19a5df4 100644
--- a/net/wireless/sme.c
+++ b/net/wireless/sme.c
@@ -20,6 +20,8 @@
 #include "reg.h"
 #include "rdev-ops.h"
 
+	printk("TEST: submitting patch from git >> Ujjal Roy C: royujjal@gmail.com");
+
 /*
  * Software SME in cfg80211, using auth/assoc/deauth calls to the
  * driver. This is is for implementing nl80211's connect/disconnect
-- 
1.8.3.1

