Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f176.google.com ([74.125.82.176]:56945 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756052AbaITSZl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 20 Sep 2014 14:25:41 -0400
Received: by mail-we0-f176.google.com with SMTP id w61so272932wes.7
        for <linux-wireless@vger.kernel.org>; Sat, 20 Sep 2014 11:25:40 -0700 (PDT)
From: Yegor Yefremov <yegorslists@googlemail.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net,
	Yegor Yefremov <yegorslists@googlemail.com>
Subject: [PATCH 1/2] iw: remove double break
Date: Sat, 20 Sep 2014 20:25:24 +0200
Message-Id: <1411237525-5810-1-git-send-email-yegorslists@googlemail.com> (sfid-20140920_202552_007613_841D0ED4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Yegor Yefremov <yegorslists@googlemail.com>
---
 event.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/event.c b/event.c
index d903f9e..25f8099 100644
--- a/event.c
+++ b/event.c
@@ -80,7 +80,6 @@ static void print_frame(struct print_event_args *args, struct nlattr *attr)
 		tmp = (frame[29] << 8) + frame[28];
 		printf(" status: %d: %s", tmp, get_status_str(tmp));
 		break;
-		break;
 	case 0xa0: /* disassoc */
 	case 0xc0: /* deauth */
 		/* reason */
-- 
1.8.3.2

