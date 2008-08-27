Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:45686 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755355AbYH0QyI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Aug 2008 12:54:08 -0400
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] b43: Implement dynamic PHY API
Date: Wed, 27 Aug 2008 18:53:02 +0200
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Message-Id: <200808271853.02849.mb@bu3sch.de> (sfid-20080827_185416_586879_59911B04)
Content-Type: text/plain;
  charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch implements a dynamic "ops" based PHY API.
This is needed in order to conveniently support future PHY types
to avoid the "switch"-hell.

This patch does not change any functionality. It just moves lots
of code from one place to another and adjusts it for the changed
data structures.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

---

Due to the size, this patch is not inlined.
Please find it here:
http://bu3sch.de/patches/wireless-testing/20080827-1750/patches/003-b43-phy-ops.patch

You may notice that after this patch is applied the file "phy.c" will
still contain some unused code.
This will be fixed in a future patch by moving that code to "phy_a.c".
I do not want to further bloat this patch. It's already big enough.

I'm sorry for pushing such a big patch upstream. :)

Please apply for the next bugfix push, if you want to get Dave _really_ mad.
Apply to 2.6.28, if you decide that he would probably kill you. ;)
(I think he would *hint*)
