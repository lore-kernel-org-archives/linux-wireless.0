Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f170.google.com ([209.85.192.170]:40397 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750900Ab3LAGlx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Dec 2013 01:41:53 -0500
Received: by mail-pd0-f170.google.com with SMTP id g10so16071111pdj.15
        for <linux-wireless@vger.kernel.org>; Sat, 30 Nov 2013 22:41:52 -0800 (PST)
From: Ujjal Roy <royujjal@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	Ujjal Roy <royujjal@gmail.com>
Subject: TEST: testing how to send a patch from git repository
Date: Sun,  1 Dec 2013 12:11:46 +0530
Message-Id: <1385880106-5759-1-git-send-email-royujjal@gmail.com> (sfid-20131201_074155_386077_8C366D6A)
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

