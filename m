Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:46048 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751847AbbLUUvf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Dec 2015 15:51:35 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 23/45] iwlwifi: change the Intel Wireless email address
Date: Mon, 21 Dec 2015 22:50:24 +0200
Message-Id: <1450731046-2796-23-git-send-email-emmanuel.grumbach@intel.com> (sfid-20151221_215141_234487_A2C2C432)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E949792@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E949792@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ilw@linux.intel.com is not available anymore.
linuxwifi@intel.com should be used instead.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/dvm/agn.h              | 2 +-
 drivers/net/wireless/intel/iwlwifi/dvm/debugfs.c          | 2 +-
 drivers/net/wireless/intel/iwlwifi/dvm/dev.h              | 2 +-
 drivers/net/wireless/intel/iwlwifi/dvm/led.h              | 2 +-
 drivers/net/wireless/intel/iwlwifi/dvm/mac80211.c         | 2 +-
 drivers/net/wireless/intel/iwlwifi/dvm/main.c             | 2 +-
 drivers/net/wireless/intel/iwlwifi/dvm/rs.c               | 2 +-
 drivers/net/wireless/intel/iwlwifi/dvm/rs.h               | 2 +-
 drivers/net/wireless/intel/iwlwifi/dvm/rx.c               | 2 +-
 drivers/net/wireless/intel/iwlwifi/dvm/rxon.c             | 2 +-
 drivers/net/wireless/intel/iwlwifi/dvm/scan.c             | 2 +-
 drivers/net/wireless/intel/iwlwifi/dvm/sta.c              | 2 +-
 drivers/net/wireless/intel/iwlwifi/dvm/tt.c               | 2 +-
 drivers/net/wireless/intel/iwlwifi/dvm/tt.h               | 2 +-
 drivers/net/wireless/intel/iwlwifi/dvm/tx.c               | 2 +-
 drivers/net/wireless/intel/iwlwifi/iwl-7000.c             | 2 +-
 drivers/net/wireless/intel/iwlwifi/iwl-8000.c             | 2 +-
 drivers/net/wireless/intel/iwlwifi/iwl-config.h           | 2 +-
 drivers/net/wireless/intel/iwlwifi/iwl-csr.h              | 2 +-
 drivers/net/wireless/intel/iwlwifi/iwl-debug.c            | 2 +-
 drivers/net/wireless/intel/iwlwifi/iwl-debug.h            | 2 +-
 drivers/net/wireless/intel/iwlwifi/iwl-devtrace-iwlwifi.h | 2 +-
 drivers/net/wireless/intel/iwlwifi/iwl-devtrace.c         | 2 +-
 drivers/net/wireless/intel/iwlwifi/iwl-devtrace.h         | 2 +-
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c              | 2 +-
 drivers/net/wireless/intel/iwlwifi/iwl-drv.h              | 4 ++--
 drivers/net/wireless/intel/iwlwifi/iwl-fw-file.h          | 2 +-
 drivers/net/wireless/intel/iwlwifi/iwl-io.c               | 2 +-
 drivers/net/wireless/intel/iwlwifi/iwl-modparams.h        | 2 +-
 drivers/net/wireless/intel/iwlwifi/iwl-op-mode.h          | 2 +-
 drivers/net/wireless/intel/iwlwifi/iwl-phy-db.c           | 2 +-
 drivers/net/wireless/intel/iwlwifi/iwl-phy-db.h           | 2 +-
 drivers/net/wireless/intel/iwlwifi/iwl-prph.h             | 2 +-
 drivers/net/wireless/intel/iwlwifi/iwl-trans.h            | 2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/coex.c             | 2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/coex_legacy.c      | 2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/constants.h        | 2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c               | 2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs-vif.c      | 2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c          | 2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api-coex.h      | 2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api-rx.h        | 2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api-scan.h      | 2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h           | 2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c               | 2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c         | 2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c         | 2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h              | 2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/nvm.c              | 2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c              | 2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/phy-ctxt.c         | 2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/power.c            | 2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/quota.c            | 2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rs.c               | 2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rs.h               | 2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rx.c               | 2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c             | 2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c              | 2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.h              | 2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/tdls.c             | 2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/tof.c              | 2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/tof.h              | 2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c               | 2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/utils.c            | 2 +-
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c             | 2 +-
 drivers/net/wireless/intel/iwlwifi/pcie/internal.h        | 2 +-
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c           | 2 +-
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c              | 2 +-
 68 files changed, 69 insertions(+), 69 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/agn.h b/drivers/net/wireless/intel/iwlwifi/dvm/agn.h
