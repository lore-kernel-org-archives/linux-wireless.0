Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:53385 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755920AbbLAKAD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Dec 2015 05:00:03 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 35/41] iwlwifi: change the Intel Wireless email address
Date: Tue,  1 Dec 2015 11:59:01 +0200
Message-Id: <1448963947-24302-35-git-send-email-emmanuel.grumbach@intel.com> (sfid-20151201_112252_358269_099E2504)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E905B07@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E905B07@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ilw@linux.intel.com is not available anymore.
linuxwifi@intel.com should be used instead.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/dvm/calib.c     |   2 +-
 drivers/net/wireless/intel/iwlwifi/dvm/calib.h     |   2 +-
 drivers/net/wireless/intel/iwlwifi/dvm/commands.h  |   2 +-
 drivers/net/wireless/intel/iwlwifi/dvm/devices.c   |   2 +-
 drivers/net/wireless/intel/iwlwifi/dvm/led.c       |   2 +-
 drivers/net/wireless/intel/iwlwifi/dvm/lib.c       |   2 +-
 drivers/net/wireless/intel/iwlwifi/dvm/power.c     |   2 +-
 drivers/net/wireless/intel/iwlwifi/dvm/power.h     |   2 +-
 drivers/net/wireless/intel/iwlwifi/dvm/ucode.c     |   2 +-
 drivers/net/wireless/intel/iwlwifi/iwl-1000.c      |   2 +-
 drivers/net/wireless/intel/iwlwifi/iwl-2000.c      |   2 +-
 drivers/net/wireless/intel/iwlwifi/iwl-5000.c      |   2 +-
 drivers/net/wireless/intel/iwlwifi/iwl-6000.c      |   2 +-
 drivers/net/wireless/intel/iwlwifi/iwl-agn-hw.h    |   2 +-
 .../net/wireless/intel/iwlwifi/iwl-devtrace-data.h |   2 +-
 .../net/wireless/intel/iwlwifi/iwl-devtrace-io.h   |   2 +-
 .../net/wireless/intel/iwlwifi/iwl-devtrace-msg.h  |   2 +-
 .../wireless/intel/iwlwifi/iwl-devtrace-ucode.h    |   2 +-
 .../net/wireless/intel/iwlwifi/iwl-eeprom-parse.c  |   2 +-
 .../net/wireless/intel/iwlwifi/iwl-eeprom-parse.h  |   2 +-
 .../net/wireless/intel/iwlwifi/iwl-eeprom-read.c   |   2 +-
 .../net/wireless/intel/iwlwifi/iwl-eeprom-read.h   |   2 +-
 drivers/net/wireless/intel/iwlwifi/iwl-fh.h        |   2 +-
 .../net/wireless/intel/iwlwifi/iwl-fw-error-dump.h |   2 +-
 drivers/net/wireless/intel/iwlwifi/iwl-fw.h        |   2 +-
 drivers/net/wireless/intel/iwlwifi/iwl-io.h        |   2 +-
 .../net/wireless/intel/iwlwifi/iwl-notif-wait.c    |   2 +-
 .../net/wireless/intel/iwlwifi/iwl-notif-wait.h    |   2 +-
 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c |   2 +-
 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.h |   2 +-
 drivers/net/wireless/intel/iwlwifi/iwl-scd.h       |   2 +-
 drivers/net/wireless/intel/iwlwifi/iwl-trans.c     |   2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/binding.c   |   2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs.h   |   2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api-d3.h |   2 +-
 .../net/wireless/intel/iwlwifi/mvm/fw-api-mac.h    |   2 +-
 .../net/wireless/intel/iwlwifi/mvm/fw-api-power.h  |   2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api-rs.h |   2 +-
 .../net/wireless/intel/iwlwifi/mvm/fw-api-sta.h    |   2 +-
 .../net/wireless/intel/iwlwifi/mvm/fw-api-stats.h  |   2 +-
 .../net/wireless/intel/iwlwifi/mvm/fw-api-tof.h    |   2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api-tx.h |   2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c    |   2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.h    |   2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/led.c       |   2 +-
 .../net/wireless/intel/iwlwifi/mvm/offloading.c    |   2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/sf.c        |   2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/testmode.h  |   2 +-
 .../net/wireless/intel/iwlwifi/mvm/time-event.c    |   2 +-
 .../net/wireless/intel/iwlwifi/mvm/time-event.h    |   2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/tt.c        |   2 +-
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c       |   2 +-
 intc-scripts/publishable-files                     | 203 ---------------------
 53 files changed, 52 insertions(+), 255 deletions(-)
 delete mode 100644 intc-scripts/publishable-files

diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/calib.c b/drivers/net/wireless/intel/iwlwifi/dvm/calib.c
index 20e6aa9..9be6362 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/calib.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/calib.c
@@ -25,7 +25,7 @@
  * in the file called COPYING.
  *
  * Contact Information:
- *  Intel Linux Wireless <ilw@linux.intel.com>
+ *  Intel Linux Wireless <linuxwifi@intel.com>
  * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
  *
  * BSD LICENSE
diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/calib.h b/drivers/net/wireless/intel/iwlwifi/dvm/calib.h
index aeae4e8..099e3ce 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/calib.h
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/calib.h
@@ -25,7 +25,7 @@
  * in the file called COPYING.
  *
  * Contact Information:
- *  Intel Linux Wireless <ilw@linux.intel.com>
+ *  Intel Linux Wireless <linuxwifi@intel.com>
  * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
  *
  * BSD LICENSE
diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/commands.h b/drivers/net/wireless/intel/iwlwifi/dvm/commands.h
index 7a34e4d..2ab2773 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/commands.h
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/commands.h
@@ -25,7 +25,7 @@
  * in the file called COPYING.
  *
  * Contact Information:
- *  Intel Linux Wireless <ilw@linux.intel.com>
+ *  Intel Linux Wireless <linuxwifi@intel.com>
  * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
  *
  * BSD LICENSE
diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/devices.c b/drivers/net/wireless/intel/iwlwifi/dvm/devices.c
index 34b41e5..cc13c04 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/devices.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/devices.c
@@ -19,7 +19,7 @@
  * file called LICENSE.
  *
  * Contact Information:
- *  Intel Linux Wireless <ilw@linux.intel.com>
+ *  Intel Linux Wireless <linuxwifi@intel.com>
  * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
  *
  *****************************************************************************/
diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/led.c b/drivers/net/wireless/intel/iwlwifi/dvm/led.c
index ca4d669..178806f 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/led.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/led.c
@@ -19,7 +19,7 @@
  * file called LICENSE.
  *
  * Contact Information:
- *  Intel Linux Wireless <ilw@linux.intel.com>
+ *  Intel Linux Wireless <linuxwifi@intel.com>
  * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
  *
  *****************************************************************************/
diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/lib.c b/drivers/net/wireless/intel/iwlwifi/dvm/lib.c
index e18629a..a612fbe 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/lib.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/lib.c
@@ -22,7 +22,7 @@
  * in the file called COPYING.
  *
  * Contact Information:
- *  Intel Linux Wireless <ilw@linux.intel.com>
+ *  Intel Linux Wireless <linuxwifi@intel.com>
  * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
  *
  *****************************************************************************/
diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/power.c b/drivers/net/wireless/intel/iwlwifi/dvm/power.c
index 1513dbc..0ad557c 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/power.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/power.c
@@ -22,7 +22,7 @@
  * file called LICENSE.
  *
  * Contact Information:
- *  Intel Linux Wireless <ilw@linux.intel.com>
+ *  Intel Linux Wireless <linuxwifi@intel.com>
  * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
  *****************************************************************************/
 
diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/power.h b/drivers/net/wireless/intel/iwlwifi/dvm/power.h
index 570d3a5..2fd9b43 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/power.h
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/power.h
@@ -22,7 +22,7 @@
  * file called LICENSE.
  *
  * Contact Information:
- *  Intel Linux Wireless <ilw@linux.intel.com>
+ *  Intel Linux Wireless <linuxwifi@intel.com>
  * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
  *****************************************************************************/
 #ifndef __iwl_power_setting_h__
diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/ucode.c b/drivers/net/wireless/intel/iwlwifi/dvm/ucode.c
index 931a8e4..b662cf3 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/ucode.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/ucode.c
@@ -23,7 +23,7 @@
  * in the file called COPYING.
  *
  * Contact Information:
- *  Intel Linux Wireless <ilw@linux.intel.com>
+ *  Intel Linux Wireless <linuxwifi@intel.com>
  * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
  *
  *****************************************************************************/
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-1000.c b/drivers/net/wireless/intel/iwlwifi/iwl-1000.c
index 06f6cc0..a90dbab 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-1000.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-1000.c
@@ -19,7 +19,7 @@
  * file called LICENSE.
  *
  * Contact Information:
- *  Intel Linux Wireless <ilw@linux.intel.com>
+ *  Intel Linux Wireless <linuxwifi@intel.com>
  * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
  *
  *****************************************************************************/
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-2000.c b/drivers/net/wireless/intel/iwlwifi/iwl-2000.c
index 890b95f..a6da959 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-2000.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-2000.c
@@ -19,7 +19,7 @@
  * file called LICENSE.
  *
  * Contact Information:
- *  Intel Linux Wireless <ilw@linux.intel.com>
+ *  Intel Linux Wireless <linuxwifi@intel.com>
  * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
  *
  *****************************************************************************/
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-5000.c b/drivers/net/wireless/intel/iwlwifi/iwl-5000.c
index 724194e..8b5afde 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-5000.c
@@ -19,7 +19,7 @@
  * file called LICENSE.
  *
  * Contact Information:
- *  Intel Linux Wireless <ilw@linux.intel.com>
+ *  Intel Linux Wireless <linuxwifi@intel.com>
  * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
  *
  *****************************************************************************/
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-6000.c b/drivers/net/wireless/intel/iwlwifi/iwl-6000.c
index 21b2630..0b4ba78 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-6000.c
@@ -19,7 +19,7 @@
  * file called LICENSE.
  *
  * Contact Information:
