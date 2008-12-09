Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:29654 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754462AbYLIT2A (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Dec 2008 14:28:00 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	"Winkler, Tomas" <tomas.winkler@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 1/4] iwlwifi: change email contact information
Date: Tue,  9 Dec 2008 11:28:58 -0800
Message-Id: <1228850941-16677-2-git-send-email-reinette.chatre@intel.com> (sfid-20081209_202807_978184_A1D8F8D1)
In-Reply-To: <1228850941-16677-1-git-send-email-reinette.chatre@intel.com>
References: <>
 <1228850941-16677-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Winkler, Tomas <tomas.winkler@intel.com>

This patch replaces personal emails with hopefully
always valid Intel Linux Wireless, which will be routed
to a current maintainer

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945-commands.h  |    2 +-
 drivers/net/wireless/iwlwifi/iwl-3945-core.h      |    2 +-
 drivers/net/wireless/iwlwifi/iwl-3945-debug.h     |    2 +-
 drivers/net/wireless/iwlwifi/iwl-3945-hw.h        |    2 +-
 drivers/net/wireless/iwlwifi/iwl-3945-io.h        |    2 +-
 drivers/net/wireless/iwlwifi/iwl-3945-led.c       |    2 +-
 drivers/net/wireless/iwlwifi/iwl-3945-led.h       |    2 +-
 drivers/net/wireless/iwlwifi/iwl-3945-rs.c        |    2 +-
 drivers/net/wireless/iwlwifi/iwl-3945-rs.h        |    2 +-
 drivers/net/wireless/iwlwifi/iwl-3945.c           |    2 +-
 drivers/net/wireless/iwlwifi/iwl-3945.h           |    2 +-
 drivers/net/wireless/iwlwifi/iwl-4965-hw.h        |    2 +-
 drivers/net/wireless/iwlwifi/iwl-4965.c           |    2 +-
 drivers/net/wireless/iwlwifi/iwl-5000-hw.h        |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn-hcmd-check.c |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c         |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn-rs.h         |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn.c            |    2 +-
 drivers/net/wireless/iwlwifi/iwl-calib.c          |    2 +-
 drivers/net/wireless/iwlwifi/iwl-calib.h          |    2 +-
 drivers/net/wireless/iwlwifi/iwl-commands.h       |    2 +-
 drivers/net/wireless/iwlwifi/iwl-core.c           |    2 +-
 drivers/net/wireless/iwlwifi/iwl-core.h           |    2 +-
 drivers/net/wireless/iwlwifi/iwl-csr.h            |    2 +-
 drivers/net/wireless/iwlwifi/iwl-debug.h          |    2 +-
 drivers/net/wireless/iwlwifi/iwl-debugfs.c        |    2 +-
 drivers/net/wireless/iwlwifi/iwl-dev.h            |    2 +-
 drivers/net/wireless/iwlwifi/iwl-eeprom.c         |    2 +-
 drivers/net/wireless/iwlwifi/iwl-eeprom.h         |    2 +-
 drivers/net/wireless/iwlwifi/iwl-fh.h             |    2 +-
 drivers/net/wireless/iwlwifi/iwl-hcmd.c           |    2 +-
 drivers/net/wireless/iwlwifi/iwl-helpers.h        |    2 +-
 drivers/net/wireless/iwlwifi/iwl-io.h             |    2 +-
 drivers/net/wireless/iwlwifi/iwl-led.c            |    2 +-
 drivers/net/wireless/iwlwifi/iwl-led.h            |    2 +-
 drivers/net/wireless/iwlwifi/iwl-power.c          |    2 +-
 drivers/net/wireless/iwlwifi/iwl-power.h          |    2 +-
 drivers/net/wireless/iwlwifi/iwl-prph.h           |    2 +-
 drivers/net/wireless/iwlwifi/iwl-rfkill.c         |    2 +-
 drivers/net/wireless/iwlwifi/iwl-rfkill.h         |    2 +-
 drivers/net/wireless/iwlwifi/iwl-rx.c             |    2 +-
 drivers/net/wireless/iwlwifi/iwl-scan.c           |    2 +-
 drivers/net/wireless/iwlwifi/iwl-spectrum.c       |    2 +-
 drivers/net/wireless/iwlwifi/iwl-spectrum.h       |    2 +-
 drivers/net/wireless/iwlwifi/iwl-sta.c            |    2 +-
 drivers/net/wireless/iwlwifi/iwl-sta.h            |    2 +-
 drivers/net/wireless/iwlwifi/iwl-tx.c             |    2 +-
 drivers/net/wireless/iwlwifi/iwl3945-base.c       |    2 +-
 48 files changed, 48 insertions(+), 48 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-commands.h b/drivers/net/wireless/iwlwifi/iwl-3945-commands.h
