Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:22019 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751316AbaI1MFc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Sep 2014 08:05:32 -0400
Date: Sun, 28 Sep 2014 14:03:06 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: users@rt2x00.serialmonkey.com, Ivo van Doorn <IvDoorn@gmail.com>
Subject: [PATCH] MAINTAINERS: change rt2x00 maintainer
Message-ID: <20140928120305.GC2702@redhat.com> (sfid-20140928_140535_980398_1AD60E58)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

After short chat with Ivo, we decided that I'll take maintenance
of rt2x00 driver.

Thanks for Ivo's great work in the past!

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 MAINTAINERS | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 79cd603..980f609 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7492,13 +7492,12 @@ F:	drivers/video/fbdev/aty/aty128fb.c
 
 RALINK RT2X00 WIRELESS LAN DRIVER
 P:	rt2x00 project
-M:	Ivo van Doorn <IvDoorn@gmail.com>
+M:	Stanislaw Gruszka <sgruszka@redhat.com>
 M:	Helmut Schaa <helmut.schaa@googlemail.com>
 L:	linux-wireless@vger.kernel.org
 L:	users@rt2x00.serialmonkey.com (moderated for non-subscribers)
 W:	http://rt2x00.serialmonkey.com/
 S:	Maintained
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/ivd/rt2x00.git
 F:	drivers/net/wireless/rt2x00/
 
 RAMDISK RAM BLOCK DEVICE DRIVER
-- 
1.8.3.1

