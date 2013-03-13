Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:8145 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933021Ab3CMMN3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Mar 2013 08:13:29 -0400
Cc: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	<linux-wireless@vger.kernel.org>,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
Subject: [PATCH 11/14] wil6210: headers clean-up
Date: Wed, 13 Mar 2013 14:12:48 +0200
Message-ID: <1363176771-10082-12-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20130313_131345_646496_AC365412)
In-Reply-To: <1363176771-10082-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1363176771-10082-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/cfg80211.c |    8 --------
 drivers/net/wireless/ath/wil6210/main.c     |    6 ------
 drivers/net/wireless/ath/wil6210/netdev.c   |    3 ---
 drivers/net/wireless/ath/wil6210/pcie_bus.c |    3 ---
 drivers/net/wireless/ath/wil6210/txrx.c     |    3 ---
 drivers/net/wireless/ath/wil6210/wmi.c      |    3 ---
 6 files changed, 26 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/cfg80211.c b/drivers/net/wireless/ath/wil6210/cfg80211.c
index 39404a8..feb33ac 100644
--- a/drivers/net/wireless/ath/wil6210/cfg80211.c
+++ b/drivers/net/wireless/ath/wil6210/cfg80211.c
@@ -14,15 +14,7 @@
  * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
-#include <linux/kernel.h>
-#include <linux/netdevice.h>
-#include <linux/sched.h>
-#include <linux/etherdevice.h>
-#include <linux/wireless.h>
-#include <linux/ieee80211.h>
-#include <linux/slab.h>
 #include <linux/version.h>
-#include <net/cfg80211.h>
 
 #include "wil6210.h"
 #include "wmi.h"
diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
index 11b6960..f11efa4 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -14,12 +14,6 @@
  * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
-#include <linux/kernel.h>
-#include <linux/netdevice.h>
-#include <linux/sched.h>
-#include <linux/ieee80211.h>
-#include <linux/wireless.h>
-#include <linux/slab.h>
 #include <linux/moduleparam.h>
 #include <linux/if_arp.h>
 
diff --git a/drivers/net/wireless/ath/wil6210/netdev.c b/drivers/net/wireless/ath/wil6210/netdev.c
index 8ce2e33..098a8ec 100644
--- a/drivers/net/wireless/ath/wil6210/netdev.c
+++ b/drivers/net/wireless/ath/wil6210/netdev.c
@@ -14,10 +14,7 @@
  * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
-#include <linux/module.h>
-#include <linux/netdevice.h>
 #include <linux/etherdevice.h>
-#include <linux/slab.h>
 
 #include "wil6210.h"
 
diff --git a/drivers/net/wireless/ath/wil6210/pcie_bus.c b/drivers/net/wireless/ath/wil6210/pcie_bus.c
index 81c35c6..eb1dc7a 100644
--- a/drivers/net/wireless/ath/wil6210/pcie_bus.c
+++ b/drivers/net/wireless/ath/wil6210/pcie_bus.c
@@ -14,10 +14,7 @@
  * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
-#include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/slab.h>
-#include <linux/netdevice.h>
 #include <linux/debugfs.h>
 #include <linux/pci.h>
 #include <linux/moduleparam.h>
diff --git a/drivers/net/wireless/ath/wil6210/txrx.c b/drivers/net/wireless/ath/wil6210/txrx.c
index d1315b4..4af9967 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.c
+++ b/drivers/net/wireless/ath/wil6210/txrx.c
@@ -14,10 +14,7 @@
  * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
-#include <linux/kernel.h>
-#include <linux/netdevice.h>
 #include <linux/etherdevice.h>
-#include <linux/hardirq.h>
 #include <net/ieee80211_radiotap.h>
 #include <linux/if_arp.h>
 #include <linux/moduleparam.h>
diff --git a/drivers/net/wireless/ath/wil6210/wmi.c b/drivers/net/wireless/ath/wil6210/wmi.c
index dc2ad85..8d9e145 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.c
+++ b/drivers/net/wireless/ath/wil6210/wmi.c
@@ -14,9 +14,6 @@
  * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
-#include <linux/pci.h>
-#include <linux/io.h>
-#include <linux/list.h>
 #include <linux/etherdevice.h>
 #include <linux/if_arp.h>
 
-- 
1.7.10.4

