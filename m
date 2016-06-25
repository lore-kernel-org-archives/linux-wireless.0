Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:54207 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751188AbcFYWAo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Jun 2016 18:00:44 -0400
From: Luis de Bethencourt <luisbg@osg.samsung.com>
To: linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org, akpm@linux-foundation.org,
	davem@davemloft.net, mchehab@kernel.org,
	linux-wireless@vger.kernel.org, glen.lee@atmel.com,
	Luis de Bethencourt <luisbg@osg.samsung.com>
Subject: [RFC PATCH v2] MAINTAINERS: remove unreachable people that have left Atmel
Date: Sat, 25 Jun 2016 23:00:36 +0100
Message-Id: <1466892036-10619-1-git-send-email-luisbg@osg.samsung.com> (sfid-20160626_000113_281426_D06515BF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When sending an email regarding a patch to wilc1000, you get the following
automatic replies:
"Sung_hoon Cho is no longer with Atmel Corporation."
"Kang_hee Park is no longer with Atmel Corporation."
"Dong_ho Shin is no longer with Atmel Corporation."
"Bo_moon Kim is no longer with Atmel Corporation."
"Min_su Kim is no longer with Atmel Corporation."
"Jun_hyuk Lee is no longer with Atmel Corporation."

Removing these email addresses that don't reach the addressee anymore.

Signed-off-by: Luis de Bethencourt <luisbg@osg.samsung.com>
---

Hi,

Just got the same automatic reply from Glen Lee's address.

This is unfortunate since it means this driver has no maintainer listed.
What do people suggest to do in this case?

I can't find an alternative email address for any of them.

Thanks,
Luis

 MAINTAINERS | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index fe8ac28..2c713fc 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -11080,12 +11080,6 @@ S:	Odd Fixes
 F:	drivers/staging/vt665?/
 
 STAGING - WILC1000 WIFI DRIVER
-M:	Johnny Kim <johnny.kim@atmel.com>
-M:	Austin Shin <austin.shin@atmel.com>
-M:	Chris Park <chris.park@atmel.com>
-M:	Tony Cho <tony.cho@atmel.com>
-M:	Glen Lee <glen.lee@atmel.com>
-M:	Leo Kim <leo.kim@atmel.com>
 L:	linux-wireless@vger.kernel.org
 S:	Supported
 F:	drivers/staging/wilc1000/
-- 
2.5.1

