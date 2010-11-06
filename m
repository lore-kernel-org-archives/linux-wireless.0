Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:33441 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752951Ab0KFOtp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Nov 2010 10:49:45 -0400
Received: by mail-ey0-f174.google.com with SMTP id 27so2216256eye.19
        for <linux-wireless@vger.kernel.org>; Sat, 06 Nov 2010 07:49:44 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 07/18] rt2x00: checkpatch.pl error fixes for rt2800usb.c
Date: Sat, 6 Nov 2010 15:45:41 +0100
Cc: linux-wireless@vger.kernel.org
References: <201011061544.00876.IvDoorn@gmail.com> <201011061545.07105.IvDoorn@gmail.com> <201011061545.23058.IvDoorn@gmail.com>
In-Reply-To: <201011061545.23058.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201011061545.42379.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mark Einon <mark.einon@gmail.com>

 rt2800usb.c:48: ERROR: do not initialise statics to 0 or NULL

Signed-off-by: Mark Einon <mark.einon@gmail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800usb.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index 5c31e33..67a9942 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -45,7 +45,7 @@
 /*
  * Allow hardware encryption to be disabled.
  */
-static int modparam_nohwcrypt = 0;
+static int modparam_nohwcrypt;
 module_param_named(nohwcrypt, modparam_nohwcrypt, bool, S_IRUGO);
 MODULE_PARM_DESC(nohwcrypt, "Disable hardware encryption.");
 
-- 
1.7.2.3

