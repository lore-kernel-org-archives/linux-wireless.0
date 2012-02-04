Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:60041 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751518Ab2BDB0R (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Feb 2012 20:26:17 -0500
Received: by mail-pw0-f46.google.com with SMTP id u11so3334452pbd.19
        for <linux-wireless@vger.kernel.org>; Fri, 03 Feb 2012 17:26:17 -0800 (PST)
From: "Luis R. Rodriguez" <mcgrof@frijolero.org>
To: linux-wireless@vger.kernel.org
Cc: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Subject: [RFC 08/11] crda: clean header files
Date: Fri,  3 Feb 2012 17:25:45 -0800
Message-Id: <1328318748-21044-9-git-send-email-mcgrof@frijolero.org> (sfid-20120204_022626_149822_0587EC95)
In-Reply-To: <1328318748-21044-1-git-send-email-mcgrof@frijolero.org>
References: <1328318748-21044-1-git-send-email-mcgrof@frijolero.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove unused headers now that we have an object
(soon to be library) using what it has to separately.

Signed-off-by: Luis R. Rodriguez <mcgrof@frijolero.org>
---
 crda.c      |    3 ---
 intersect.c |    3 ---
 regdbdump.c |    3 ---
 3 files changed, 0 insertions(+), 9 deletions(-)

diff --git a/crda.c b/crda.c
index 344fd60..c6dc3d4 100644
--- a/crda.c
+++ b/crda.c
@@ -6,8 +6,6 @@
 
 #include <errno.h>
 #include <stdio.h>
-#include <sys/mman.h>
-#include <sys/stat.h>
 #include <fcntl.h>
 #include <arpa/inet.h>
 #include <unistd.h>
@@ -19,7 +17,6 @@
 #include <netlink/attr.h>
 #include "nl80211.h"
 
-#include "regdb.h"
 #include "reglib.h"
 
 #if !defined(CONFIG_LIBNL20) && !defined(CONFIG_LIBNL30) && !defined(CONFIG_LIBNL32)
diff --git a/intersect.c b/intersect.c
index 6d3d393..012750d 100644
--- a/intersect.c
+++ b/intersect.c
@@ -1,9 +1,6 @@
 #include <errno.h>
 #include <stdlib.h>
 #include <stdio.h>
-#include <sys/mman.h>
-#include <sys/stat.h>
-#include <fcntl.h>
 #include <arpa/inet.h> /* ntohl */
 #include <string.h>
 
diff --git a/regdbdump.c b/regdbdump.c
index 6d4cf56..6f9592a 100644
--- a/regdbdump.c
+++ b/regdbdump.c
@@ -1,7 +1,4 @@
-#include <errno.h>
 #include <stdio.h>
-
-#include "regdb.h"
 #include "reglib.h"
 
 int main(int argc, char **argv)
-- 
1.7.4.15.g7811d