index 82c177a..9de277c 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/agn.h
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/agn.h
@@ -25,7 +25,7 @@
  * in the file called COPYING.
  *
  * Contact Information:
- *  Intel Linux Wireless <ilw@linux.intel.com>
+ *  Intel Linux Wireless <linuxwifi@intel.com>
  * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
  *
  * BSD LICENSE
diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/debugfs.c b/drivers/net/wireless/intel/iwlwifi/dvm/debugfs.c
index a114d3e..74c5161 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/debugfs.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/debugfs.c
@@ -22,7 +22,7 @@
  * in the file called COPYING.
  *
  * Contact Information:
- *  Intel Linux Wireless <ilw@linux.intel.com>
+ *  Intel Linux Wireless <linuxwifi@intel.com>
  * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
  *****************************************************************************/
 
diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/dev.h b/drivers/net/wireless/intel/iwlwifi/dvm/dev.h
index 0ba3e56..1a7ead7 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/dev.h
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/dev.h
@@ -19,7 +19,7 @@
  * file called LICENSE.
  *
  * Contact Information:
- *  Intel Linux Wireless <ilw@linux.intel.com>
+ *  Intel Linux Wireless <linuxwifi@intel.com>
  * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
  *
  *****************************************************************************/
diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/led.h b/drivers/net/wireless/intel/iwlwifi/dvm/led.h
index 1c6b225..75f74ed 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/led.h
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/led.h
@@ -19,7 +19,7 @@
  * file called LICENSE.
  *
  * Contact Information:
- *  Intel Linux Wireless <ilw@linux.intel.com>
+ *  Intel Linux Wireless <linuxwifi@intel.com>
  * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
  *
  *****************************************************************************/
diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/dvm/mac80211.c
index f4c2529..29ea1c6 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/mac80211.c
@@ -22,7 +22,7 @@
  * file called LICENSE.
  *
  * Contact Information:
- *  Intel Linux Wireless <ilw@linux.intel.com>
+ *  Intel Linux Wireless <linuxwifi@intel.com>
  * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
  *
  *****************************************************************************/
diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/main.c b/drivers/net/wireless/intel/iwlwifi/dvm/main.c
index 9f6f564..94bc66a 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/main.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/main.c
@@ -23,7 +23,7 @@
  * file called LICENSE.
  *
  * Contact Information:
- *  Intel Linux Wireless <ilw@linux.intel.com>
+ *  Intel Linux Wireless <linuxwifi@intel.com>
  * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
  *
  *****************************************************************************/
diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/rs.c b/drivers/net/wireless/intel/iwlwifi/dvm/rs.c
index cef921c..ee75055 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/rs.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/rs.c
@@ -19,7 +19,7 @@
  * file called LICENSE.
  *
  * Contact Information:
- *  Intel Linux Wireless <ilw@linux.intel.com>
+ *  Intel Linux Wireless <linuxwifi@intel.com>
  * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
  *
  *****************************************************************************/
diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/rs.h b/drivers/net/wireless/intel/iwlwifi/dvm/rs.h
index f6bd25c..c5fe445 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/rs.h
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/rs.h
@@ -19,7 +19,7 @@
  * file called LICENSE.
  *
  * Contact Information:
- *  Intel Linux Wireless <ilw@linux.intel.com>
+ *  Intel Linux Wireless <linuxwifi@intel.com>
  * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
  *
  *****************************************************************************/
diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/rx.c b/drivers/net/wireless/intel/iwlwifi/dvm/rx.c
index 94b41e4..52ab1e0 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/rx.c
@@ -23,7 +23,7 @@
  * file called LICENSE.
  *
  * Contact Information:
- *  Intel Linux Wireless <ilw@linux.intel.com>
+ *  Intel Linux Wireless <linuxwifi@intel.com>
  * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
  *
  *****************************************************************************/
diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/rxon.c b/drivers/net/wireless/intel/iwlwifi/dvm/rxon.c
index 85ceceb..2d47cb2 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/rxon.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/rxon.c
@@ -20,7 +20,7 @@
  * file called LICENSE.
  *
  * Contact Information:
- * Intel Linux Wireless <ilw@linux.intel.com>
+ * Intel Linux Wireless <linuxwifi@intel.com>
  * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
  *
  *****************************************************************************/
diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/scan.c b/drivers/net/wireless/intel/iwlwifi/dvm/scan.c
index 6481594..81a2ddb 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/scan.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/scan.c
@@ -22,7 +22,7 @@
  * in the file called COPYING.
  *
  * Contact Information:
- *  Intel Linux Wireless <ilw@linux.intel.com>
+ *  Intel Linux Wireless <linuxwifi@intel.com>
  * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
  *****************************************************************************/
 #include <linux/slab.h>
diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/sta.c b/drivers/net/wireless/intel/iwlwifi/dvm/sta.c
index 0fa67d3..8e9768a 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/sta.c
@@ -22,7 +22,7 @@
  * file called LICENSE.
  *
  * Contact Information:
- *  Intel Linux Wireless <ilw@linux.intel.com>
+ *  Intel Linux Wireless <linuxwifi@intel.com>
  * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
  *
  *****************************************************************************/
diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/tt.c b/drivers/net/wireless/intel/iwlwifi/dvm/tt.c
index c4736c8..7decfc5 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/tt.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/tt.c
@@ -22,7 +22,7 @@
  * file called LICENSE.
  *
  * Contact Information:
- *  Intel Linux Wireless <ilw@linux.intel.com>
+ *  Intel Linux Wireless <linuxwifi@intel.com>
  * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
  *****************************************************************************/
 
diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/tt.h b/drivers/net/wireless/intel/iwlwifi/dvm/tt.h
index 5077265..d324e9b 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/tt.h
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/tt.h
@@ -22,7 +22,7 @@
  * file called LICENSE.
  *
  * Contact Information:
- *  Intel Linux Wireless <ilw@linux.intel.com>
+ *  Intel Linux Wireless <linuxwifi@intel.com>
  * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
  *****************************************************************************/
 #ifndef __iwl_tt_setting_h__
diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/tx.c b/drivers/net/wireless/intel/iwlwifi/dvm/tx.c
index bddd197..cf0ad5f 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/tx.c
@@ -22,7 +22,7 @@
  * in the file called COPYING.
  *
  * Contact Information:
- *  Intel Linux Wireless <ilw@linux.intel.com>
+ *  Intel Linux Wireless <linuxwifi@intel.com>
  * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
  *
  *****************************************************************************/
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-7000.c b/drivers/net/wireless/intel/iwlwifi/iwl-7000.c
index 390ee4d..fd9064b 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-7000.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-7000.c
@@ -27,7 +27,7 @@
  * in the file called COPYING.
  *
  * Contact Information:
- *  Intel Linux Wireless <ilw@linux.intel.com>
+ *  Intel Linux Wireless <linuxwifi@intel.com>
  * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
  *
  * BSD LICENSE
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-8000.c b/drivers/net/wireless/intel/iwlwifi/iwl-8000.c
index 89a25cf..dee4458 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-8000.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-8000.c
@@ -26,7 +26,7 @@
  * in the file called COPYING.
  *
  * Contact Information:
- *  Intel Linux Wireless <ilw@linux.intel.com>
+ *  Intel Linux Wireless <linuxwifi@intel.com>
  * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
  *
  * BSD LICENSE
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-config.h b/drivers/net/wireless/intel/iwlwifi/iwl-config.h
index 6a4c0c2..f990481 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-config.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-config.h
@@ -25,7 +25,7 @@
  * in the file called COPYING.
  *
  * Contact Information:
- *  Intel Linux Wireless <ilw@linux.intel.com>
+ *  Intel Linux Wireless <linuxwifi@intel.com>
  * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
  *
  * BSD LICENSE
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-csr.h b/drivers/net/wireless/intel/iwlwifi/iwl-csr.h
index 543abea..163b21b 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-csr.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-csr.h
@@ -26,7 +26,7 @@
  * in the file called COPYING.
  *
  * Contact Information:
- *  Intel Linux Wireless <ilw@linux.intel.com>
+ *  Intel Linux Wireless <linuxwifi@intel.com>
  * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
  *
  * BSD LICENSE
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-debug.c b/drivers/net/wireless/intel/iwlwifi/iwl-debug.c
index 09feff4..b1c3b0d 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-debug.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-debug.c
@@ -25,7 +25,7 @@
  * in the file called COPYING.
  *
  * Contact Information:
- *  Intel Linux Wireless <ilw@linux.intel.com>
+ *  Intel Linux Wireless <linuxwifi@intel.com>
  * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
  *
  * BSD LICENSE
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-debug.h b/drivers/net/wireless/intel/iwlwifi/iwl-debug.h
index e8dbb24..1103332 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-debug.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-debug.h
@@ -21,7 +21,7 @@
  * file called LICENSE.
  *
  * Contact Information:
- *  Intel Linux Wireless <ilw@linux.intel.com>
+ *  Intel Linux Wireless <linuxwifi@intel.com>
  * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
  *
  *****************************************************************************/
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-devtrace-iwlwifi.h b/drivers/net/wireless/intel/iwlwifi/iwl-devtrace-iwlwifi.h
index eb4b99a..22786d7 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-devtrace-iwlwifi.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-devtrace-iwlwifi.h
@@ -20,7 +20,7 @@
  * file called LICENSE.
  *
  * Contact Information:
- *  Intel Linux Wireless <ilw@linux.intel.com>
+ *  Intel Linux Wireless <linuxwifi@intel.com>
  * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
  *
  *****************************************************************************/
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-devtrace.c b/drivers/net/wireless/intel/iwlwifi/iwl-devtrace.c
index 90987d6..1d9dd153 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-devtrace.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-devtrace.c
@@ -19,7 +19,7 @@
  * file called LICENSE.
  *
  * Contact Information:
- *  Intel Linux Wireless <ilw@linux.intel.com>
+ *  Intel Linux Wireless <linuxwifi@intel.com>
  * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
  *
  *****************************************************************************/
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-devtrace.h b/drivers/net/wireless/intel/iwlwifi/iwl-devtrace.h
index b87acd6..f4d3cd0 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-devtrace.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-devtrace.h
@@ -19,7 +19,7 @@
  * file called LICENSE.
  *
  * Contact Information:
- *  Intel Linux Wireless <ilw@linux.intel.com>
+ *  Intel Linux Wireless <linuxwifi@intel.com>
  * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
  *
  *****************************************************************************/
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
index 47a83ab..7acb490 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
@@ -26,7 +26,7 @@
  * in the file called COPYING.
  *
  * Contact Information:
- *  Intel Linux Wireless <ilw@linux.intel.com>
+ *  Intel Linux Wireless <linuxwifi@intel.com>
  * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
  *
  * BSD LICENSE
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-drv.h b/drivers/net/wireless/intel/iwlwifi/iwl-drv.h
index cda746b..f6eacfd 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-drv.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-drv.h
@@ -26,7 +26,7 @@
  * in the file called COPYING.
  *
  * Contact Information:
- *  Intel Linux Wireless <ilw@linux.intel.com>
+ *  Intel Linux Wireless <linuxwifi@intel.com>
  * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
  *
  * BSD LICENSE
@@ -69,7 +69,7 @@
 /* for all modules */
 #define DRV_NAME        "iwlwifi"
 #define DRV_COPYRIGHT	"Copyright(c) 2003- 2015 Intel Corporation"
-#define DRV_AUTHOR     "<ilw@linux.intel.com>"
+#define DRV_AUTHOR     "<linuxwifi@intel.com>"
 
 /* radio config bits (actual values from NVM definition) */
 #define NVM_RF_CFG_DASH_MSK(x)   (x & 0x3)         /* bits 0-1   */
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-fw-file.h b/drivers/net/wireless/intel/iwlwifi/iwl-fw-file.h
index e08319a..d2294ad6 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-fw-file.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-fw-file.h
@@ -26,7 +26,7 @@
  * in the file called COPYING.
  *
  * Contact Information:
- *  Intel Linux Wireless <ilw@linux.intel.com>
+ *  Intel Linux Wireless <linuxwifi@intel.com>
  * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
  *
  * BSD LICENSE
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-io.c b/drivers/net/wireless/intel/iwlwifi/iwl-io.c
index 603c894..07ad5c8 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-io.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-io.c
@@ -22,7 +22,7 @@
  * file called LICENSE.
  *
  * Contact Information:
- *  Intel Linux Wireless <ilw@linux.intel.com>
+ *  Intel Linux Wireless <linuxwifi@intel.com>
  * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
  *
  *****************************************************************************/
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-modparams.h b/drivers/net/wireless/intel/iwlwifi/iwl-modparams.h
index 9baf9ef..fd42f63 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-modparams.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-modparams.h
@@ -25,7 +25,7 @@
  * in the file called COPYING.
  *
  * Contact Information:
- *  Intel Linux Wireless <ilw@linux.intel.com>
+ *  Intel Linux Wireless <linuxwifi@intel.com>
  * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
  *
  * BSD LICENSE
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-op-mode.h b/drivers/net/wireless/intel/iwlwifi/iwl-op-mode.h
index ffff31c..b49eda8 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-op-mode.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-op-mode.h
@@ -27,7 +27,7 @@
  * in the file called COPYING.
  *
  * Contact Information:
- *  Intel Linux Wireless <ilw@linux.intel.com>
+ *  Intel Linux Wireless <linuxwifi@intel.com>
  * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
  *
  * BSD LICENSE
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-phy-db.c b/drivers/net/wireless/intel/iwlwifi/iwl-phy-db.c
index a105455..4a4dea0 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-phy-db.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-phy-db.c
@@ -25,7 +25,7 @@
  * in the file called COPYING.
  *
  * Contact Information:
- *  Intel Linux Wireless <ilw@linux.intel.com>
+ *  Intel Linux Wireless <linuxwifi@intel.com>
  * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
  *
  * BSD LICENSE
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-phy-db.h b/drivers/net/wireless/intel/iwlwifi/iwl-phy-db.h
index 9ee18d0..2410387 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-phy-db.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-phy-db.h
@@ -25,7 +25,7 @@
  * in the file called COPYING.
  *
  * Contact Information:
- *  Intel Linux Wireless <ilw@linux.intel.com>
+ *  Intel Linux Wireless <linuxwifi@intel.com>
  * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
  *
  * BSD LICENSE
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-prph.h b/drivers/net/wireless/intel/iwlwifi/iwl-prph.h
index 3ab777f..9da7dc4 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-prph.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-prph.h
@@ -26,7 +26,7 @@
  * in the file called COPYING.
  *
  * Contact Information:
- *  Intel Linux Wireless <ilw@linux.intel.com>
+ *  Intel Linux Wireless <linuxwifi@intel.com>
  * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
  *
  * BSD LICENSE
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-trans.h b/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
index 8caf68b..777fd6c 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
@@ -26,7 +26,7 @@
  * in the file called COPYING.
  *
  * Contact Information:
- *  Intel Linux Wireless <ilw@linux.intel.com>
+ *  Intel Linux Wireless <linuxwifi@intel.com>
  * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
  *
  * BSD LICENSE
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/coex.c b/drivers/net/wireless/intel/iwlwifi/mvm/coex.c
index c9ca029..2e098f8 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/coex.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/coex.c
@@ -26,7 +26,7 @@
  * in the file called COPYING.
  *
  * Contact Information:
- *  Intel Linux Wireless <ilw@linux.intel.com>
+ *  Intel Linux Wireless <linuxwifi@intel.com>
  * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
  *
  * BSD LICENSE
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/coex_legacy.c b/drivers/net/wireless/intel/iwlwifi/mvm/coex_legacy.c
index 61c07b0..0150457 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/coex_legacy.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/coex_legacy.c
@@ -26,7 +26,7 @@
  * in the file called COPYING.
  *
  * Contact Information:
