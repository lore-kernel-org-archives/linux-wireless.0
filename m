Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:41248 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757406AbZAWXDP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jan 2009 18:03:15 -0500
Received: from mail.atheros.com ([10.10.20.107])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 23 Jan 2009 15:03:15 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <johannes@sipsolutions.net>, <johannes@sipsolutions.net>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH] iw: fix typo, add few references
Date: Fri, 23 Jan 2009 15:02:38 -0800
Message-ID: <1232751758-23329-1-git-send-email-lrodriguez@atheros.com> (sfid-20090124_000320_851339_7C3D56DE)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This fixes a small typo s/ip/iw, and adds references
to the other new wireless subsystem userspace applications/files.
Lets also point users to the iw wiki as it has lots of good stuff.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 iw.8 |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/iw.8 b/iw.8
index 4d13667..2dc57a9 100644
--- a/iw.8
+++ b/iw.8
@@ -6,7 +6,7 @@ iw \- show / manipulate wireless devices and their configuration
 .ad l
 .in +8
 .ti -8
-.B ip
+.B iw
 .RI [ " OPTIONS " ] " " { " 
 .BR help " |"
 .RI ""OBJECT " " COMMAND " }"
@@ -57,3 +57,8 @@ will print all supported commands.
 
 .SH SEE ALSO
 .BR ip (8)
+.BR crda (8)
+.BR regdbdump (8)
+.BR regulatory.bin (5)
+
+.BR http://wireless.kernel.org/en/users/Documentation/iw
-- 
1.6.1.rc3.51.g5832d