- *  Intel Linux Wireless <ilw@linux.intel.com>
+ *  Intel Linux Wireless <linuxwifi@intel.com>
  * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
  *
  *****************************************************************************/
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-agn-hw.h b/drivers/net/wireless/intel/iwlwifi/iwl-agn-hw.h
index 04a483d..ee9347a 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-agn-hw.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-agn-hw.h
@@ -25,7 +25,7 @@
  * in the file called COPYING.
  *
  * Contact Information:
- *  Intel Linux Wireless <ilw@linux.intel.com>
+ *  Intel Linux Wireless <linuxwifi@intel.com>
  * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
  *
  * BSD LICENSE
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-devtrace-data.h b/drivers/net/wireless/intel/iwlwifi/iwl-devtrace-data.h
index 71a78ce..bde0233 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-devtrace-data.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-devtrace-data.h
@@ -19,7 +19,7 @@
  * file called LICENSE.
  *
  * Contact Information:
- *  Intel Linux Wireless <ilw@linux.intel.com>
+ *  Intel Linux Wireless <linuxwifi@intel.com>
  * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
  *
  *****************************************************************************/
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-devtrace-io.h b/drivers/net/wireless/intel/iwlwifi/iwl-devtrace-io.h
index f62c5448..27914ee 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-devtrace-io.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-devtrace-io.h
@@ -19,7 +19,7 @@
  * file called LICENSE.
  *
  * Contact Information:
- *  Intel Linux Wireless <ilw@linux.intel.com>
+ *  Intel Linux Wireless <linuxwifi@intel.com>
  * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
  *
  *****************************************************************************/
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-devtrace-msg.h b/drivers/net/wireless/intel/iwlwifi/iwl-devtrace-msg.h
index a3b3c24..5dfc929 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-devtrace-msg.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-devtrace-msg.h
@@ -19,7 +19,7 @@
  * file called LICENSE.
  *
  * Contact Information:
- *  Intel Linux Wireless <ilw@linux.intel.com>
+ *  Intel Linux Wireless <linuxwifi@intel.com>
  * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
  *
  *****************************************************************************/
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-devtrace-ucode.h b/drivers/net/wireless/intel/iwlwifi/iwl-devtrace-ucode.h
index 10839fa..e9b8673 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-devtrace-ucode.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-devtrace-ucode.h
@@ -19,7 +19,7 @@
  * file called LICENSE.
  *
  * Contact Information:
- *  Intel Linux Wireless <ilw@linux.intel.com>
+ *  Intel Linux Wireless <linuxwifi@intel.com>
  * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
  *
  *****************************************************************************/
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-eeprom-parse.c b/drivers/net/wireless/intel/iwlwifi/iwl-eeprom-parse.c
index a19c458..b395854 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-eeprom-parse.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-eeprom-parse.c
@@ -26,7 +26,7 @@
  * in the file called COPYING.
  *
  * Contact Information:
- *  Intel Linux Wireless <ilw@linux.intel.com>
+ *  Intel Linux Wireless <linuxwifi@intel.com>
  * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
  *
  * BSD LICENSE
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-eeprom-parse.h b/drivers/net/wireless/intel/iwlwifi/iwl-eeprom-parse.h
index 750c8c9..ad2b834 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-eeprom-parse.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-eeprom-parse.h
@@ -26,7 +26,7 @@
  * in the file called COPYING.
  *
  * Contact Information:
- *  Intel Linux Wireless <ilw@linux.intel.com>
+ *  Intel Linux Wireless <linuxwifi@intel.com>
  * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
  *
  * BSD LICENSE
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-eeprom-read.c b/drivers/net/wireless/intel/iwlwifi/iwl-eeprom-read.c
index 219ca8a..f2cea1c 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-eeprom-read.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-eeprom-read.c
@@ -25,7 +25,7 @@
  * in the file called COPYING.
  *
  * Contact Information:
- *  Intel Linux Wireless <ilw@linux.intel.com>
+ *  Intel Linux Wireless <linuxwifi@intel.com>
  * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
  *
  * BSD LICENSE
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-eeprom-read.h b/drivers/net/wireless/intel/iwlwifi/iwl-eeprom-read.h
index a6d3bdf..1ed78be 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-eeprom-read.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-eeprom-read.h
@@ -25,7 +25,7 @@
  * in the file called COPYING.
  *
  * Contact Information:
- *  Intel Linux Wireless <ilw@linux.intel.com>
+ *  Intel Linux Wireless <linuxwifi@intel.com>
  * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
  *
  * BSD LICENSE
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-fh.h b/drivers/net/wireless/intel/iwlwifi/iwl-fh.h
index d560648..5cc6be9 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-fh.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-fh.h
@@ -25,7 +25,7 @@
  * in the file called COPYING.
  *
  * Contact Information:
- *  Intel Linux Wireless <ilw@linux.intel.com>
+ *  Intel Linux Wireless <linuxwifi@intel.com>
  * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
  *
  * BSD LICENSE
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-fw-error-dump.h b/drivers/net/wireless/intel/iwlwifi/iwl-fw-error-dump.h
index 73bcf29..f08a131 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-fw-error-dump.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-fw-error-dump.h
@@ -26,7 +26,7 @@
  * in the file called COPYING.
  *
  * Contact Information:
- *  Intel Linux Wireless <ilw@linux.intel.com>
+ *  Intel Linux Wireless <linuxwifi@intel.com>
  * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
  *
  * BSD LICENSE
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-fw.h b/drivers/net/wireless/intel/iwlwifi/iwl-fw.h
index 2e1909f..85d6d6d 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-fw.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-fw.h
@@ -26,7 +26,7 @@
  * in the file called COPYING.
  *
  * Contact Information:
- *  Intel Linux Wireless <ilw@linux.intel.com>
+ *  Intel Linux Wireless <linuxwifi@intel.com>
  * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
  *
  * BSD LICENSE
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-io.h b/drivers/net/wireless/intel/iwlwifi/iwl-io.h
index 2f4e12c..a9bcc78 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-io.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-io.h
@@ -21,7 +21,7 @@
  * file called LICENSE.
  *
  * Contact Information:
- *  Intel Linux Wireless <ilw@linux.intel.com>
+ *  Intel Linux Wireless <linuxwifi@intel.com>
  * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
  *
  *****************************************************************************/
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-notif-wait.c b/drivers/net/wireless/intel/iwlwifi/iwl-notif-wait.c
index 6caf2af..8aa1f2b 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-notif-wait.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-notif-wait.c
@@ -26,7 +26,7 @@
  * in the file called COPYING.
  *
  * Contact Information:
- *  Intel Linux Wireless <ilw@linux.intel.com>
+ *  Intel Linux Wireless <linuxwifi@intel.com>
  * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
  *
  * BSD LICENSE
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-notif-wait.h b/drivers/net/wireless/intel/iwlwifi/iwl-notif-wait.h
index dbe8234..0f9995e 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-notif-wait.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-notif-wait.h
@@ -26,7 +26,7 @@
  * in the file called COPYING.
  *
  * Contact Information:
- *  Intel Linux Wireless <ilw@linux.intel.com>
+ *  Intel Linux Wireless <linuxwifi@intel.com>
  * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
  *
  * BSD LICENSE
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c b/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
index 60b7fce..7b89bfc 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
@@ -26,7 +26,7 @@
  * in the file called COPYING.
  *
  * Contact Information:
- *  Intel Linux Wireless <ilw@linux.intel.com>
+ *  Intel Linux Wireless <linuxwifi@intel.com>
  * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
  *
  * BSD LICENSE
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.h b/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.h
index 822ba52..92466ee 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.h
@@ -25,7 +25,7 @@
  * in the file called COPYING.
  *
  * Contact Information:
- *  Intel Linux Wireless <ilw@linux.intel.com>
+ *  Intel Linux Wireless <linuxwifi@intel.com>
  * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
  *
  * BSD LICENSE
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-scd.h b/drivers/net/wireless/intel/iwlwifi/iwl-scd.h
index f2353eb..99b43da 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-scd.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-scd.h
@@ -25,7 +25,7 @@
  * in the file called COPYING.
  *
  * Contact Information:
- *  Intel Linux Wireless <ilw@linux.intel.com>
+ *  Intel Linux Wireless <linuxwifi@intel.com>
  * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
  *
  * BSD LICENSE
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-trans.c b/drivers/net/wireless/intel/iwlwifi/iwl-trans.c
index 7161096..ccd317b 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-trans.c
@@ -25,7 +25,7 @@
  * in the file called COPYING.
  *
  * Contact Information:
- *  Intel Linux Wireless <ilw@linux.intel.com>
+ *  Intel Linux Wireless <linuxwifi@intel.com>
  * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
  *
  * BSD LICENSE
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/binding.c b/drivers/net/wireless/intel/iwlwifi/mvm/binding.c
index a137653..7cb68f6 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/binding.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/binding.c
@@ -25,7 +25,7 @@
  * in the file called COPYING.
  *
  * Contact Information:
- *  Intel Linux Wireless <ilw@linux.intel.com>
+ *  Intel Linux Wireless <linuxwifi@intel.com>
  * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
  *
  * BSD LICENSE
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.h b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.h
index 8c4190e..ede6ef8 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.h
@@ -26,7 +26,7 @@
  * in the file called COPYING.
  *
  * Contact Information:
- *  Intel Linux Wireless <ilw@linux.intel.com>
+ *  Intel Linux Wireless <linuxwifi@intel.com>
  * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
  *
  * BSD LICENSE
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-d3.h b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-d3.h
index 20521be..228684c 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-d3.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-d3.h
@@ -26,7 +26,7 @@
  * in the file called COPYING.
  *
  * Contact Information:
- *  Intel Linux Wireless <ilw@linux.intel.com>
+ *  Intel Linux Wireless <linuxwifi@intel.com>
  * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
  *
  * BSD LICENSE
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-mac.h b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-mac.h
index f3f3ee0..95ac59d 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-mac.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-mac.h
@@ -25,7 +25,7 @@
  * in the file called COPYING.
  *
  * Contact Information:
- *  Intel Linux Wireless <ilw@linux.intel.com>
+ *  Intel Linux Wireless <linuxwifi@intel.com>
  * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
  *
  * BSD LICENSE
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-power.h b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-power.h
index c8f3e25..65a7c8a 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-power.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-power.h
@@ -27,7 +27,7 @@
  * in the file called COPYING.
  *
  * Contact Information:
- *  Intel Linux Wireless <ilw@linux.intel.com>
+ *  Intel Linux Wireless <linuxwifi@intel.com>
  * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
  *
  * BSD LICENSE
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-rs.h b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-rs.h
index 0f1ea80..ad9cc03 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-rs.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-rs.h
@@ -25,7 +25,7 @@
  * in the file called COPYING.
  *
  * Contact Information:
- *  Intel Linux Wireless <ilw@linux.intel.com>
+ *  Intel Linux Wireless <linuxwifi@intel.com>
  * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
  *
  * BSD LICENSE
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-sta.h b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-sta.h
index 493a8bd..6fca4fb 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-sta.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-sta.h
@@ -26,7 +26,7 @@
  * in the file called COPYING.
  *
  * Contact Information:
- *  Intel Linux Wireless <ilw@linux.intel.com>
+ *  Intel Linux Wireless <linuxwifi@intel.com>
  * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
  *
  * BSD LICENSE
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-stats.h b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-stats.h
index 0c321f6..438665a 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-stats.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-stats.h
@@ -26,7 +26,7 @@
  * in the file called COPYING.
  *
  * Contact Information:
- *  Intel Linux Wireless <ilw@linux.intel.com>
+ *  Intel Linux Wireless <linuxwifi@intel.com>
  * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
  *
  * BSD LICENSE
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-tof.h b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-tof.h
index eed6271..86aa51b 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-tof.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-tof.h
@@ -25,7 +25,7 @@
  * in the file called COPYING.
  *
  * Contact Information:
- * Intel Linux Wireless <ilw@linux.intel.com>
+ * Intel Linux Wireless <linuxwifi@intel.com>
  * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
  *
  * BSD LICENSE
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-tx.h b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-tx.h
index 853698a..0036d18 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-tx.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-tx.h
@@ -25,7 +25,7 @@
  * in the file called COPYING.
  *
  * Contact Information:
- *  Intel Linux Wireless <ilw@linux.intel.com>
+ *  Intel Linux Wireless <linuxwifi@intel.com>
  * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
  *
  * BSD LICENSE
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c b/drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c
index b8e0591..9fcabc5 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c
@@ -25,7 +25,7 @@
  * in the file called COPYING.
  *
  * Contact Information:
- *  Intel Linux Wireless <ilw@linux.intel.com>
+ *  Intel Linux Wireless <linuxwifi@intel.com>
  * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
  *
  * BSD LICENSE
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.h b/drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.h
index 32232d69..461acdf 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.h
@@ -25,7 +25,7 @@
  * in the file called COPYING.
  *
  * Contact Information:
- *  Intel Linux Wireless <ilw@linux.intel.com>
+ *  Intel Linux Wireless <linuxwifi@intel.com>
  * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
  *
  * BSD LICENSE
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/led.c b/drivers/net/wireless/intel/iwlwifi/mvm/led.c
index e3b3cf4..1e51fbe 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/led.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/led.c
@@ -25,7 +25,7 @@
  * in the file called COPYING.
  *
  * Contact Information:
- *  Intel Linux Wireless <ilw@linux.intel.com>
+ *  Intel Linux Wireless <linuxwifi@intel.com>
  * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
  *
  * BSD LICENSE
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/offloading.c b/drivers/net/wireless/intel/iwlwifi/mvm/offloading.c
index 68b0169..f83e2bc 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/offloading.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/offloading.c
@@ -26,7 +26,7 @@
  * in the file called COPYING.
  *
  * Contact Information:
- *  Intel Linux Wireless <ilw@linux.intel.com>
+ *  Intel Linux Wireless <linuxwifi@intel.com>
  * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
  *
  * BSD LICENSE
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sf.c b/drivers/net/wireless/intel/iwlwifi/mvm/sf.c
index b0f59fd..c2def12 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sf.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sf.c
@@ -26,7 +26,7 @@
  * in the file called COPYING.
  *
  * Contact Information:
- *  Intel Linux Wireless <ilw@linux.intel.com>
+ *  Intel Linux Wireless <linuxwifi@intel.com>
  * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
  *
  * BSD LICENSE
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/testmode.h b/drivers/net/wireless/intel/iwlwifi/mvm/testmode.h
index 79ab6be..cbbc16f 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/testmode.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/testmode.h
@@ -26,7 +26,7 @@
  * in the file called COPYING.
  *
  * Contact Information:
- *  Intel Linux Wireless <ilw@linux.intel.com>
+ *  Intel Linux Wireless <linuxwifi@intel.com>
  * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
  *
  * BSD LICENSE
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/time-event.c b/drivers/net/wireless/intel/iwlwifi/mvm/time-event.c
index 52692df..87a04c3 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/time-event.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/time-event.c
@@ -26,7 +26,7 @@
  * in the file called COPYING.
  *
  * Contact Information:
- *  Intel Linux Wireless <ilw@linux.intel.com>
+ *  Intel Linux Wireless <linuxwifi@intel.com>
  * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
  *
  * BSD LICENSE
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/time-event.h b/drivers/net/wireless/intel/iwlwifi/mvm/time-event.h
index cbdf8e52a..61d7cd7 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/time-event.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/time-event.h
@@ -26,7 +26,7 @@
  * in the file called COPYING.
  *
  * Contact Information:
- *  Intel Linux Wireless <ilw@linux.intel.com>
+ *  Intel Linux Wireless <linuxwifi@intel.com>
  * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
  *
  * BSD LICENSE
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tt.c b/drivers/net/wireless/intel/iwlwifi/mvm/tt.c
index cadfc04..473975c 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tt.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tt.c
@@ -26,7 +26,7 @@
  * in the file called COPYING.
  *
  * Contact Information:
- *  Intel Linux Wireless <ilw@linux.intel.com>
+ *  Intel Linux Wireless <linuxwifi@intel.com>
  * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
  *
  * BSD LICENSE
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
index 3db82bf..9193f0c 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
@@ -23,7 +23,7 @@
  * file called LICENSE.
  *
  * Contact Information:
- *  Intel Linux Wireless <ilw@linux.intel.com>
+ *  Intel Linux Wireless <linuxwifi@intel.com>
  * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
  *
  *****************************************************************************/