- *  Intel Linux Wireless <ilw@linux.intel.com>
+ *  Intel Linux Wireless <linuxwifi@intel.com>
  * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
  *
  * BSD LICENSE
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/constants.h b/drivers/net/wireless/intel/iwlwifi/mvm/constants.h
index 5c21231..1f8f616 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/constants.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/constants.h
@@ -26,7 +26,7 @@
  * in the file called COPYING.
  *
  * Contact Information:
- *  Intel Linux Wireless <ilw@linux.intel.com>
+ *  Intel Linux Wireless <linuxwifi@intel.com>
  * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
  *
  * BSD LICENSE
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
index 8824a89..8cd2e67 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
@@ -26,7 +26,7 @@
  * in the file called COPYING.
  *
  * Contact Information:
- *  Intel Linux Wireless <ilw@linux.intel.com>
+ *  Intel Linux Wireless <linuxwifi@intel.com>
  * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
  *
  * BSD LICENSE
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs-vif.c b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs-vif.c
index 7904b41..9e0d463 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs-vif.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs-vif.c
@@ -26,7 +26,7 @@
  * in the file called COPYING.
  *
  * Contact Information:
- *  Intel Linux Wireless <ilw@linux.intel.com>
+ *  Intel Linux Wireless <linuxwifi@intel.com>
  * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
  *
  * BSD LICENSE
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
index 9ce7587..2acf9ff 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
@@ -26,7 +26,7 @@
  * in the file called COPYING.
  *
  * Contact Information:
- *  Intel Linux Wireless <ilw@linux.intel.com>
+ *  Intel Linux Wireless <linuxwifi@intel.com>
  * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
  *
  * BSD LICENSE
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-coex.h b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-coex.h
index d398a61..2a33b69 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-coex.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-coex.h
@@ -26,7 +26,7 @@
  * in the file called COPYING.
  *
  * Contact Information:
- *  Intel Linux Wireless <ilw@linux.intel.com>
+ *  Intel Linux Wireless <linuxwifi@intel.com>
  * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
  *
  * BSD LICENSE
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-rx.h b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-rx.h
index 9a8a37f..af7f9dd 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-rx.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-rx.h
@@ -27,7 +27,7 @@
  * in the file called COPYING.
  *
  * Contact Information:
- *  Intel Linux Wireless <ilw@linux.intel.com>
+ *  Intel Linux Wireless <linuxwifi@intel.com>
  * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
  *
  * BSD LICENSE
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-scan.h b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-scan.h
index 3a657e4..d92712d 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-scan.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-scan.h
@@ -26,7 +26,7 @@
  * in the file called COPYING.
  *
  * Contact Information:
- *  Intel Linux Wireless <ilw@linux.intel.com>
+ *  Intel Linux Wireless <linuxwifi@intel.com>
  * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
  *
  * BSD LICENSE
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h
index 3f7478b..995898c 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h
@@ -26,7 +26,7 @@
  * in the file called COPYING.
  *
  * Contact Information:
- *  Intel Linux Wireless <ilw@linux.intel.com>
+ *  Intel Linux Wireless <linuxwifi@intel.com>
  * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
  *
  * BSD LICENSE
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
index 05c9333..e6e8088 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
@@ -26,7 +26,7 @@
  * in the file called COPYING.
  *
  * Contact Information:
- *  Intel Linux Wireless <ilw@linux.intel.com>
+ *  Intel Linux Wireless <linuxwifi@intel.com>
  * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
  *
  * BSD LICENSE
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
index ee511aa..d00a6e9 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
@@ -27,7 +27,7 @@
  * in the file called COPYING.
  *
  * Contact Information:
- *  Intel Linux Wireless <ilw@linux.intel.com>
+ *  Intel Linux Wireless <linuxwifi@intel.com>
  * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
  *
  * BSD LICENSE
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index 3a78a3f..0fb10fd 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -26,7 +26,7 @@
  * in the file called COPYING.
  *
  * Contact Information:
