Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f49.google.com ([74.125.83.49]:49462 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751470AbaDSRsf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Apr 2014 13:48:35 -0400
Received: by mail-ee0-f49.google.com with SMTP id c41so2513845eek.36
        for <linux-wireless@vger.kernel.org>; Sat, 19 Apr 2014 10:48:34 -0700 (PDT)
Message-ID: <5352B6EF.1090208@gmail.com> (sfid-20140419_194912_590468_5E3FF382)
Date: Sat, 19 Apr 2014 19:48:31 +0200
From: Gertjan van Wingerde <gwingerde@gmail.com>
MIME-Version: 1.0
To: John W Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
CC: Ivo Van Doorn <ivdoorn@gmail.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	Stanislaw Gruszka <sgruszka@redhat.com>,
	"users@rt2x00.serialmonkey.com" <users@rt2x00.serialmonkey.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>
Subject: [PATCH] rt2x00: Remove myself as maintainer.
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Let's formalize what must have been blatantly clear from my level
of activity is the past year(s).
I simply do not have time for this anymore.

Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
---
 MAINTAINERS | 1 -
 1 file changed, 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 6dc67b1..a80a586 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7277,7 +7277,6 @@ F:        drivers/video/aty/aty128fb.c
 RALINK RT2X00 WIRELESS LAN DRIVER
 P:     rt2x00 project
 M:     Ivo van Doorn <IvDoorn@gmail.com>
-M:     Gertjan van Wingerde <gwingerde@gmail.com>
 M:     Helmut Schaa <helmut.schaa@googlemail.com>
 L:     linux-wireless@vger.kernel.org
 L:     users@rt2x00.serialmonkey.com (moderated for non-subscribers)
-- 
1.8.4.3