diff --git a/intc-scripts/publishable-files b/intc-scripts/publishable-files
deleted file mode 100644
index fbaa303..0000000
--- a/intc-scripts/publishable-files
+++ /dev/null
@@ -1,203 +0,0 @@
-.gitignore
-.local-symbols
-.blacklist.map
-Android.mk
-Android-make-iwlwifi.mk
-backport-include/*
-compat/*
-COPYING
-defconfig
-defconfigs/*
-drivers
-drivers/bluetooth/*
-drivers/net
-drivers/net/wireless
-drivers/net/wireless/realtek
-drivers/net/wireless/realtek/Makefile
-drivers/net/wireless/iwlwifi
-drivers/net/wireless/iwlwifi/iwl-7000.c
-drivers/net/wireless/iwlwifi/iwl-8000.c
-drivers/net/wireless/iwlwifi/iwl-9000.c
-drivers/net/wireless/iwlwifi/iwl-7999.c
-drivers/net/wireless/iwlwifi/iwl-agn-hw.h
-drivers/net/wireless/iwlwifi/iwl-config.h
-drivers/net/wireless/iwlwifi/iwl-constants.h
-drivers/net/wireless/iwlwifi/iwl-csr.h
-drivers/net/wireless/iwlwifi/iwl-dbg-cfg.c
-drivers/net/wireless/iwlwifi/iwl-dbg-cfg.h
-drivers/net/wireless/iwlwifi/iwl-debug.c
-drivers/net/wireless/iwlwifi/iwl-debug.h
-drivers/net/wireless/iwlwifi/iwl-devtrace.c
-drivers/net/wireless/iwlwifi/iwl-devtrace.h
-drivers/net/wireless/iwlwifi/iwl-devtrace-data.h
-drivers/net/wireless/iwlwifi/iwl-devtrace-io.h
-drivers/net/wireless/iwlwifi/iwl-devtrace-iwlwifi.h
-drivers/net/wireless/iwlwifi/iwl-devtrace-msg.h
-drivers/net/wireless/iwlwifi/iwl-devtrace-ucode.h
-drivers/net/wireless/iwlwifi/iwl-dnt-cfg.c
-drivers/net/wireless/iwlwifi/iwl-dnt-cfg.h
-drivers/net/wireless/iwlwifi/iwl-dnt-dev-if.c
-drivers/net/wireless/iwlwifi/iwl-dnt-dev-if.h
-drivers/net/wireless/iwlwifi/iwl-dnt-dispatch.c
-drivers/net/wireless/iwlwifi/iwl-dnt-dispatch.h
-drivers/net/wireless/iwlwifi/iwl-drv.c
-drivers/net/wireless/iwlwifi/iwl-drv.h
-drivers/net/wireless/iwlwifi/iwl-eeprom-parse.c
-drivers/net/wireless/iwlwifi/iwl-eeprom-parse.h
-drivers/net/wireless/iwlwifi/iwl-eeprom-read.c
-drivers/net/wireless/iwlwifi/iwl-eeprom-read.h
-drivers/net/wireless/iwlwifi/iwl-fh.h
-drivers/net/wireless/iwlwifi/iwl-fw-error-dump.h
-drivers/net/wireless/iwlwifi/iwl-fw-file.h
-drivers/net/wireless/iwlwifi/iwl-fw.h
-drivers/net/wireless/iwlwifi/iwl-io.c
-drivers/net/wireless/iwlwifi/iwl-io.h
-drivers/net/wireless/iwlwifi/iwl-modparams.h
-drivers/net/wireless/iwlwifi/iwl-notif-wait.c
-drivers/net/wireless/iwlwifi/iwl-notif-wait.h
-drivers/net/wireless/iwlwifi/iwl-nvm-parse.c
-drivers/net/wireless/iwlwifi/iwl-nvm-parse.h
-drivers/net/wireless/iwlwifi/iwl-op-mode.h
-drivers/net/wireless/iwlwifi/iwl-phy-db.c
-drivers/net/wireless/iwlwifi/iwl-phy-db.h
-drivers/net/wireless/iwlwifi/iwl-prph.h
-drivers/net/wireless/iwlwifi/iwl-tm-gnl.c
-drivers/net/wireless/iwlwifi/iwl-tm-gnl.h
-drivers/net/wireless/iwlwifi/iwl-tm-infc.h
-drivers/net/wireless/iwlwifi/iwl-trans.c
-drivers/net/wireless/iwlwifi/iwl-trans.h
-drivers/net/wireless/iwlwifi/Kconfig
-drivers/net/wireless/iwlwifi/Kconfig.noupstream
-drivers/net/wireless/iwlwifi/Makefile
-drivers/net/wireless/iwlwifi/iwl-scd.h
-drivers/net/wireless/iwlwifi/mvm
-drivers/net/wireless/iwlwifi/mvm/binding.c
-drivers/net/wireless/iwlwifi/mvm/coex.c
-drivers/net/wireless/iwlwifi/mvm/coex_legacy.c
-drivers/net/wireless/iwlwifi/mvm/constants.h
-drivers/net/wireless/iwlwifi/mvm/d3.c
-drivers/net/wireless/iwlwifi/mvm/debugfs.c
-drivers/net/wireless/iwlwifi/mvm/debugfs.h
-drivers/net/wireless/iwlwifi/mvm/debugfs-vif.c
-drivers/net/wireless/iwlwifi/mvm/fw-api-coex.h
-drivers/net/wireless/iwlwifi/mvm/fw-api-d3.h
-drivers/net/wireless/iwlwifi/mvm/fw-api.h
-drivers/net/wireless/iwlwifi/mvm/fw-api-mac.h
-drivers/net/wireless/iwlwifi/mvm/fw-api-power.h
-drivers/net/wireless/iwlwifi/mvm/fw-api-rs.h
-drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h
-drivers/net/wireless/iwlwifi/mvm/fw-api-sta.h
-drivers/net/wireless/iwlwifi/mvm/fw-api-stats.h
-drivers/net/wireless/iwlwifi/mvm/fw-api-tx.h
-drivers/net/wireless/iwlwifi/mvm/fw-api-rx.h
-drivers/net/wireless/iwlwifi/mvm/fw-api-tof.h
-drivers/net/wireless/iwlwifi/mvm/fw-api-gscan.h
-drivers/net/wireless/iwlwifi/mvm/fw-dbg.c
-drivers/net/wireless/iwlwifi/mvm/fw-dbg.h
-drivers/net/wireless/iwlwifi/mvm/fw.c
-drivers/net/wireless/iwlwifi/mvm/led.c
-drivers/net/wireless/iwlwifi/mvm/lte-coex.h
-drivers/net/wireless/iwlwifi/mvm/mac80211.c
-drivers/net/wireless/iwlwifi/mvm/tdls.c
-drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
-drivers/net/wireless/iwlwifi/mvm/Makefile
-drivers/net/wireless/iwlwifi/mvm/mvm.h
-drivers/net/wireless/iwlwifi/mvm/nvm.c
-drivers/net/wireless/iwlwifi/mvm/offloading.c
-drivers/net/wireless/iwlwifi/mvm/ops.c
-drivers/net/wireless/iwlwifi/mvm/phy-ctxt.c
-drivers/net/wireless/iwlwifi/mvm/power.c
-drivers/net/wireless/iwlwifi/mvm/power_legacy.c
-drivers/net/wireless/iwlwifi/mvm/quota.c
-drivers/net/wireless/iwlwifi/mvm/rs.c
-drivers/net/wireless/iwlwifi/mvm/rs.h
-drivers/net/wireless/iwlwifi/mvm/rx.c
-drivers/net/wireless/iwlwifi/mvm/scan.c
-drivers/net/wireless/iwlwifi/mvm/sf.c
-drivers/net/wireless/iwlwifi/mvm/sta.c
-drivers/net/wireless/iwlwifi/mvm/sta.h
-drivers/net/wireless/iwlwifi/mvm/testmode.h
-drivers/net/wireless/iwlwifi/mvm/testmode.c
-drivers/net/wireless/iwlwifi/mvm/fm-test.c
-drivers/net/wireless/iwlwifi/mvm/fm-ops.c
-drivers/net/wireless/iwlwifi/mvm/time-event.c
-drivers/net/wireless/iwlwifi/mvm/time-event.h
-drivers/net/wireless/iwlwifi/mvm/tt.c
-drivers/net/wireless/iwlwifi/mvm/tx.c
-drivers/net/wireless/iwlwifi/mvm/utils.c
-drivers/net/wireless/iwlwifi/mvm/vendor-cmd.c
-drivers/net/wireless/iwlwifi/mvm/vendor-cmd.h
-drivers/net/wireless/iwlwifi/mvm/tof.c
-drivers/net/wireless/iwlwifi/mvm/tof.h
-drivers/net/wireless/iwlwifi/pcie
-drivers/net/wireless/iwlwifi/pcie/drv.c
-drivers/net/wireless/iwlwifi/pcie/internal.h
-drivers/net/wireless/iwlwifi/pcie/rx.c
-drivers/net/wireless/iwlwifi/pcie/trans.c
-drivers/net/wireless/iwlwifi/pcie/tx.c
-drivers/net/wireless/iwlwifi/sdio
-drivers/net/wireless/iwlwifi/sdio/sdio_io_ext.c
-drivers/net/wireless/iwlwifi/sdio/sdio_io_ext.h
-drivers/net/wireless/iwlwifi/trans_slave
-drivers/net/wireless/iwlwifi/trans_slave/idi_al.h
-drivers/net/wireless/iwlwifi/trans_slave/idi_hals.c
-drivers/net/wireless/iwlwifi/trans_slave/idi_hals.h
-drivers/net/wireless/iwlwifi/trans_slave/idi_host_csr.h
-drivers/net/wireless/iwlwifi/trans_slave/idi_internal.h
-drivers/net/wireless/iwlwifi/trans_slave/idi_io.h
-drivers/net/wireless/iwlwifi/trans_slave/idi_irq_csr.h
-drivers/net/wireless/iwlwifi/trans_slave/idi_rx.c
-drivers/net/wireless/iwlwifi/trans_slave/idi_rx.h
-drivers/net/wireless/iwlwifi/trans_slave/idi_trans.c
-drivers/net/wireless/iwlwifi/trans_slave/idi_tx.c
-drivers/net/wireless/iwlwifi/trans_slave/idi_tx.h
-drivers/net/wireless/iwlwifi/trans_slave/idi_tx_policy.c
-drivers/net/wireless/iwlwifi/trans_slave/idi_tx_policy.h
-drivers/net/wireless/iwlwifi/trans_slave/idi_utils.c
-drivers/net/wireless/iwlwifi/trans_slave/idi_utils.h
-drivers/net/wireless/iwlwifi/trans_slave/mini_rpm.c
-drivers/net/wireless/iwlwifi/trans_slave/sdio_al.h
-drivers/net/wireless/iwlwifi/trans_slave/sdio_drv.c
-drivers/net/wireless/iwlwifi/trans_slave/sdio_internal.h
-drivers/net/wireless/iwlwifi/trans_slave/sdio_rx.c
-drivers/net/wireless/iwlwifi/trans_slave/sdio_trans.c
-drivers/net/wireless/iwlwifi/trans_slave/sdio_tx.c
-drivers/net/wireless/iwlwifi/trans_slave/sdio_tx.h
-drivers/net/wireless/iwlwifi/trans_slave/sdio_tx_policy.c
-drivers/net/wireless/iwlwifi/trans_slave/sdio_tx_policy.h
-drivers/net/wireless/iwlwifi/trans_slave/shared.c
-drivers/net/wireless/iwlwifi/trans_slave/shared.h
-drivers/net/wireless/iwlwifi/xvt
-drivers/net/wireless/iwlwifi/xvt/nvm.c
-drivers/net/wireless/iwlwifi/xvt/xvt.c
-drivers/net/wireless/iwlwifi/xvt/user-infc.c
-drivers/net/wireless/iwlwifi/xvt/xvt.h
-drivers/net/wireless/iwlwifi/xvt/fw-api.h
-drivers/net/wireless/iwlwifi/xvt/constants.h
-drivers/net/wireless/iwlwifi/xvt/Makefile
-drivers/net/wireless/iwlwifi/xvt/fw.c
-drivers/net/wireless/iwlwifi/xvt/user-infc.h
-drivers/net/wireless/iwlwifi/xvt/utils.c
-drivers/net/wireless/Kconfig
-drivers/net/wireless/mac80211_hwsim.c
-drivers/net/wireless/mac80211_hwsim.h
-drivers/net/wireless/Makefile
-net/*
-.git/*
-include/*
-kconf/*
-Kconfig
-Kconfig.sources
-Kconfig.package.hacks
-MAINTAINERS
-Makefile
-Makefile.build
-Makefile.kernel
-Makefile.real
-scripts/*
-udev/*
-versions
-intc-scripts
-intc-scripts/mv-compat-mod.py
-intc-scripts/ren-compat-deps.py
-intc-scripts/ren-compat-aliases.py
-- 
2.5.0

