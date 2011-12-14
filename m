Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:32932 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754632Ab1LNPi0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Dec 2011 10:38:26 -0500
From: Samuel Ortiz <sameo@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	linux-wireless@vger.kernel.org,
	Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 1/8] NFC: Add function name to the NFC pr_fmt() routine
Date: Wed, 14 Dec 2011 16:43:05 +0100
Message-Id: <1323877392-20567-2-git-send-email-sameo@linux.intel.com> (sfid-20111214_163829_550026_63E96B95)
In-Reply-To: <1323877392-20567-1-git-send-email-sameo@linux.intel.com>
References: <1323877392-20567-1-git-send-email-sameo@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 net/nfc/core.c     |    2 +-
 net/nfc/nci/core.c |    2 +-
 net/nfc/nci/data.c |    2 +-
 net/nfc/nci/ntf.c  |    2 +-
 net/nfc/nci/rsp.c  |    2 +-
 net/nfc/netlink.c  |    2 +-
 net/nfc/rawsock.c  |    2 +-
 7 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/net/nfc/core.c b/net/nfc/core.c
index 3ebc6b3aa..2a838b0 100644
--- a/net/nfc/core.c
+++ b/net/nfc/core.c
@@ -21,7 +21,7 @@
  * 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
  */
 
-#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+#define pr_fmt(fmt) KBUILD_MODNAME ": %s: " fmt, __func__
 
 #include <linux/init.h>
 #include <linux/kernel.h>
diff --git a/net/nfc/nci/core.c b/net/nfc/nci/core.c
index 37de28e..921ad1f 100644
--- a/net/nfc/nci/core.c
+++ b/net/nfc/nci/core.c
@@ -25,7 +25,7 @@
  *
  */
 
-#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+#define pr_fmt(fmt) KBUILD_MODNAME ": %s: " fmt, __func__
 
 #include <linux/types.h>
 #include <linux/workqueue.h>
diff --git a/net/nfc/nci/data.c b/net/nfc/nci/data.c
index 1e040fe..e5756b3 100644
--- a/net/nfc/nci/data.c
+++ b/net/nfc/nci/data.c
@@ -21,7 +21,7 @@
  *
  */
 
-#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+#define pr_fmt(fmt) KBUILD_MODNAME ": %s: " fmt, __func__
 
 #include <linux/types.h>
 #include <linux/interrupt.h>
diff --git a/net/nfc/nci/ntf.c b/net/nfc/nci/ntf.c
index c36bd4a..003846b 100644
--- a/net/nfc/nci/ntf.c
+++ b/net/nfc/nci/ntf.c
@@ -25,7 +25,7 @@
  *
  */
 
-#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+#define pr_fmt(fmt) KBUILD_MODNAME ": %s: " fmt, __func__
 
 #include <linux/types.h>
 #include <linux/interrupt.h>
diff --git a/net/nfc/nci/rsp.c b/net/nfc/nci/rsp.c
index ca611c5..3f444c8 100644
--- a/net/nfc/nci/rsp.c
+++ b/net/nfc/nci/rsp.c
@@ -25,7 +25,7 @@
  *
  */
 
-#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+#define pr_fmt(fmt) KBUILD_MODNAME ": %s: " fmt, __func__
 
 #include <linux/types.h>
 #include <linux/interrupt.h>
diff --git a/net/nfc/netlink.c b/net/nfc/netlink.c
index c10e9b8..061711f 100644
--- a/net/nfc/netlink.c
+++ b/net/nfc/netlink.c
@@ -21,7 +21,7 @@
  * 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
  */
 
-#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+#define pr_fmt(fmt) KBUILD_MODNAME ": %s: " fmt, __func__
 
 #include <net/genetlink.h>
 #include <linux/nfc.h>
diff --git a/net/nfc/rawsock.c b/net/nfc/rawsock.c
index 68ecf3f..5e9b991 100644
--- a/net/nfc/rawsock.c
+++ b/net/nfc/rawsock.c
@@ -21,7 +21,7 @@
  * 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
  */
 
-#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+#define pr_fmt(fmt) KBUILD_MODNAME ": %s: " fmt, __func__
 
 #include <net/tcp_states.h>
 #include <linux/nfc.h>
-- 
1.7.7.3

