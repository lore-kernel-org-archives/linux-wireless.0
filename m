Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:38336 "EHLO ds10.mine.nu"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756974AbYGTNyH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Jul 2008 09:54:07 -0400
Message-ID: <48833E9F.8090200@openwrt.org> (sfid-20080720_155410_757898_9DF4C96E)
Date: Sun, 20 Jul 2008 15:33:19 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
CC: ath5k-devel@lists.ath5k.org
Subject: [PATCH 2/5] ath9k: add missing include statements
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
--- a/drivers/net/wireless/ath9k/regd.c
+++ b/drivers/net/wireless/ath9k/regd.c
@@ -14,6 +14,8 @@
   * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
   */

+#include <linux/kernel.h>
+#include <linux/slab.h>
  #include "ath9k.h"
  #include "regd.h"
  #include "regd_common.h"