index daf99ea..c6f4eb5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945-commands.h
@@ -25,7 +25,7 @@
  * in the file called LICENSE.GPL.
  *
  * Contact Information:
- * James P. Ketrenos <ipw2100-admin@linux.intel.com>
+ *  Intel Linux Wireless <ilw@linux.intel.com>
  * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
  *
  * BSD LICENSE
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-core.h b/drivers/net/wireless/iwlwifi/iwl-3945-core.h
index edac6c6..6f46355 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945-core.h
@@ -25,7 +25,7 @@
  * in the file called LICENSE.GPL.
  *
  * Contact Information:
- * Tomas Winkler <tomas.winkler@intel.com>
+ *  Intel Linux Wireless <ilw@linux.intel.com>
  * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
  *
  * BSD LICENSE
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-debug.h b/drivers/net/wireless/iwlwifi/iwl-3945-debug.h
index 33016fb..85eb778 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945-debug.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945-debug.h
@@ -21,7 +21,7 @@
  * file called LICENSE.
  *
  * Contact Information:
- * James P. Ketrenos <ipw2100-admin@linux.intel.com>
+ *  Intel Linux Wireless <ilw@linux.intel.com>
  * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
  *
  *****************************************************************************/
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-hw.h b/drivers/net/wireless/iwlwifi/iwl-3945-hw.h
index f0f7dc7..15570e6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945-hw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945-hw.h
@@ -25,7 +25,7 @@
  * in the file called LICENSE.GPL.
  *
  * Contact Information:
- * James P. Ketrenos <ipw2100-admin@linux.intel.com>
+ *  Intel Linux Wireless <ilw@linux.intel.com>
  * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
  *
  * BSD LICENSE
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-io.h b/drivers/net/wireless/iwlwifi/iwl-3945-io.h
index d381b82..2440fd6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945-io.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945-io.h
@@ -21,7 +21,7 @@
  * file called LICENSE.
  *
  * Contact Information:
- * James P. Ketrenos <ipw2100-admin@linux.intel.com>
+ *  Intel Linux Wireless <ilw@linux.intel.com>
  * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
  *
  *****************************************************************************/
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-led.c b/drivers/net/wireless/iwlwifi/iwl-3945-led.c
index 705c65b..4c63890 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945-led.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945-led.c
@@ -19,7 +19,7 @@
  * file called LICENSE.
  *
  * Contact Information:
- * James P. Ketrenos <ipw2100-admin@linux.intel.com>
+ *  Intel Linux Wireless <ilw@linux.intel.com>
  * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
  *
  *****************************************************************************/
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-led.h b/drivers/net/wireless/iwlwifi/iwl-3945-led.h
index 2fbd126..749ac03 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945-led.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945-led.h
@@ -19,7 +19,7 @@
  * file called LICENSE.
  *
  * Contact Information:
- * James P. Ketrenos <ipw2100-admin@linux.intel.com>
+ *  Intel Linux Wireless <ilw@linux.intel.com>
  * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
  *
  *****************************************************************************/
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-rs.c b/drivers/net/wireless/iwlwifi/iwl-3945-rs.c
index 0ecf9d8..3861a3b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945-rs.c
@@ -19,7 +19,7 @@
  * file called LICENSE.
  *
  * Contact Information:
- * James P. Ketrenos <ipw2100-admin@linux.intel.com>
+ *  Intel Linux Wireless <ilw@linux.intel.com>
  * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
  *
  *****************************************************************************/
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-rs.h b/drivers/net/wireless/iwlwifi/iwl-3945-rs.h
index 98b17ae..b5a6613 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945-rs.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945-rs.h
@@ -19,7 +19,7 @@
  * file called LICENSE.
  *
  * Contact Information:
- * James P. Ketrenos <ipw2100-admin@linux.intel.com>
+ *  Intel Linux Wireless <ilw@linux.intel.com>
  * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
  *
  *****************************************************************************/
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index cbb8b0f..f2f2d8f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -19,7 +19,7 @@
  * file called LICENSE.
  *
  * Contact Information:
- * James P. Ketrenos <ipw2100-admin@linux.intel.com>
+ *  Intel Linux Wireless <ilw@linux.intel.com>
  * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
  *
  *****************************************************************************/
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.h b/drivers/net/wireless/iwlwifi/iwl-3945.h
index 05640a8..b7e366e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.h
@@ -19,7 +19,7 @@
  * file called LICENSE.
  *
  * Contact Information:
- * James P. Ketrenos <ipw2100-admin@linux.intel.com>
+ *  Intel Linux Wireless <ilw@linux.intel.com>
  * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
  *
  *****************************************************************************/
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965-hw.h b/drivers/net/wireless/iwlwifi/iwl-4965-hw.h
index fb0fd77..9873613 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965-hw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-4965-hw.h
@@ -25,7 +25,7 @@
  * in the file called LICENSE.GPL.
  *
  * Contact Information:
- * James P. Ketrenos <ipw2100-admin@linux.intel.com>
+ *  Intel Linux Wireless <ilw@linux.intel.com>
  * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
  *
  * BSD LICENSE
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 324825e..3afecf8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -19,7 +19,7 @@
  * file called LICENSE.
  *
  * Contact Information:
- * James P. Ketrenos <ipw2100-admin@linux.intel.com>
+ *  Intel Linux Wireless <ilw@linux.intel.com>
  * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
  *
  *****************************************************************************/
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000-hw.h b/drivers/net/wireless/iwlwifi/iwl-5000-hw.h
index c6595e8..82c3859 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000-hw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-5000-hw.h
@@ -25,7 +25,7 @@
  * in the file called LICENSE.GPL.
  *
  * Contact Information:
- * James P. Ketrenos <ipw2100-admin@linux.intel.com>
+ *  Intel Linux Wireless <ilw@linux.intel.com>
  * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
  *
  * BSD LICENSE
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-hcmd-check.c b/drivers/net/wireless/iwlwifi/iwl-agn-hcmd-check.c
index c50494a..b8137ee 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-hcmd-check.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-hcmd-check.c
@@ -22,7 +22,7 @@
  * in the file called LICENSE.GPL.
  *
  * Contact Information:
- * Tomas Winkler <tomas.winkler@intel.com>
+ *  Intel Linux Wireless <ilw@linux.intel.com>
  * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
  *****************************************************************************/
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
index c1cfb87..1fdf5f4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
@@ -19,7 +19,7 @@
  * file called LICENSE.
  *
  * Contact Information:
- * James P. Ketrenos <ipw2100-admin@linux.intel.com>
+ *  Intel Linux Wireless <ilw@linux.intel.com>
  * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
  *
  *****************************************************************************/
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.h b/drivers/net/wireless/iwlwifi/iwl-agn-rs.h
index adcbf53..78ee83a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.h
@@ -19,7 +19,7 @@
  * file called LICENSE.
  *
  * Contact Information:
- * James P. Ketrenos <ipw2100-admin@linux.intel.com>
+ *  Intel Linux Wireless <ilw@linux.intel.com>
  * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
  *
  *****************************************************************************/
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index fc4e7e4..e6a82b7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -22,7 +22,7 @@
  * file called LICENSE.
  *
  * Contact Information:
- * James P. Ketrenos <ipw2100-admin@linux.intel.com>
+ *  Intel Linux Wireless <ilw@linux.intel.com>
  * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
  *
  *****************************************************************************/
diff --git a/drivers/net/wireless/iwlwifi/iwl-calib.c b/drivers/net/wireless/iwlwifi/iwl-calib.c
index 25f4658..7956e08 100644
--- a/drivers/net/wireless/iwlwifi/iwl-calib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-calib.c
@@ -25,7 +25,7 @@
  * in the file called LICENSE.GPL.
  *
  * Contact Information:
- * Tomas Winkler <tomas.winkler@intel.com>
+ *  Intel Linux Wireless <ilw@linux.intel.com>
  * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
  *
  * BSD LICENSE
diff --git a/drivers/net/wireless/iwlwifi/iwl-calib.h b/drivers/net/wireless/iwlwifi/iwl-calib.h
index 94c8e31..1abe84b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-calib.h
+++ b/drivers/net/wireless/iwlwifi/iwl-calib.h
@@ -25,7 +25,7 @@
  * in the file called LICENSE.GPL.
  *
  * Contact Information:
- * Tomas Winkler <tomas.winkler@intel.com>
+ *  Intel Linux Wireless <ilw@linux.intel.com>
  * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
  *
  * BSD LICENSE
diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index 45656f2..0ba325d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -25,7 +25,7 @@
  * in the file called LICENSE.GPL.
  *
  * Contact Information:
- * James P. Ketrenos <ipw2100-admin@linux.intel.com>
+ *  Intel Linux Wireless <ilw@linux.intel.com>
  * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
  *
  * BSD LICENSE
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 1b021ca..3ef3c57 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -22,7 +22,7 @@
  * in the file called LICENSE.GPL.
  *
  * Contact Information:
- * Tomas Winkler <tomas.winkler@intel.com>
+ *  Intel Linux Wireless <ilw@linux.intel.com>
  * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
  *****************************************************************************/
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 81ddca0..983042b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -25,7 +25,7 @@
  * in the file called LICENSE.GPL.
  *
  * Contact Information:
- * Tomas Winkler <tomas.winkler@intel.com>
+ *  Intel Linux Wireless <ilw@linux.intel.com>
  * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
  *
  * BSD LICENSE
diff --git a/drivers/net/wireless/iwlwifi/iwl-csr.h b/drivers/net/wireless/iwlwifi/iwl-csr.h
index 84f56a2..b834e21 100644
--- a/drivers/net/wireless/iwlwifi/iwl-csr.h
+++ b/drivers/net/wireless/iwlwifi/iwl-csr.h
@@ -25,7 +25,7 @@
  * in the file called LICENSE.GPL.
  *
  * Contact Information:
- * James P. Ketrenos <ipw2100-admin@linux.intel.com>
+ *  Intel Linux Wireless <ilw@linux.intel.com>
  * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
  *
  * BSD LICENSE
diff --git a/drivers/net/wireless/iwlwifi/iwl-debug.h b/drivers/net/wireless/iwlwifi/iwl-debug.h
index a115dc6..e4c264b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debug.h
+++ b/drivers/net/wireless/iwlwifi/iwl-debug.h
@@ -21,7 +21,7 @@
  * file called LICENSE.
  *
  * Contact Information:
- * James P. Ketrenos <ipw2100-admin@linux.intel.com>
+ *  Intel Linux Wireless <ilw@linux.intel.com>
  * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
  *
  *****************************************************************************/
diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index 84053d8..feb4091 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -22,7 +22,7 @@
  * in the file called LICENSE.GPL.
  *
  * Contact Information:
- * Tomas Winkler <tomas.winkler@intel.com>
+ *  Intel Linux Wireless <ilw@linux.intel.com>
  * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
  *****************************************************************************/
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 25e8714..c32012e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -19,7 +19,7 @@
  * file called LICENSE.
  *
  * Contact Information:
- * James P. Ketrenos <ipw2100-admin@linux.intel.com>
+ *  Intel Linux Wireless <ilw@linux.intel.com>
  * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
  *
  *****************************************************************************/
diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom.c b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
index ae04327..a47fa38 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom.c
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
@@ -25,7 +25,7 @@
  * in the file called LICENSE.GPL.
  *
  * Contact Information:
- * Tomas Winkler <tomas.winkler@intel.com>
+ *  Intel Linux Wireless <ilw@linux.intel.com>
  * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
  *
  * BSD LICENSE
diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom.h b/drivers/net/wireless/iwlwifi/iwl-eeprom.h
index 8f6b05f..4b9de7a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom.h
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom.h
@@ -25,7 +25,7 @@
  * in the file called LICENSE.GPL.
  *
  * Contact Information:
- * Tomas Winkler <tomas.winkler@intel.com>
+ *  Intel Linux Wireless <ilw@linux.intel.com>
  * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
  *
  * BSD LICENSE
diff --git a/drivers/net/wireless/iwlwifi/iwl-fh.h b/drivers/net/wireless/iwlwifi/iwl-fh.h
index c3dadb0..2ff9434 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fh.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fh.h
@@ -25,7 +25,7 @@
  * in the file called LICENSE.GPL.
  *
  * Contact Information:
- * James P. Ketrenos <ipw2100-admin@linux.intel.com>
+ *  Intel Linux Wireless <ilw@linux.intel.com>
  * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
  *
  * BSD LICENSE
diff --git a/drivers/net/wireless/iwlwifi/iwl-hcmd.c b/drivers/net/wireless/iwlwifi/iwl-hcmd.c
index 0008a35..01a2169 100644
--- a/drivers/net/wireless/iwlwifi/iwl-hcmd.c
+++ b/drivers/net/wireless/iwlwifi/iwl-hcmd.c
@@ -22,7 +22,7 @@
  * in the file called LICENSE.GPL.
  *
  * Contact Information:
- * Tomas Winkler <tomas.winkler@intel.com>
+ *  Intel Linux Wireless <ilw@linux.intel.com>
  * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
  *****************************************************************************/
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-helpers.h b/drivers/net/wireless/iwlwifi/iwl-helpers.h
index 4f0fa21..d4d2829 100644
--- a/drivers/net/wireless/iwlwifi/iwl-helpers.h
+++ b/drivers/net/wireless/iwlwifi/iwl-helpers.h
@@ -22,7 +22,7 @@
  * file called LICENSE.
  *
  * Contact Information:
- * James P. Ketrenos <ipw2100-admin@linux.intel.com>
+ *  Intel Linux Wireless <ilw@linux.intel.com>
  * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
  *
  *****************************************************************************/
diff --git a/drivers/net/wireless/iwlwifi/iwl-io.h b/drivers/net/wireless/iwlwifi/iwl-io.h
index 10ca032..998ac19 100644
--- a/drivers/net/wireless/iwlwifi/iwl-io.h
+++ b/drivers/net/wireless/iwlwifi/iwl-io.h
@@ -21,7 +21,7 @@
  * file called LICENSE.
  *
  * Contact Information:
- * James P. Ketrenos <ipw2100-admin@linux.intel.com>
+ *  Intel Linux Wireless <ilw@linux.intel.com>
  * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
  *
  *****************************************************************************/
diff --git a/drivers/net/wireless/iwlwifi/iwl-led.c b/drivers/net/wireless/iwlwifi/iwl-led.c
index ffb428a..e8ce188 100644
--- a/drivers/net/wireless/iwlwifi/iwl-led.c
+++ b/drivers/net/wireless/iwlwifi/iwl-led.c
@@ -19,7 +19,7 @@
  * file called LICENSE.
  *
  * Contact Information:
- * James P. Ketrenos <ipw2100-admin@linux.intel.com>
+ *  Intel Linux Wireless <ilw@linux.intel.com>
  * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
  *
  *****************************************************************************/
diff --git a/drivers/net/wireless/iwlwifi/iwl-led.h b/drivers/net/wireless/iwlwifi/iwl-led.h
index 588c9ad..021e00b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-led.h
+++ b/drivers/net/wireless/iwlwifi/iwl-led.h
@@ -19,7 +19,7 @@
  * file called LICENSE.
  *
  * Contact Information:
- * James P. Ketrenos <ipw2100-admin@linux.intel.com>
+ *  Intel Linux Wireless <ilw@linux.intel.com>
  * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
  *
  *****************************************************************************/
diff --git a/drivers/net/wireless/iwlwifi/iwl-power.c b/drivers/net/wireless/iwlwifi/iwl-power.c
index b429daa..be8eb95 100644
--- a/drivers/net/wireless/iwlwifi/iwl-power.c
+++ b/drivers/net/wireless/iwlwifi/iwl-power.c
@@ -22,7 +22,7 @@
  * file called LICENSE.
  *
  * Contact Information:
- * James P. Ketrenos <ipw2100-admin@linux.intel.com>
+ *  Intel Linux Wireless <ilw@linux.intel.com>
  * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
  *****************************************************************************/
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-power.h b/drivers/net/wireless/iwlwifi/iwl-power.h
index df484a9..fa098d8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-power.h
+++ b/drivers/net/wireless/iwlwifi/iwl-power.h
@@ -22,7 +22,7 @@
  * file called LICENSE.
  *
  * Contact Information:
- * James P. Ketrenos <ipw2100-admin@linux.intel.com>
+ *  Intel Linux Wireless <ilw@linux.intel.com>
  * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
  *****************************************************************************/
 #ifndef __iwl_power_setting_h__
diff --git a/drivers/net/wireless/iwlwifi/iwl-prph.h b/drivers/net/wireless/iwlwifi/iwl-prph.h
index b0ffb89..b7a5f23 100644
--- a/drivers/net/wireless/iwlwifi/iwl-prph.h
+++ b/drivers/net/wireless/iwlwifi/iwl-prph.h
@@ -25,7 +25,7 @@
  * in the file called LICENSE.GPL.
  *
  * Contact Information:
- * James P. Ketrenos <ipw2100-admin@linux.intel.com>
+ *  Intel Linux Wireless <ilw@linux.intel.com>
  * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
  *
  * BSD LICENSE
diff --git a/drivers/net/wireless/iwlwifi/iwl-rfkill.c b/drivers/net/wireless/iwlwifi/iwl-rfkill.c
index 618841a..7894f2d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-rfkill.c
+++ b/drivers/net/wireless/iwlwifi/iwl-rfkill.c
@@ -22,7 +22,7 @@
  * file called LICENSE.
  *
  * Contact Information:
- * James P. Ketrenos <ipw2100-admin@linux.intel.com>
+ *  Intel Linux Wireless <ilw@linux.intel.com>
  * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
  *****************************************************************************/
 #include <linux/kernel.h>
diff --git a/drivers/net/wireless/iwlwifi/iwl-rfkill.h b/drivers/net/wireless/iwlwifi/iwl-rfkill.h
index 402fd4c..86dc055 100644
--- a/drivers/net/wireless/iwlwifi/iwl-rfkill.h
+++ b/drivers/net/wireless/iwlwifi/iwl-rfkill.h
@@ -22,7 +22,7 @@
  * file called LICENSE.
  *
  * Contact Information:
- * James P. Ketrenos <ipw2100-admin@linux.intel.com>
+ *  Intel Linux Wireless <ilw@linux.intel.com>
  * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
  *****************************************************************************/
 #ifndef __iwl_rf_kill_h__
diff --git a/drivers/net/wireless/iwlwifi/iwl-rx.c b/drivers/net/wireless/iwlwifi/iwl-rx.c
index 1938e6d..58d339e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-rx.c
@@ -22,7 +22,7 @@
  * file called LICENSE.
  *
  * Contact Information:
