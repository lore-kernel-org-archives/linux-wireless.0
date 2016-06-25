Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:54163 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751209AbcFYVxm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Jun 2016 17:53:42 -0400
From: Luis de Bethencourt <luisbg@osg.samsung.com>
To: linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org, akpm@linux-foundation.org,
	davem@davemloft.net, mchehab@kernel.org,
	linux-wireless@vger.kernel.org, glen.lee@atmel.com,
	Luis de Bethencourt <luisbg@osg.samsung.com>
Subject: [PATCH] MAINTAINERS: remove unreachable people that have left Atmel
Date: Sat, 25 Jun 2016 22:53:35 +0100
Message-Id: <1466891615-9134-1-git-send-email-luisbg@osg.samsung.com> (sfid-20160625_235402_004362_AB5C276C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When sending an email regarding a patch to wilc1000, you get the following
automatic replies:
"Sung_hoon Cho is no longer with Atmel Corporation."
"Kang_hee Park is no longer with Atmel Corporation."
"Dong_ho Shin is no longer with Atmel Corporation."
"Bo_moon Kim is no longer with Atmel Corporation."
"Min_su Kim is no longer with Atmel Corporation."

Removing these email addresses that don't reach the addressees anymore.

Signed-off-by: Luis de Bethencourt <luisbg@osg.samsung.com>
---
 MAINTAINERS | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index fe8ac28..88a898e 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -11080,12 +11080,7 @@ S:	Odd Fixes
 F:	drivers/staging/vt665?/
 
 STAGING - WILC1000 WIFI DRIVER
-M:	Johnny Kim <johnny.kim@atmel.com>
-M:	Austin Shin <austin.shin@atmel.com>
-M:	Chris Park <chris.park@atmel.com>
-M:	Tony Cho <tony.cho@atmel.com>
 M:	Glen Lee <glen.lee@atmel.com>
-M:	Leo Kim <leo.kim@atmel.com>
 L:	linux-wireless@vger.kernel.org
 S:	Supported
 F:	drivers/staging/wilc1000/
-- 
2.5.1