- *  Intel Linux Wireless <ilw@linux.intel.com>
+ *  Intel Linux Wireless <linuxwifi@intel.com>
  * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
  *
  * BSD LICENSE
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index d8760fa..ce9f579 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -26,7 +26,7 @@
  * in the file called COPYING.
  *
  * Contact Information:
- *  Intel Linux Wireless <ilw@linux.intel.com>
+ *  Intel Linux Wireless <linuxwifi@intel.com>
  * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
  *
  * BSD LICENSE
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/nvm.c b/drivers/net/wireless/intel/iwlwifi/mvm/nvm.c
index a9fcb15..d8dcb67 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/nvm.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/nvm.c
@@ -26,7 +26,7 @@
  * in the file called COPYING.
  *
  * Contact Information:
- *  Intel Linux Wireless <ilw@linux.intel.com>
+ *  Intel Linux Wireless <linuxwifi@intel.com>
  * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
  *
  * BSD LICENSE
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
index 4753ecd..ffcebea 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -26,7 +26,7 @@
  * in the file called COPYING.
  *
  * Contact Information:
- *  Intel Linux Wireless <ilw@linux.intel.com>
+ *  Intel Linux Wireless <linuxwifi@intel.com>
  * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
  *
  * BSD LICENSE
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/phy-ctxt.c b/drivers/net/wireless/intel/iwlwifi/mvm/phy-ctxt.c
index e68a475..6e6a56f 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/phy-ctxt.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/phy-ctxt.c
@@ -26,7 +26,7 @@
  * in the file called COPYING.
  *
  * Contact Information:
- *  Intel Linux Wireless <ilw@linux.intel.com>
+ *  Intel Linux Wireless <linuxwifi@intel.com>
  * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
  *
  * BSD LICENSE
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/power.c b/drivers/net/wireless/intel/iwlwifi/mvm/power.c
index bed9696..87a9f24 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/power.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/power.c
@@ -27,7 +27,7 @@
  * in the file called COPYING.
  *
  * Contact Information:
- *  Intel Linux Wireless <ilw@linux.intel.com>
+ *  Intel Linux Wireless <linuxwifi@intel.com>
  * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
  *
  * BSD LICENSE
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/quota.c b/drivers/net/wireless/intel/iwlwifi/mvm/quota.c
index 509a66d..0b762b4 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/quota.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/quota.c
@@ -26,7 +26,7 @@
  * in the file called COPYING.
  *
  * Contact Information:
- *  Intel Linux Wireless <ilw@linux.intel.com>
+ *  Intel Linux Wireless <linuxwifi@intel.com>
  * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
  *
  * BSD LICENSE
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rs.c b/drivers/net/wireless/intel/iwlwifi/mvm/rs.c
index 31b082e..7bb6fd0 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rs.c
@@ -20,7 +20,7 @@
  * file called LICENSE.
  *
  * Contact Information:
- *  Intel Linux Wireless <ilw@linux.intel.com>
+ *  Intel Linux Wireless <linuxwifi@intel.com>
  * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
  *
  *****************************************************************************/
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rs.h b/drivers/net/wireless/intel/iwlwifi/mvm/rs.h
index 81314ad..bdb6f2d 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rs.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rs.h
@@ -20,7 +20,7 @@
  * file called LICENSE.
  *
  * Contact Information:
- *  Intel Linux Wireless <ilw@linux.intel.com>
+ *  Intel Linux Wireless <linuxwifi@intel.com>
  * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
  *
  *****************************************************************************/
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rx.c b/drivers/net/wireless/intel/iwlwifi/mvm/rx.c
index a0e957a..145ec68 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rx.c
@@ -26,7 +26,7 @@
  * in the file called COPYING.
  *
  * Contact Information:
- *  Intel Linux Wireless <ilw@linux.intel.com>
+ *  Intel Linux Wireless <linuxwifi@intel.com>
  * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
  *
  * BSD LICENSE
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
index 4887418..87cc993 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
@@ -26,7 +26,7 @@
  * in the file called COPYING.
  *
  * Contact Information:
