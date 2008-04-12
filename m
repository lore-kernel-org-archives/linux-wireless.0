Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.153]:24392 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754330AbYDLRXb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Apr 2008 13:23:31 -0400
Received: by fg-out-1718.google.com with SMTP id l27so831221fgb.17
        for <linux-wireless@vger.kernel.org>; Sat, 12 Apr 2008 10:23:26 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
Subject: [PATCH] Update rt2x00 MAINTAINERS entry
Date: Sat, 12 Apr 2008 19:25:00 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200804121925.00880.IvDoorn@gmail.com> (sfid-20080412_182335_480434_0A723E1F)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add the tree entry for rt2x00 to inform people about the
rt2x00.git tree.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
diff --git a/MAINTAINERS b/MAINTAINERS
index 9e63f16..906b352 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3280,6 +3280,7 @@ L:	linux-wireless@vger.kernel.org
 L:	rt2400-devel@lists.sourceforge.net
 W:	http://rt2x00.serialmonkey.com/
 S:	Maintained
+T:	git kernel.org:/pub/scm/linux/kernel/git/ivd/rt2x00.git
 F:	drivers/net/wireless/rt2x00/
 
 RAMDISK RAM BLOCK DEVICE DRIVER
