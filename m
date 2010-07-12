Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:33610 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752195Ab0GLRBv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Jul 2010 13:01:51 -0400
Received: by bwz1 with SMTP id 1so2483834bwz.19
        for <linux-wireless@vger.kernel.org>; Mon, 12 Jul 2010 10:01:49 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: [PATCH] p54: update MAINTAINERS
Date: Mon, 12 Jul 2010 19:01:41 +0200
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	Michael Wu <aluminum.tape@gmail.com>
References: <1278947189-14833-1-git-send-email-lrodriguez@atheros.com> <4C3B3342.3060801@lwfinger.net> <20100712152650.GE3492@tux>
In-Reply-To: <20100712152650.GE3492@tux>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201007121901.41717.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael has been out of the scene for a while now,
but despite Michael's absence, p54 is still maintained.

Cc: Michael Wu <aluminum.tape@gmail.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Luis R. Rodriguez <lrodriguez@atheros.com>
Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
diff --git a/MAINTAINERS b/MAINTAINERS
index a07a49d..ece5563 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4270,10 +4270,9 @@ F:	include/scsi/osd_*
 F:	fs/exofs/
 
 P54 WIRELESS DRIVER
-M:	Michael Wu <flamingice@sourmilk.net>
+M:	Christian Lamparter <chunkeey@googlemail.com>
 L:	linux-wireless@vger.kernel.org
-W:	http://prism54.org
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mwu/mac80211-drivers.git
+W:	http://wireless.kernel.org/en/users/Drivers/p54
 S:	Maintained
 F:	drivers/net/wireless/p54/
 