- *  Intel Linux Wireless <ilw@linux.intel.com>
+ *  Intel Linux Wireless <linuxwifi@intel.com>
  * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
  *
  * BSD LICENSE
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
index df1fed7..4148ebe 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
@@ -26,7 +26,7 @@
  * in the file called COPYING.
  *
  * Contact Information:
- *  Intel Linux Wireless <ilw@linux.intel.com>
+ *  Intel Linux Wireless <linuxwifi@intel.com>
  * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
  *
  * BSD LICENSE
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.h b/drivers/net/wireless/intel/iwlwifi/mvm/sta.h
index ce1b16a..973f2ed 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.h
@@ -26,7 +26,7 @@
  * in the file called COPYING.
  *
  * Contact Information:
- *  Intel Linux Wireless <ilw@linux.intel.com>
+ *  Intel Linux Wireless <linuxwifi@intel.com>
  * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
  *
  * BSD LICENSE
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tdls.c b/drivers/net/wireless/intel/iwlwifi/mvm/tdls.c
index fe2fa56..18711c5 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tdls.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tdls.c
@@ -25,7 +25,7 @@
  * in the file called COPYING.
  *
  * Contact Information:
- *  Intel Linux Wireless <ilw@linux.intel.com>
+ *  Intel Linux Wireless <linuxwifi@intel.com>
  * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
  *
  * BSD LICENSE
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tof.c b/drivers/net/wireless/intel/iwlwifi/mvm/tof.c
index 4007f1d..a1947d6 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tof.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tof.c
@@ -25,7 +25,7 @@
  * in the file called COPYING.
  *
  * Contact Information:
- * Intel Linux Wireless <ilw@linux.intel.com>
+ * Intel Linux Wireless <linuxwifi@intel.com>
  * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
  *
  * BSD LICENSE
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tof.h b/drivers/net/wireless/intel/iwlwifi/mvm/tof.h
index 9beebc3..8c3421c 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tof.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tof.h
@@ -25,7 +25,7 @@
  * in the file called COPYING.
  *
  * Contact Information:
- * Intel Linux Wireless <ilw@linux.intel.com>
+ * Intel Linux Wireless <linuxwifi@intel.com>
  * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
  *
  * BSD LICENSE
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
index cc0cdce..4d13df1 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
@@ -26,7 +26,7 @@
  * in the file called COPYING.
  *
  * Contact Information:
- *  Intel Linux Wireless <ilw@linux.intel.com>
+ *  Intel Linux Wireless <linuxwifi@intel.com>
  * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
  *
  * BSD LICENSE
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/utils.c b/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
index bbb7f6b..3a989f5 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
@@ -27,7 +27,7 @@
  * in the file called COPYING.
  *
  * Contact Information:
- *  Intel Linux Wireless <ilw@linux.intel.com>
+ *  Intel Linux Wireless <linuxwifi@intel.com>
  * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
  *
  * BSD LICENSE
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
index 9bdce44..4f94be9 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
@@ -26,7 +26,7 @@
  * in the file called COPYING.
  *
  * Contact Information:
- *  Intel Linux Wireless <ilw@linux.intel.com>
+ *  Intel Linux Wireless <linuxwifi@intel.com>
  * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
  *
  * BSD LICENSE
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
index 0aceb9f..92a35d9 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
@@ -23,7 +23,7 @@
  * file called LICENSE.
  *
  * Contact Information:
- *  Intel Linux Wireless <ilw@linux.intel.com>
+ *  Intel Linux Wireless <linuxwifi@intel.com>
  * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
  *
  *****************************************************************************/
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index 05d5a5b..a5bf24e 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -26,7 +26,7 @@
  * in the file called COPYING.
  *
  * Contact Information:
- *  Intel Linux Wireless <ilw@linux.intel.com>
+ *  Intel Linux Wireless <linuxwifi@intel.com>
  * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
  *
  * BSD LICENSE
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c b/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
index f2277c7..2952915 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
@@ -23,7 +23,7 @@
  * file called LICENSE.
  *
  * Contact Information:
- *  Intel Linux Wireless <ilw@linux.intel.com>
+ *  Intel Linux Wireless <linuxwifi@intel.com>
  * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
  *
  *****************************************************************************/
-- 
2.5.0

