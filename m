Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:37103 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751816AbbJDVIl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Oct 2015 17:08:41 -0400
Received: by wicfx3 with SMTP id fx3so89916363wic.0
        for <linux-wireless@vger.kernel.org>; Sun, 04 Oct 2015 14:08:40 -0700 (PDT)
MIME-Version: 1.0
Date: Sun, 4 Oct 2015 23:08:39 +0200
Message-ID: <CABAco3Boow_64N33s=mSu0=K38D00a=OsoSQRJUoMN1_qP_3_A@mail.gmail.com> (sfid-20151004_230847_042944_D63F4E60)
Subject: [PATCH] Remove superfluous header files
From: Ola Olsson <ola1olsson@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

if.h only contains if_nametoindex and the reverse.
Lets remove the inclusion in the source files where
these functions are not called.

Signed-off-by: Ola Olsson <ola.olsson@sonymobile.com>
---
 coalesce.c  |    1 -
 hwsim.c     |    1 -
 info.c      |    1 -
 interface.c |    1 -
 mesh.c      |    1 -
 ocb.c       |    1 -
 p2p.c       |    1 -
 phy.c       |    1 -
 reg.c       |    1 -
 roc.c       |    1 -
 vendor.c    |    1 -
 wowlan.c    |    1 -
 12 files changed, 12 deletions(-)

diff --git a/coalesce.c b/coalesce.c
index 6cdc469..fabf44a 100644
--- a/coalesce.c
+++ b/coalesce.c
@@ -1,4 +1,3 @@
-#include <net/if.h>
 #include <errno.h>
 #include <string.h>
 #include <stdio.h>
diff --git a/hwsim.c b/hwsim.c
index faa197b..6f82207 100644
--- a/hwsim.c
+++ b/hwsim.c
@@ -1,4 +1,3 @@
-#include <net/if.h>
 #include <errno.h>
 #include <string.h>

diff --git a/info.c b/info.c
index c23e378..8e87397 100644
--- a/info.c
+++ b/info.c
@@ -1,6 +1,5 @@
 #include <stdbool.h>
 #include <errno.h>
-#include <net/if.h>

 #include <netlink/genl/genl.h>
 #include <netlink/genl/family.h>
diff --git a/interface.c b/interface.c
index 4f0821d..87d86cc 100644
--- a/interface.c
+++ b/interface.c
@@ -1,4 +1,3 @@
-#include <net/if.h>
 #include <errno.h>
 #include <string.h>
 #include <stdbool.h>
diff --git a/mesh.c b/mesh.c
index 0090530..290b8c2 100644
--- a/mesh.c
+++ b/mesh.c
@@ -1,4 +1,3 @@
-#include <net/if.h>
 #include <errno.h>
 #include <string.h>

diff --git a/ocb.c b/ocb.c
index fc48ecf..d28da7f 100644
--- a/ocb.c
+++ b/ocb.c
@@ -1,4 +1,3 @@
-#include <net/if.h>
 #include <errno.h>
 #include <string.h>

diff --git a/p2p.c b/p2p.c
index bcfa01c..2067916 100644
--- a/p2p.c
+++ b/p2p.c
@@ -1,4 +1,3 @@
-#include <net/if.h>
 #include <errno.h>
 #include <string.h>

diff --git a/phy.c b/phy.c
index 39b68c4..6d4139e 100644
--- a/phy.c
+++ b/phy.c
@@ -1,6 +1,5 @@
 #include <stdbool.h>
 #include <errno.h>
-#include <net/if.h>
 #include <strings.h>
 #include <sys/param.h>
 #include <sys/stat.h>
diff --git a/reg.c b/reg.c
index ee607a5..1dca13a 100644
--- a/reg.c
+++ b/reg.c
@@ -1,4 +1,3 @@
-#include <net/if.h>
 #include <errno.h>
 #include <string.h>
 #include <stdbool.h>
diff --git a/roc.c b/roc.c
index ef2bf16..c6eda10 100644
--- a/roc.c
+++ b/roc.c
@@ -1,4 +1,3 @@
-#include <net/if.h>
 #include <errno.h>
 #include <string.h>

diff --git a/vendor.c b/vendor.c
index 5a69375..d0b4f9e 100644
--- a/vendor.c
+++ b/vendor.c
@@ -1,4 +1,3 @@
-#include <net/if.h>
 #include <errno.h>
 #include <string.h>

diff --git a/wowlan.c b/wowlan.c
index d3b565c..e1d3750 100644
--- a/wowlan.c
+++ b/wowlan.c
@@ -1,4 +1,3 @@
-#include <net/if.h>
 #include <errno.h>
 #include <string.h>
 #include <stdio.h>
-- 
1.7.9.5
