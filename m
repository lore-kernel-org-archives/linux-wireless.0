Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f48.google.com ([209.85.220.48]:33490 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751982AbbJUME4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Oct 2015 08:04:56 -0400
Received: by pabrc13 with SMTP id rc13so53435954pab.0
        for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2015 05:04:55 -0700 (PDT)
From: Ola Olsson <ola1olsson@gmail.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, Ola Olsson <ola1olsson@gmail.com>,
	Ola Olsson <ola.olsson@sonymobile.com>
Subject: [PATCH] iw: remove superfluous includes
Date: Wed, 21 Oct 2015 14:04:37 +0200
Message-Id: <1445429077-21719-1-git-send-email-ola1olsson@gmail.com> (sfid-20151021_140459_039816_79E4D605)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Ola Olsson <ola.olsson@sonymobile.com>
---
 coalesce.c |    2 --
 info.c     |    1 -
 link.c     |    1 -
 mpp.c      |    1 -
 p2p.c      |    3 ---
 scan.c     |    1 -
 survey.c   |    2 --
 7 files changed, 11 deletions(-)

diff --git a/coalesce.c b/coalesce.c
index fabf44a..36dcaef 100644
--- a/coalesce.c
+++ b/coalesce.c
@@ -8,8 +8,6 @@
 #include <netlink/msg.h>
 #include <netlink/attr.h>
 
-#include <arpa/inet.h>
-
 #include "nl80211.h"
 #include "iw.h"
 
diff --git a/info.c b/info.c
index 4ac1eab..d724ca2 100644
--- a/info.c
+++ b/info.c
@@ -1,5 +1,4 @@
 #include <stdbool.h>
-#include <errno.h>
 
 #include <netlink/genl/genl.h>
 #include <netlink/genl/family.h>
diff --git a/link.c b/link.c
index f3bde51..0a32392 100644
--- a/link.c
+++ b/link.c
@@ -1,7 +1,6 @@
 #include <net/if.h>
 #include <errno.h>
 #include <string.h>
-#include <ctype.h>
 #include <stdbool.h>
 
 #include <netlink/genl/genl.h>
diff --git a/mpp.c b/mpp.c
index 8859fd5..58bf28e 100644
--- a/mpp.c
+++ b/mpp.c
@@ -1,6 +1,5 @@
 #include <net/if.h>
 #include <errno.h>
-#include <string.h>
 
 #include <netlink/genl/genl.h>
 #include <netlink/genl/family.h>
diff --git a/p2p.c b/p2p.c
index 2067916..2d4bab0 100644
--- a/p2p.c
+++ b/p2p.c
@@ -1,6 +1,3 @@
-#include <errno.h>
-#include <string.h>
-
 #include <netlink/genl/genl.h>
 #include <netlink/genl/family.h>
 #include <netlink/genl/ctrl.h>
diff --git a/scan.c b/scan.c
index d3c7d98..8762784 100644
--- a/scan.c
+++ b/scan.c
@@ -1,7 +1,6 @@
 #include <net/if.h>
 #include <errno.h>
 #include <string.h>
-#include <ctype.h>
 #include <stdbool.h>
 
 #include <netlink/genl/genl.h>
diff --git a/survey.c b/survey.c
index 3e875a8..9325353 100644
--- a/survey.c
+++ b/survey.c
@@ -1,6 +1,4 @@
 #include <net/if.h>
-#include <errno.h>
-#include <string.h>
 
 #include <netlink/genl/genl.h>
 #include <netlink/genl/family.h>
-- 
1.7.9.5

