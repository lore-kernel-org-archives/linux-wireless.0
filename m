Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:46056 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759426Ab2C3LNB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Mar 2012 07:13:01 -0400
Message-ID: <1333105980.3908.14.camel@jlt3.sipsolutions.net> (sfid-20120330_131303_508862_EF78CDC0)
Subject: [PATCH] compat: crc8: undef pr_fmt
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Fri, 30 Mar 2012 13:13:00 +0200
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 compat/crc8.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/compat/crc8.c b/compat/crc8.c
index fa8382d..753a5cb 100644
--- a/compat/crc8.c
+++ b/compat/crc8.c
@@ -14,6 +14,9 @@
  * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
+#ifdef pr_fmt
+#undef pr_fmt
+#endif
 #define pr_fmt(fmt)		KBUILD_MODNAME ": " fmt
 
 #include <linux/module.h>
-- 
1.7.9.1



