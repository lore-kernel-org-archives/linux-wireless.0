Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:36462 "EHLO
	mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752332AbcCNOyC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Mar 2016 10:54:02 -0400
Received: by mail-wm0-f66.google.com with SMTP id l68so15621991wml.3
        for <linux-wireless@vger.kernel.org>; Mon, 14 Mar 2016 07:54:01 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Florian Schilhabel <florian.c.schilhabel@googlemail.com>,
	Christian Lamparter <chunkeey@googlemail.com>,
	Joshua Roys <Joshua.Roys@gtri.gatech.edu>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Linux Driver Project Developer List
	<driverdev-devel@linuxdriverproject.org>,
	Linux Wireless <linux-wireless@vger.kernel.org>
Subject: [PATCH] staging: refresh TODO for rtl8712
Date: Mon, 14 Mar 2016 15:50:07 +0100
Message-Id: <1457967007-5991-1-git-send-email-xose.vazquez@gmail.com> (sfid-20160314_155406_892904_D51F0CA6)
To: unlisted-recipients:; (no To-header on input)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

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
---
 drivers/staging/rtl8712/TODO | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/rtl8712/TODO b/drivers/staging/rtl8712/TODO
index d8dfe5b..847c8c4 100644
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
2.5.0

