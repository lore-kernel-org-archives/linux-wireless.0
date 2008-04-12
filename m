Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.168]:51944 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753454AbYDLRWX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Apr 2008 13:22:23 -0400
Received: by ug-out-1314.google.com with SMTP id z38so132317ugc.16
        for <linux-wireless@vger.kernel.org>; Sat, 12 Apr 2008 10:22:21 -0700 (PDT)
To: "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org
Subject: [PATCH] Add rfkill to MAINTAINERS file
Date: Sat, 12 Apr 2008 19:23:55 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200804121923.55933.IvDoorn@gmail.com> (sfid-20080412_182238_805320_B62AF59A)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I have been acting as the maintainer since the rfkill introduction,
so lets make it official by adding a rfkill entry in the MAINTAINERS file.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>

---
diff --git a/MAINTAINERS b/MAINTAINERS
index 9e63f16..9f5aaff 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3342,6 +3342,13 @@ L:	reiserfs-devel@vger.kernel.org
 W:	http://www.namesys.com
 S:	Supported
 
+RFKILL
+P:	Ivo van Doorn
+M:	IvDoorn@gmail.com
+L:	netdev@vger.kernel.org
+S:	Maintained
+F:	net/rfkill
+
 ROCKETPORT DRIVER
 P:	Comtrol Corp.
 W:	http://www.comtrol.com