- * James P. Ketrenos <ipw2100-admin@linux.intel.com>
+ *  Intel Linux Wireless <ilw@linux.intel.com>
  * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
  *
  *****************************************************************************/
diff --git a/drivers/net/wireless/iwlwifi/iwl-scan.c b/drivers/net/wireless/iwlwifi/iwl-scan.c
index c4b9030..3c803f6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-scan.c
+++ b/drivers/net/wireless/iwlwifi/iwl-scan.c
@@ -22,7 +22,7 @@
  * in the file called LICENSE.GPL.
  *
  * Contact Information:
- * Tomas Winkler <tomas.winkler@intel.com>
+ *  Intel Linux Wireless <ilw@linux.intel.com>
  * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
  *****************************************************************************/
 #include <linux/types.h>
diff --git a/drivers/net/wireless/iwlwifi/iwl-spectrum.c b/drivers/net/wireless/iwlwifi/iwl-spectrum.c
index ad319a1..a9a1897 100644
--- a/drivers/net/wireless/iwlwifi/iwl-spectrum.c
+++ b/drivers/net/wireless/iwlwifi/iwl-spectrum.c
@@ -22,7 +22,7 @@
  * file called LICENSE.
  *
  * Contact Information:
- * Intel Linux Wireless <ilw@linux.intel.com>
+ *  Intel Linux Wireless <ilw@linux.intel.com>
  * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
  *
  *****************************************************************************/
diff --git a/drivers/net/wireless/iwlwifi/iwl-spectrum.h b/drivers/net/wireless/iwlwifi/iwl-spectrum.h
index fa990a1..b7d7943 100644
--- a/drivers/net/wireless/iwlwifi/iwl-spectrum.h
+++ b/drivers/net/wireless/iwlwifi/iwl-spectrum.h
@@ -21,7 +21,7 @@
  * file called LICENSE.
  *
  * Contact Information:
- * James P. Ketrenos <ipw2100-admin@linux.intel.com>
+ *  Intel Linux Wireless <ilw@linux.intel.com>
  * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
  *
  *****************************************************************************/
diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.c b/drivers/net/wireless/iwlwifi/iwl-sta.c
index a644a50..06e1808 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.c
@@ -22,7 +22,7 @@
  * file called LICENSE.
  *
  * Contact Information:
- * James P. Ketrenos <ipw2100-admin@linux.intel.com>
+ *  Intel Linux Wireless <ilw@linux.intel.com>
  * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
  *
  *****************************************************************************/
diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.h b/drivers/net/wireless/iwlwifi/iwl-sta.h
index 7b98ea4..9bb7cef 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.h
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.h
@@ -22,7 +22,7 @@
  * file called LICENSE.
  *
  * Contact Information:
- * James P. Ketrenos <ipw2100-admin@linux.intel.com>
+ *  Intel Linux Wireless <ilw@linux.intel.com>
  * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
  *
  *****************************************************************************/
diff --git a/drivers/net/wireless/iwlwifi/iwl-tx.c b/drivers/net/wireless/iwlwifi/iwl-tx.c
index 661a4e3..3cb4363 100644
--- a/drivers/net/wireless/iwlwifi/iwl-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
@@ -22,7 +22,7 @@
  * file called LICENSE.
  *
  * Contact Information:
- * James P. Ketrenos <ipw2100-admin@linux.intel.com>
+ *  Intel Linux Wireless <ilw@linux.intel.com>
  * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
  *
  *****************************************************************************/
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 5fdda51..f789cb8 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -22,7 +22,7 @@
  * file called LICENSE.
  *
  * Contact Information:
- * James P. Ketrenos <ipw2100-admin@linux.intel.com>
+ *  Intel Linux Wireless <ilw@linux.intel.com>
  * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
  *
  *****************************************************************************/
-- 
1.5.4.3

