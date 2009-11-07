Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f207.google.com ([209.85.219.207]:54248 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752361AbZKGSOr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Nov 2009 13:14:47 -0500
Received: by ewy3 with SMTP id 3so2001418ewy.37
        for <linux-wireless@vger.kernel.org>; Sat, 07 Nov 2009 10:14:52 -0800 (PST)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] rt2x00: update MAINTAINERS
Date: Sat, 7 Nov 2009 19:14:47 +0100
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Pavel Machek <pavel@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200911071914.47949.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Although I have always been the active maintainer of the rt2x00 drivers,
I was not mentioned explicitely in the MAINTAINERS file as such.

Update the rt2x00 entry in the MAINTAINERS file to add my name and
email address.
 
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
diff --git a/MAINTAINERS b/MAINTAINERS
index ad845bb..8364ebb 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4309,6 +4309,7 @@ F:	drivers/video/aty/aty128fb.c
 
 RALINK RT2X00 WIRELESS LAN DRIVER
 P:	rt2x00 project
+M:	Ivo van Doorn <IvDoorn@gmail.com>
 L:	linux-wireless@vger.kernel.org
 L:	users@rt2x00.serialmonkey.com (moderated for non-subscribers)
 W:	http://rt2x00.serialmonkey.com/
