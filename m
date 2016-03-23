Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37438 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752861AbcCWCYG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Mar 2016 22:24:06 -0400
Subject: patch "staging: refresh TODO for rtl8712" added to staging-linus
To: xose.vazquez@gmail.com, Joshua.Roys@gtri.gatech.edu,
	Larry.Finger@lwfinger.net, chunkeey@googlemail.com,
	driverdev-devel@linuxdriverproject.org,
	florian.c.schilhabel@googlemail.com, gregkh@linuxfoundation.org,
	linux-wireless@vger.kernel.org
From: <gregkh@linuxfoundation.org>
Date: Tue, 22 Mar 2016 22:24:03 -0400
Message-ID: <145869984324580@kroah.com> (sfid-20160323_032411_684427_D20C2E4D)
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


This is a note to let you know that I've just added the patch titled

    staging: refresh TODO for rtl8712

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


>From 586add48d4a627424ff996277fc47e4ee8c69126 Mon Sep 17 00:00:00 2001
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Date: Mon, 14 Mar 2016 15:50:07 +0100
Subject: staging: refresh TODO for rtl8712

People should not waste time and energy working on this staging driver.
At least four drivers were written for this hardware:
 https://marc.info/?l=linux-wireless&m=138358275410975
And there is a replacement using the kernel wireless stack at:
 https://github.com/chunkeey/rtl8192su
Also a fullmac/cfg80211 driver(r92su) is available.

Cc: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Florian Schilhabel <florian.c.schilhabel@googlemail.com>
Cc: Christian Lamparter <chunkeey@googlemail.com>
Cc: Joshua Roys <Joshua.Roys@gtri.gatech.edu>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Linux Driver Project Developer List <driverdev-devel@linuxdriverproject.org>
Cc: Linux Wireless <linux-wireless@vger.kernel.org>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/rtl8712/TODO | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/rtl8712/TODO b/drivers/staging/rtl8712/TODO
index d8dfe5bfe702..847c8c41f4f7 100644
--- a/drivers/staging/rtl8712/TODO
+++ b/drivers/staging/rtl8712/TODO
@@ -4,10 +4,10 @@ TODO:
 - switch to use MAC80211
 - checkpatch.pl fixes - only a few remain
 
-Please send any patches to Greg Kroah-Hartman <greg@kroah.com>,
-Larry Finger <Larry.Finger@lwfinger.net> and
-Florian Schilhabel <florian.c.schilhabel@googlemail.com>.
-
-
-
+A replacement for this driver with MAC80211 support is available
+at https://github.com/chunkeey/rtl8192su
 
+Please send any patches to Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
+Larry Finger <Larry.Finger@lwfinger.net>,
+Florian Schilhabel <florian.c.schilhabel@googlemail.com> and
+Linux Driver Project Developer List <driverdev-devel@linuxdriverproject.org>.
-- 
2.7.4


