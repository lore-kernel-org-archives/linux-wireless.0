Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.169]:22855 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754576AbXHSScN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Aug 2007 14:32:13 -0400
Received: by ug-out-1314.google.com with SMTP id j3so446949ugf
        for <linux-wireless@vger.kernel.org>; Sun, 19 Aug 2007 11:32:12 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 24/30] rt2x00: Add file pattern to MAINTAINER entry
Date: Sun, 19 Aug 2007 20:35:22 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200708192018.30624.IvDoorn@gmail.com>
In-Reply-To: <200708192018.30624.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200708192035.22826.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From 316723f1a0e726defbc2403647a9f81e383c45bb Mon Sep 17 00:00:00 2001
From: Ivo van Doorn <IvDoorn@gmail.com>
Date: Sat, 18 Aug 2007 14:04:26 +0200
Subject: [PATCH 24/30] rt2x00: Add file pattern to MAINTAINER entry

Add file pattern to MAINTAINER entry

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 MAINTAINERS |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index d22d562..f7a67a5 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3135,6 +3135,7 @@ L:	linux-wireless@vger.kernel.org
 L:	rt2400-devel@lists.sourceforge.net
 W:	http://rt2x00.serialmonkey.com/
 S:	Maintained
+F:	drivers/net/wireless/rt2x00/
 
 RANDOM NUMBER DRIVER
 P:	Matt Mackall
-- 
1.5.3.rc5

