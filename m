Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:43782 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726969AbeHXL3n (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 24 Aug 2018 07:29:43 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 24 Aug 2018 10:56:04 +0300
Message-Id: <20180824075604.26101-1-luca@coelho.fi> (sfid-20180824_095619_221082_CD64DBEC)
Subject: [PATCH] iwlwifi: remove all occurrences of the FSF address paragraph
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

The Free Software Foundation address is superfluous and causes
checkpatch to issue a warning when present.  Remove all paragraphs
with FSF's address to prevent that.

Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/cfg/1000.c           | 4 ----
 drivers/net/wireless/intel/iwlwifi/cfg/2000.c           | 4 ----
 drivers/net/wireless/intel/iwlwifi/cfg/5000.c           | 4 ----
 drivers/net/wireless/intel/iwlwifi/cfg/6000.c           | 4 ----
 drivers/net/wireless/intel/iwlwifi/cfg/7000.c           | 5 -----
 drivers/net/wireless/intel/iwlwifi/cfg/8000.c           | 5 -----
 drivers/net/wireless/intel/iwlwifi/dvm/agn.h            | 5 -----
 drivers/net/wireless/intel/iwlwifi/dvm/calib.c          | 5 -----
 drivers/net/wireless/intel/iwlwifi/dvm/calib.h          | 5 -----
 drivers/net/wireless/intel/iwlwifi/dvm/commands.h       | 5 -----
 drivers/net/wireless/intel/iwlwifi/dvm/debugfs.c        | 5 -----
 drivers/net/wireless/intel/iwlwifi/dvm/dev.h            | 4 ----
 drivers/net/wireless/intel/iwlwifi/dvm/devices.c        | 4 ----
 drivers/net/wireless/intel/iwlwifi/dvm/led.c            | 4 ----
 drivers/net/wireless/intel/iwlwifi/dvm/led.h            | 4 ----
 drivers/net/wireless/intel/iwlwifi/dvm/lib.c            | 5 -----
 drivers/net/wireless/intel/iwlwifi/dvm/mac80211.c       | 4 ----
 drivers/net/wireless/intel/iwlwifi/dvm/main.c           | 4 ----
 drivers/net/wireless/intel/iwlwifi/dvm/power.c          | 4 ----
 drivers/net/wireless/intel/iwlwifi/dvm/power.h          | 4 ----
 drivers/net/wireless/intel/iwlwifi/dvm/rs.c             | 4 ----
 drivers/net/wireless/intel/iwlwifi/dvm/rs.h             | 4 ----
 drivers/net/wireless/intel/iwlwifi/dvm/rx.c             | 4 ----
 drivers/net/wireless/intel/iwlwifi/dvm/rxon.c           | 4 ----
 drivers/net/wireless/intel/iwlwifi/dvm/scan.c           | 5 -----
 drivers/net/wireless/intel/iwlwifi/dvm/sta.c            | 4 ----
 drivers/net/wireless/intel/iwlwifi/dvm/tt.c             | 4 ----
 drivers/net/wireless/intel/iwlwifi/dvm/tt.h             | 4 ----
 drivers/net/wireless/intel/iwlwifi/dvm/tx.c             | 5 -----
 drivers/net/wireless/intel/iwlwifi/dvm/ucode.c          | 5 -----
 drivers/net/wireless/intel/iwlwifi/fw/acpi.c            | 3 ---
 drivers/net/wireless/intel/iwlwifi/fw/acpi.h            | 3 ---
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c             | 3 ---
 drivers/net/wireless/intel/iwlwifi/fw/dbg.h             | 3 ---
 drivers/net/wireless/intel/iwlwifi/fw/debugfs.c         | 3 ---
 drivers/net/wireless/intel/iwlwifi/fw/debugfs.h         | 3 ---
 drivers/net/wireless/intel/iwlwifi/fw/file.h            | 5 -----
 drivers/net/wireless/intel/iwlwifi/fw/img.h             | 5 -----
 drivers/net/wireless/intel/iwlwifi/fw/notif-wait.c      | 5 -----
 drivers/net/wireless/intel/iwlwifi/fw/notif-wait.h      | 5 -----
 drivers/net/wireless/intel/iwlwifi/iwl-agn-hw.h         | 5 -----
 drivers/net/wireless/intel/iwlwifi/iwl-config.h         | 5 -----
 drivers/net/wireless/intel/iwlwifi/iwl-csr.h            | 5 -----
 drivers/net/wireless/intel/iwlwifi/iwl-debug.c          | 5 -----
 drivers/net/wireless/intel/iwlwifi/iwl-debug.h          | 4 ----
 drivers/net/wireless/intel/iwlwifi/iwl-devtrace-io.h    | 4 ----
 drivers/net/wireless/intel/iwlwifi/iwl-devtrace-msg.h   | 4 ----
 drivers/net/wireless/intel/iwlwifi/iwl-devtrace-ucode.h | 4 ----
 drivers/net/wireless/intel/iwlwifi/iwl-devtrace.c       | 4 ----
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c            | 5 -----
 drivers/net/wireless/intel/iwlwifi/iwl-drv.h            | 5 -----
 drivers/net/wireless/intel/iwlwifi/iwl-eeprom-parse.c   | 3 ---
 drivers/net/wireless/intel/iwlwifi/iwl-eeprom-parse.h   | 5 -----
 drivers/net/wireless/intel/iwlwifi/iwl-eeprom-read.c    | 5 -----
 drivers/net/wireless/intel/iwlwifi/iwl-eeprom-read.h    | 5 -----
 drivers/net/wireless/intel/iwlwifi/iwl-fh.h             | 3 ---
 drivers/net/wireless/intel/iwlwifi/iwl-io.c             | 4 ----
 drivers/net/wireless/intel/iwlwifi/iwl-io.h             | 4 ----
 drivers/net/wireless/intel/iwlwifi/iwl-modparams.h      | 3 ---
 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c      | 5 -----
 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.h      | 5 -----
 drivers/net/wireless/intel/iwlwifi/iwl-op-mode.h        | 3 ---
 drivers/net/wireless/intel/iwlwifi/iwl-phy-db.c         | 5 -----
 drivers/net/wireless/intel/iwlwifi/iwl-phy-db.h         | 5 -----
 drivers/net/wireless/intel/iwlwifi/iwl-prph.h           | 5 -----
 drivers/net/wireless/intel/iwlwifi/iwl-scd.h            | 5 -----
 drivers/net/wireless/intel/iwlwifi/iwl-trans.c          | 5 -----
 drivers/net/wireless/intel/iwlwifi/iwl-trans.h          | 5 -----
 drivers/net/wireless/intel/iwlwifi/mvm/binding.c        | 5 -----
 drivers/net/wireless/intel/iwlwifi/mvm/coex.c           | 5 -----
 drivers/net/wireless/intel/iwlwifi/mvm/constants.h      | 5 -----
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs-vif.c    | 5 -----
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c        | 5 -----
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs.h        | 5 -----
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h         | 5 -----
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c             | 5 -----
 drivers/net/wireless/intel/iwlwifi/mvm/led.c            | 5 -----
 drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c       | 5 -----
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c       | 5 -----
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h            | 5 -----
 drivers/net/wireless/intel/iwlwifi/mvm/nvm.c            | 5 -----
 drivers/net/wireless/intel/iwlwifi/mvm/offloading.c     | 5 -----
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c            | 5 -----
 drivers/net/wireless/intel/iwlwifi/mvm/power.c          | 5 -----
 drivers/net/wireless/intel/iwlwifi/mvm/quota.c          | 5 -----
 drivers/net/wireless/intel/iwlwifi/mvm/rx.c             | 5 -----
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c           | 3 ---
 drivers/net/wireless/intel/iwlwifi/mvm/sf.c             | 5 -----
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c            | 5 -----
 drivers/net/wireless/intel/iwlwifi/mvm/tdls.c           | 3 ---
 drivers/net/wireless/intel/iwlwifi/mvm/testmode.h       | 5 -----
 drivers/net/wireless/intel/iwlwifi/mvm/time-event.h     | 5 -----
 drivers/net/wireless/intel/iwlwifi/mvm/tof.c            | 5 -----
 drivers/net/wireless/intel/iwlwifi/mvm/tof.h            | 5 -----
 drivers/net/wireless/intel/iwlwifi/mvm/tt.c             | 5 -----
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c             | 5 -----
 drivers/net/wireless/intel/iwlwifi/mvm/utils.c          | 5 -----
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c           | 5 -----
 drivers/net/wireless/intel/iwlwifi/pcie/internal.h      | 3 ---
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c            | 3 ---
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c         | 5 -----
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c            | 4 ----
 102 files changed, 455 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/cfg/1000.c b/drivers/net/wireless/intel/iwlwifi/cfg/1000.c
index 591687984962..46686ee88ff4 100644
--- a/drivers/net/wireless/intel/iwlwifi/cfg/1000.c
+++ b/drivers/net/wireless/intel/iwlwifi/cfg/1000.c
@@ -12,10 +12,6 @@
  * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
  * more details.
  *
- * You should have received a copy of the GNU General Public License along with
- * this program; if not, write to the Free Software Foundation, Inc.,
- * 51 Franklin Street, Fifth Floor, Boston, MA 02110, USA
- *
  * The full GNU General Public License is included in this distribution in the
  * file called LICENSE.
  *
diff --git a/drivers/net/wireless/intel/iwlwifi/cfg/2000.c b/drivers/net/wireless/intel/iwlwifi/cfg/2000.c
index fedb108db68f..e7e45846dd07 100644
--- a/drivers/net/wireless/intel/iwlwifi/cfg/2000.c
+++ b/drivers/net/wireless/intel/iwlwifi/cfg/2000.c
@@ -12,10 +12,6 @@
  * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
  * more details.
  *
- * You should have received a copy of the GNU General Public License along with
- * this program; if not, write to the Free Software Foundation, Inc.,
- * 51 Franklin Street, Fifth Floor, Boston, MA 02110, USA
- *
  * The full GNU General Public License is included in this distribution in the
  * file called LICENSE.
  *
diff --git a/drivers/net/wireless/intel/iwlwifi/cfg/5000.c b/drivers/net/wireless/intel/iwlwifi/cfg/5000.c
index 36151e61a26f..575a7022d045 100644
--- a/drivers/net/wireless/intel/iwlwifi/cfg/5000.c
+++ b/drivers/net/wireless/intel/iwlwifi/cfg/5000.c
@@ -12,10 +12,6 @@
  * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
  * more details.
  *
- * You should have received a copy of the GNU General Public License along with
- * this program; if not, write to the Free Software Foundation, Inc.,
- * 51 Franklin Street, Fifth Floor, Boston, MA 02110, USA
- *
  * The full GNU General Public License is included in this distribution in the
  * file called LICENSE.
  *
diff --git a/drivers/net/wireless/intel/iwlwifi/cfg/6000.c b/drivers/net/wireless/intel/iwlwifi/cfg/6000.c
index b5d8274761d8..30e62a7c9d52 100644
--- a/drivers/net/wireless/intel/iwlwifi/cfg/6000.c
+++ b/drivers/net/wireless/intel/iwlwifi/cfg/6000.c
@@ -12,10 +12,6 @@
  * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
  * more details.
  *
- * You should have received a copy of the GNU General Public License along with
- * this program; if not, write to the Free Software Foundation, Inc.,
- * 51 Franklin Street, Fifth Floor, Boston, MA 02110, USA
- *
  * The full GNU General Public License is included in this distribution in the
  * file called LICENSE.
  *
diff --git a/drivers/net/wireless/intel/iwlwifi/cfg/7000.c b/drivers/net/wireless/intel/iwlwifi/cfg/7000.c
index a62c8346f13a..c973bfaa3414 100644
--- a/drivers/net/wireless/intel/iwlwifi/cfg/7000.c
+++ b/drivers/net/wireless/intel/iwlwifi/cfg/7000.c
@@ -19,11 +19,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
  * General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110,
- * USA
- *
  * The full GNU General Public License is included in this distribution
  * in the file called COPYING.
  *
diff --git a/drivers/net/wireless/intel/iwlwifi/cfg/8000.c b/drivers/net/wireless/intel/iwlwifi/cfg/8000.c
index c46fa712985b..348c40fcddcb 100644
--- a/drivers/net/wireless/intel/iwlwifi/cfg/8000.c
+++ b/drivers/net/wireless/intel/iwlwifi/cfg/8000.c
@@ -19,11 +19,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
  * General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110,
- * USA
- *
  * The full GNU General Public License is included in this distribution
  * in the file called COPYING.
  *
diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/agn.h b/drivers/net/wireless/intel/iwlwifi/dvm/agn.h
index b79e38734f2f..431e13c6ee35 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/agn.h
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/agn.h
@@ -16,11 +16,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
  * General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110,
- * USA
- *
  * The full GNU General Public License is included in this distribution
  * in the file called COPYING.
  *
diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/calib.c b/drivers/net/wireless/intel/iwlwifi/dvm/calib.c
index c96f9b1d948a..588b15697710 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/calib.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/calib.c
@@ -16,11 +16,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
  * General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110,
- * USA
- *
  * The full GNU General Public License is included in this distribution
  * in the file called COPYING.
  *
diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/calib.h b/drivers/net/wireless/intel/iwlwifi/dvm/calib.h
index 099e3ce80ffc..c43ba94bfa8b 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/calib.h
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/calib.h
@@ -16,11 +16,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
  * General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110,
- * USA
- *
  * The full GNU General Public License is included in this distribution
  * in the file called COPYING.
  *
diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/commands.h b/drivers/net/wireless/intel/iwlwifi/dvm/commands.h
index f89736d60a3d..0f4be4be181c 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/commands.h
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/commands.h
@@ -16,11 +16,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
  * General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110,
- * USA
- *
  * The full GNU General Public License is included in this distribution
  * in the file called COPYING.
  *
diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/debugfs.c b/drivers/net/wireless/intel/iwlwifi/dvm/debugfs.c
index 096a07c5a33f..3d2e44a642de 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/debugfs.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/debugfs.c
@@ -13,11 +13,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
  * General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110,
- * USA
- *
  * The full GNU General Public License is included in this distribution
  * in the file called COPYING.
  *
diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/dev.h b/drivers/net/wireless/intel/iwlwifi/dvm/dev.h
index cceb4cd8e501..c5b8376d827f 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/dev.h
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/dev.h
@@ -11,10 +11,6 @@
  * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
  * more details.
  *
- * You should have received a copy of the GNU General Public License along with
- * this program; if not, write to the Free Software Foundation, Inc.,
- * 51 Franklin Street, Fifth Floor, Boston, MA 02110, USA
- *
  * The full GNU General Public License is included in this distribution in the
  * file called LICENSE.
  *
diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/devices.c b/drivers/net/wireless/intel/iwlwifi/dvm/devices.c
index f21732ec3b25..3dd7d8c45dab 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/devices.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/devices.c
@@ -11,10 +11,6 @@
  * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
  * more details.
  *
- * You should have received a copy of the GNU General Public License along with
- * this program; if not, write to the Free Software Foundation, Inc.,
- * 51 Franklin Street, Fifth Floor, Boston, MA 02110, USA
- *
  * The full GNU General Public License is included in this distribution in the
  * file called LICENSE.
  *
diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/led.c b/drivers/net/wireless/intel/iwlwifi/dvm/led.c
index 1bbd17ada974..04c236e9399b 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/led.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/led.c
@@ -11,10 +11,6 @@
  * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
  * more details.
  *
- * You should have received a copy of the GNU General Public License along with
- * this program; if not, write to the Free Software Foundation, Inc.,
- * 51 Franklin Street, Fifth Floor, Boston, MA 02110, USA
- *
  * The full GNU General Public License is included in this distribution in the
  * file called LICENSE.
  *
diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/led.h b/drivers/net/wireless/intel/iwlwifi/dvm/led.h
index 75f74edd018f..8f93a3246dee 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/led.h
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/led.h
@@ -11,10 +11,6 @@
  * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
  * more details.
  *
- * You should have received a copy of the GNU General Public License along with
- * this program; if not, write to the Free Software Foundation, Inc.,
- * 51 Franklin Street, Fifth Floor, Boston, MA 02110, USA
- *
  * The full GNU General Public License is included in this distribution in the
  * file called LICENSE.
  *
diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/lib.c b/drivers/net/wireless/intel/iwlwifi/dvm/lib.c
index 2b6ffbc46fa5..b2f172d4f78a 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/lib.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/lib.c
@@ -13,11 +13,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
  * General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110,
- * USA
- *
  * The full GNU General Public License is included in this distribution
  * in the file called COPYING.
  *
diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/dvm/mac80211.c
index 82caae02dd09..49b71dbf8490 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/mac80211.c
@@ -14,10 +14,6 @@
  * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
  * more details.
  *
- * You should have received a copy of the GNU General Public License along with
- * this program; if not, write to the Free Software Foundation, Inc.,
- * 51 Franklin Street, Fifth Floor, Boston, MA 02110, USA
- *
  * The full GNU General Public License is included in this distribution in the
  * file called LICENSE.
  *
diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/main.c b/drivers/net/wireless/intel/iwlwifi/dvm/main.c
index 030482b357a3..1ef072071b0b 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/main.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/main.c
@@ -15,10 +15,6 @@
  * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
  * more details.
  *
- * You should have received a copy of the GNU General Public License along with
- * this program; if not, write to the Free Software Foundation, Inc.,
- * 51 Franklin Street, Fifth Floor, Boston, MA 02110, USA
- *
  * The full GNU General Public License is included in this distribution in the
  * file called LICENSE.
  *
diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/power.c b/drivers/net/wireless/intel/iwlwifi/dvm/power.c
index 0ad557c89514..8c25e3aefb2b 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/power.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/power.c
@@ -14,10 +14,6 @@
  * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
  * more details.
  *
- * You should have received a copy of the GNU General Public License along with
- * this program; if not, write to the Free Software Foundation, Inc.,
- * 51 Franklin Street, Fifth Floor, Boston, MA 02110, USA
- *
  * The full GNU General Public License is included in this distribution in the
  * file called LICENSE.
  *
diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/power.h b/drivers/net/wireless/intel/iwlwifi/dvm/power.h
index 2fd9b43adafd..a04fd4d375c6 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/power.h
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/power.h
@@ -14,10 +14,6 @@
  * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
  * more details.
  *
- * You should have received a copy of the GNU General Public License along with
- * this program; if not, write to the Free Software Foundation, Inc.,
- * 51 Franklin Street, Fifth Floor, Boston, MA 02110, USA
- *
  * The full GNU General Public License is included in this distribution in the
  * file called LICENSE.
  *
diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/rs.c b/drivers/net/wireless/intel/iwlwifi/dvm/rs.c
index 98050d7be411..ef4b9de256f7 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/rs.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/rs.c
@@ -11,10 +11,6 @@
  * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
  * more details.
  *
- * You should have received a copy of the GNU General Public License along with
- * this program; if not, write to the Free Software Foundation, Inc.,
- * 51 Franklin Street, Fifth Floor, Boston, MA 02110, USA
- *
  * The full GNU General Public License is included in this distribution in the
  * file called LICENSE.
  *
diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/rs.h b/drivers/net/wireless/intel/iwlwifi/dvm/rs.h
index 50c1e951dd2d..b2df3a8cc464 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/rs.h
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/rs.h
@@ -11,10 +11,6 @@
  * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
  * more details.
  *
- * You should have received a copy of the GNU General Public License along with
- * this program; if not, write to the Free Software Foundation, Inc.,
- * 51 Franklin Street, Fifth Floor, Boston, MA 02110, USA
- *
  * The full GNU General Public License is included in this distribution in the
  * file called LICENSE.
  *
diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/rx.c b/drivers/net/wireless/intel/iwlwifi/dvm/rx.c
index c942830af2b5..6f17a5e24e82 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/rx.c
@@ -15,10 +15,6 @@
  * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
  * more details.
  *
- * You should have received a copy of the GNU General Public License along with
- * this program; if not, write to the Free Software Foundation, Inc.,
- * 51 Franklin Street, Fifth Floor, Boston, MA 02110, USA
- *
  * The full GNU General Public License is included in this distribution in the
  * file called LICENSE.
  *
diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/rxon.c b/drivers/net/wireless/intel/iwlwifi/dvm/rxon.c
index 8f3e5586eda9..eee1d48d453a 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/rxon.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/rxon.c
@@ -12,10 +12,6 @@
  * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
  * more details.
  *
- * You should have received a copy of the GNU General Public License along with
- * this program; if not, write to the Free Software Foundation, Inc.,
- * 51 Franklin Street, Fifth Floor, Boston, MA 02110, USA
- *
  * The full GNU General Public License is included in this distribution in the
  * file called LICENSE.
  *
diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/scan.c b/drivers/net/wireless/intel/iwlwifi/dvm/scan.c
index 17e6a32384d3..8d7aafb4d9e9 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/scan.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/scan.c
@@ -13,11 +13,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
  * General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110,
- * USA
- *
  * The full GNU General Public License is included in this distribution
  * in the file called COPYING.
  *
diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/sta.c b/drivers/net/wireless/intel/iwlwifi/dvm/sta.c
index de6ec9b7ace4..b1792de09594 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/sta.c
@@ -14,10 +14,6 @@
  * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
  * more details.
  *
- * You should have received a copy of the GNU General Public License along with
- * this program; if not, write to the Free Software Foundation, Inc.,
- * 51 Franklin Street, Fifth Floor, Boston, MA 02110, USA
- *
  * The full GNU General Public License is included in this distribution in the
  * file called LICENSE.
  *
diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/tt.c b/drivers/net/wireless/intel/iwlwifi/dvm/tt.c
index 6524533d723c..4de2727ac63e 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/tt.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/tt.c
@@ -14,10 +14,6 @@
  * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
  * more details.
  *
- * You should have received a copy of the GNU General Public License along with
- * this program; if not, write to the Free Software Foundation, Inc.,
- * 51 Franklin Street, Fifth Floor, Boston, MA 02110, USA
- *
  * The full GNU General Public License is included in this distribution in the
  * file called LICENSE.
  *
diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/tt.h b/drivers/net/wireless/intel/iwlwifi/dvm/tt.h
index d324e9be9cbf..6388c09603c6 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/tt.h
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/tt.h
@@ -14,10 +14,6 @@
  * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
  * more details.
  *
- * You should have received a copy of the GNU General Public License along with
- * this program; if not, write to the Free Software Foundation, Inc.,
- * 51 Franklin Street, Fifth Floor, Boston, MA 02110, USA
- *
  * The full GNU General Public License is included in this distribution in the
  * file called LICENSE.
  *
diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/tx.c b/drivers/net/wireless/intel/iwlwifi/dvm/tx.c
index fb40ddfced99..4ff323a3a4e5 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/tx.c
@@ -13,11 +13,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
  * General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110,
- * USA
- *
  * The full GNU General Public License is included in this distribution
  * in the file called COPYING.
  *
diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/ucode.c b/drivers/net/wireless/intel/iwlwifi/dvm/ucode.c
index d6013bfe991c..3bf57085b976 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/ucode.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/ucode.c
@@ -14,11 +14,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
  * General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110,
- * USA
- *
  * The full GNU General Public License is included in this distribution
  * in the file called COPYING.
  *
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/acpi.c b/drivers/net/wireless/intel/iwlwifi/fw/acpi.c
index 75cae54ea7de..32d000cffe9f 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/acpi.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/acpi.c
@@ -16,9 +16,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
  * General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program;
- *
  * The full GNU General Public License is included in this distribution
  * in the file called COPYING.
  *
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/acpi.h b/drivers/net/wireless/intel/iwlwifi/fw/acpi.h
index cb5f32c1d705..2439e98431ee 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/acpi.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/acpi.h
@@ -16,9 +16,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
  * General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program;
- *
  * The full GNU General Public License is included in this distribution
  * in the file called COPYING.
  *
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
index 9c1d13e6bad3..37b1e1f13621 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
@@ -19,9 +19,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
  * General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program;
- *
  * The full GNU General Public License is included in this distribution
  * in the file called COPYING.
  *
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dbg.h b/drivers/net/wireless/intel/iwlwifi/fw/dbg.h
index 2c6df7756927..5eba0e7ca760 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.h
@@ -19,9 +19,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
  * General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program;
- *
  * The full GNU General Public License is included in this distribution
  * in the file called COPYING.
  *
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/debugfs.c b/drivers/net/wireless/intel/iwlwifi/fw/debugfs.c
index c1f087c50cc9..1049bdfe1e69 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/debugfs.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/debugfs.c
@@ -19,9 +19,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
  * General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program.
- *
  * The full GNU General Public License is included in this distribution
  * in the file called COPYING.
  *
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/debugfs.h b/drivers/net/wireless/intel/iwlwifi/fw/debugfs.h
index cbbfa8e9e66d..88255035e8ef 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/debugfs.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/debugfs.h
@@ -18,9 +18,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
  * General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program.
- *
  * The full GNU General Public License is included in this distribution
  * in the file called COPYING.
  *
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/file.h b/drivers/net/wireless/intel/iwlwifi/fw/file.h
index 7638d0bb1e11..858af103e6fd 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/file.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/file.h
@@ -19,11 +19,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
  * General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110,
- * USA
- *
  * The full GNU General Public License is included in this distribution
  * in the file called COPYING.
  *
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/img.h b/drivers/net/wireless/intel/iwlwifi/fw/img.h
index 0861b97c4233..9cc8fe8908ac 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/img.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/img.h
@@ -19,11 +19,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
  * General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110,
- * USA
- *
  * The full GNU General Public License is included in this distribution
  * in the file called COPYING.
  *
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/notif-wait.c b/drivers/net/wireless/intel/iwlwifi/fw/notif-wait.c
index 1096c945a68b..379735e086dc 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/notif-wait.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/notif-wait.c
@@ -17,11 +17,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
  * General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110,
- * USA
- *
  * The full GNU General Public License is included in this distribution
  * in the file called COPYING.
  *
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/notif-wait.h b/drivers/net/wireless/intel/iwlwifi/fw/notif-wait.h
index 368884be4e7c..61b067eeeac9 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/notif-wait.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/notif-wait.h
@@ -17,11 +17,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
  * General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110,
- * USA
- *
  * The full GNU General Public License is included in this distribution
  * in the file called COPYING.
  *
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-agn-hw.h b/drivers/net/wireless/intel/iwlwifi/iwl-agn-hw.h
index ee9347a54cdc..359537620c93 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-agn-hw.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-agn-hw.h
@@ -16,11 +16,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
  * General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110,
- * USA
- *
  * The full GNU General Public License is included in this distribution
  * in the file called COPYING.
  *
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-config.h b/drivers/net/wireless/intel/iwlwifi/iwl-config.h
index 4d16ac545269..5e1280783376 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-config.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-config.h
@@ -18,11 +18,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
  * General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110,
- * USA
- *
  * The full GNU General Public License is included in this distribution
  * in the file called COPYING.
  *
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-csr.h b/drivers/net/wireless/intel/iwlwifi/iwl-csr.h
index e2b29b844c3a..caa5806acd81 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-csr.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-csr.h
@@ -19,11 +19,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
  * General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110,
- * USA
- *
  * The full GNU General Public License is included in this distribution
  * in the file called COPYING.
  *
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-debug.c b/drivers/net/wireless/intel/iwlwifi/iwl-debug.c
index b1c3b0d0fcc6..e1a41fd503a8 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-debug.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-debug.c
@@ -16,11 +16,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
  * General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110,
- * USA
- *
  * The full GNU General Public License is included in this distribution
  * in the file called COPYING.
  *
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-debug.h b/drivers/net/wireless/intel/iwlwifi/iwl-debug.h
index c023fcf5d452..a2af68a0d34b 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-debug.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-debug.h
@@ -13,10 +13,6 @@
  * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
  * more details.
  *
- * You should have received a copy of the GNU General Public License along with
- * this program; if not, write to the Free Software Foundation, Inc.,
- * 51 Franklin Street, Fifth Floor, Boston, MA 02110, USA
- *
  * The full GNU General Public License is included in this distribution in the
  * file called LICENSE.
  *
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-devtrace-io.h b/drivers/net/wireless/intel/iwlwifi/iwl-devtrace-io.h
index 4164dc1745ed..7bb4e0e9bb69 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-devtrace-io.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-devtrace-io.h
@@ -12,10 +12,6 @@
  * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
  * more details.
  *
- * You should have received a copy of the GNU General Public License along with
- * this program; if not, write to the Free Software Foundation, Inc.,
- * 51 Franklin Street, Fifth Floor, Boston, MA 02110, USA
- *
  * The full GNU General Public License is included in this distribution in the
  * file called LICENSE.
  *
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-devtrace-msg.h b/drivers/net/wireless/intel/iwlwifi/iwl-devtrace-msg.h
index 5dfc9295a7e0..32984c1f39a1 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-devtrace-msg.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-devtrace-msg.h
@@ -11,10 +11,6 @@
  * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
  * more details.
  *
- * You should have received a copy of the GNU General Public License along with
- * this program; if not, write to the Free Software Foundation, Inc.,
- * 51 Franklin Street, Fifth Floor, Boston, MA 02110, USA
- *
  * The full GNU General Public License is included in this distribution in the
  * file called LICENSE.
  *
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-devtrace-ucode.h b/drivers/net/wireless/intel/iwlwifi/iwl-devtrace-ucode.h
index e9b8673dd245..53842226ef1b 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-devtrace-ucode.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-devtrace-ucode.h
@@ -11,10 +11,6 @@
  * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
  * more details.
  *
- * You should have received a copy of the GNU General Public License along with
- * this program; if not, write to the Free Software Foundation, Inc.,
- * 51 Franklin Street, Fifth Floor, Boston, MA 02110, USA
- *
  * The full GNU General Public License is included in this distribution in the
  * file called LICENSE.
  *
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-devtrace.c b/drivers/net/wireless/intel/iwlwifi/iwl-devtrace.c
index 6aa719865a58..27b4dd409a0e 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-devtrace.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-devtrace.c
@@ -11,10 +11,6 @@
  * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
  * more details.
  *
- * You should have received a copy of the GNU General Public License along with
- * this program; if not, write to the Free Software Foundation, Inc.,
- * 51 Franklin Street, Fifth Floor, Boston, MA 02110, USA
- *
  * The full GNU General Public License is included in this distribution in the
  * file called LICENSE.
  *
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
index 39a1eadfc4b7..76f50b99af2a 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
@@ -18,11 +18,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
  * General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110,
- * USA
- *
  * The full GNU General Public License is included in this distribution
  * in the file called COPYING.
  *
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-drv.h b/drivers/net/wireless/intel/iwlwifi/iwl-drv.h
index 1f8a2eeb7dff..2be30af7bdc3 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-drv.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-drv.h
@@ -17,11 +17,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
  * General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110,
- * USA
- *
  * The full GNU General Public License is included in this distribution
  * in the file called COPYING.
  *
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-eeprom-parse.c b/drivers/net/wireless/intel/iwlwifi/iwl-eeprom-parse.c
index a4c96215933b..2fee4392be7f 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-eeprom-parse.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-eeprom-parse.c
@@ -18,9 +18,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
  * General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program;
- *
  * The full GNU General Public License is included in this distribution
  * in the file called COPYING.
  *
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-eeprom-parse.h b/drivers/net/wireless/intel/iwlwifi/iwl-eeprom-parse.h
index 8be50ed12300..d910bda087f7 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-eeprom-parse.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-eeprom-parse.h
@@ -17,11 +17,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
  * General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110,
- * USA
- *
  * The full GNU General Public License is included in this distribution
  * in the file called COPYING.
  *
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-eeprom-read.c b/drivers/net/wireless/intel/iwlwifi/iwl-eeprom-read.c
index ac965c34a2f8..a6db6a814257 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-eeprom-read.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-eeprom-read.c
@@ -17,11 +17,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
  * General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110,
- * USA
- *
  * The full GNU General Public License is included in this distribution
  * in the file called COPYING.
  *
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-eeprom-read.h b/drivers/net/wireless/intel/iwlwifi/iwl-eeprom-read.h
index 1ed78be06c23..47fced159800 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-eeprom-read.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-eeprom-read.h
@@ -16,11 +16,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
  * General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110,
- * USA
- *
  * The full GNU General Public License is included in this distribution
  * in the file called COPYING.
  *
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-fh.h b/drivers/net/wireless/intel/iwlwifi/iwl-fh.h
index 4f7254303853..c6a534303936 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-fh.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-fh.h
@@ -18,9 +18,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
  * General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program.
- *
  * The full GNU General Public License is included in this distribution
  * in the file called COPYING.
  *
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-io.c b/drivers/net/wireless/intel/iwlwifi/iwl-io.c
index efb1998dcabd..4f10914f6048 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-io.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-io.c
@@ -14,10 +14,6 @@
  * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
  * more details.
  *
- * You should have received a copy of the GNU General Public License along with
- * this program; if not, write to the Free Software Foundation, Inc.,
- * 51 Franklin Street, Fifth Floor, Boston, MA 02110, USA
- *
  * The full GNU General Public License is included in this distribution in the
  * file called LICENSE.
  *
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-io.h b/drivers/net/wireless/intel/iwlwifi/iwl-io.h
index 5c8c0e130194..38085850a2d3 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-io.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-io.h
@@ -13,10 +13,6 @@
  * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
  * more details.
  *
- * You should have received a copy of the GNU General Public License along with
- * this program; if not, write to the Free Software Foundation, Inc.,
- * 51 Franklin Street, Fifth Floor, Boston, MA 02110, USA
- *
  * The full GNU General Public License is included in this distribution in the
  * file called LICENSE.
  *
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-modparams.h b/drivers/net/wireless/intel/iwlwifi/iwl-modparams.h
index 97072cf75bca..6fc8dac4aab7 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-modparams.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-modparams.h
@@ -17,9 +17,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
  * General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program;
- *
  * The full GNU General Public License is included in this distribution
  * in the file called COPYING.
  *
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c b/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
index b4c3a957c102..137dedc844ad 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
@@ -19,11 +19,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
  * General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110,
- * USA
- *
  * The full GNU General Public License is included in this distribution
  * in the file called COPYING.
  *
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.h b/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.h
index 234d1009a9de..b7e1ddf8f177 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.h
@@ -18,11 +18,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
  * General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110,
- * USA
- *
  * The full GNU General Public License is included in this distribution
  * in the file called COPYING.
  *
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-op-mode.h b/drivers/net/wireless/intel/iwlwifi/iwl-op-mode.h
index cbbdede2e01b..cbd1a8eed620 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-op-mode.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-op-mode.h
@@ -19,9 +19,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
  * General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program.
- *
  * The full GNU General Public License is included in this distribution
  * in the file called COPYING.
  *
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-phy-db.c b/drivers/net/wireless/intel/iwlwifi/iwl-phy-db.c
index b7cd813ba70f..ae83cfdb750e 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-phy-db.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-phy-db.c
@@ -17,11 +17,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
  * General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110,
- * USA
- *
  * The full GNU General Public License is included in this distribution
  * in the file called COPYING.
  *
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-phy-db.h b/drivers/net/wireless/intel/iwlwifi/iwl-phy-db.h
index d34de3f71db6..7020dca05221 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-phy-db.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-phy-db.h
@@ -16,11 +16,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
  * General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110,
- * USA
- *
  * The full GNU General Public License is included in this distribution
  * in the file called COPYING.
  *
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-prph.h b/drivers/net/wireless/intel/iwlwifi/iwl-prph.h
index 421a869633a3..0f51c7bea8d0 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-prph.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-prph.h
@@ -18,11 +18,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
  * General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110,
- * USA
- *
  * The full GNU General Public License is included in this distribution
  * in the file called COPYING.
  *
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-scd.h b/drivers/net/wireless/intel/iwlwifi/iwl-scd.h
index 99b43da32adf..9f11f3912816 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-scd.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-scd.h
@@ -16,11 +16,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
  * General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110,
- * USA
- *
  * The full GNU General Public License is included in this distribution
  * in the file called COPYING.
  *
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-trans.c b/drivers/net/wireless/intel/iwlwifi/iwl-trans.c
index 7e9c924e1220..727f73e0b3f1 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-trans.c
@@ -17,11 +17,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
  * General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110,
- * USA
- *
  * The full GNU General Public License is included in this distribution
  * in the file called COPYING.
  *
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-trans.h b/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
index dbac9ac80ce9..0a6c8759b911 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
@@ -18,11 +18,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
  * General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110,
- * USA
- *
  * The full GNU General Public License is included in this distribution
  * in the file called COPYING.
  *
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/binding.c b/drivers/net/wireless/intel/iwlwifi/mvm/binding.c
index 75d35f6b041e..4094a4158032 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/binding.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/binding.c
@@ -17,11 +17,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
  * General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110,
- * USA
- *
  * The full GNU General Public License is included in this distribution
  * in the file called COPYING.
  *
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/coex.c b/drivers/net/wireless/intel/iwlwifi/mvm/coex.c
index 9707f455086b..ec3b60cdcf18 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/coex.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/coex.c
@@ -17,11 +17,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
  * General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110,
- * USA
- *
  * The full GNU General Public License is included in this distribution
  * in the file called COPYING.
  *
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/constants.h b/drivers/net/wireless/intel/iwlwifi/mvm/constants.h
index d61ff66ce07b..d96ada3c06fc 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/constants.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/constants.h
@@ -18,11 +18,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
  * General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110,
- * USA
- *
  * The full GNU General Public License is included in this distribution
  * in the file called COPYING.
  *
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs-vif.c b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs-vif.c
index 798605c4f122..1aa6c7e93088 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs-vif.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs-vif.c
@@ -18,11 +18,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
  * General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110,
- * USA
- *
  * The full GNU General Public License is included in this distribution
  * in the file called COPYING.
  *
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
index 05b77419953c..202158d03d36 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
@@ -19,11 +19,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
  * General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110,
- * USA
- *
  * The full GNU General Public License is included in this distribution
  * in the file called COPYING.
  *
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.h b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.h
index ede6ef8d390e..a83d252c0602 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.h
@@ -17,11 +17,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
  * General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110,
- * USA
- *
  * The full GNU General Public License is included in this distribution
  * in the file called COPYING.
  *
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h
index e8e74dd558f7..143c7fcaea41 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h
@@ -18,11 +18,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
  * General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110,
- * USA
- *
  * The full GNU General Public License is included in this distribution
  * in the file called COPYING.
  *
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
index 878dc29c2010..96d26b749952 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
@@ -19,11 +19,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
  * General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110,
- * USA
- *
  * The full GNU General Public License is included in this distribution
  * in the file called COPYING.
  *
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/led.c b/drivers/net/wireless/intel/iwlwifi/mvm/led.c
index b27269504a62..9bb1de1cad64 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/led.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/led.c
@@ -17,11 +17,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
  * General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110,
- * USA
- *
  * The full GNU General Public License is included in this distribution
  * in the file called COPYING.
  *
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
index 6a38a3ee4db0..56871aff1698 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
@@ -19,11 +19,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
  * General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110,
- * USA
- *
  * The full GNU General Public License is included in this distribution
  * in the file called COPYING.
  *
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index a0382f9efeb1..134bb9fd21a4 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -19,11 +19,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
  * General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110,
- * USA
- *
  * The full GNU General Public License is included in this distribution
  * in the file called COPYING.
  *
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index c6c09d377b1d..087e8a454ac2 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -19,11 +19,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
  * General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110,
- * USA
- *
  * The full GNU General Public License is included in this distribution
  * in the file called COPYING.
  *
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/nvm.c b/drivers/net/wireless/intel/iwlwifi/mvm/nvm.c
index cf48517944ec..fff98fed35ed 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/nvm.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/nvm.c
@@ -19,11 +19,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
  * General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110,
- * USA
- *
  * The full GNU General Public License is included in this distribution
  * in the file called COPYING.
  *
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/offloading.c b/drivers/net/wireless/intel/iwlwifi/mvm/offloading.c
index 6338d9cf7070..6d71e05626ad 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/offloading.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/offloading.c
@@ -18,11 +18,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
  * General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110,
- * USA
- *
  * The full GNU General Public License is included in this distribution
  * in the file called COPYING.
  *
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
index da1aafb71298..e2463e8e486b 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -19,11 +19,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
  * General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110,
- * USA
- *
  * The full GNU General Public License is included in this distribution
  * in the file called COPYING.
  *
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/power.c b/drivers/net/wireless/intel/iwlwifi/mvm/power.c
index c11fe2621d51..5a0a28fd762d 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/power.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/power.c
@@ -18,11 +18,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
  * General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110,
- * USA
- *
  * The full GNU General Public License is included in this distribution
  * in the file called COPYING.
  *
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/quota.c b/drivers/net/wireless/intel/iwlwifi/mvm/quota.c
index 690559bdf421..5e62b97af48b 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/quota.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/quota.c
@@ -18,11 +18,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
  * General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110,
- * USA
- *
  * The full GNU General Public License is included in this distribution
  * in the file called COPYING.
  *
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rx.c b/drivers/net/wireless/intel/iwlwifi/mvm/rx.c
index bfb163419c67..a050220da678 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rx.c
@@ -18,11 +18,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
  * General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110,
- * USA
- *
  * The full GNU General Public License is included in this distribution
  * in the file called COPYING.
  *
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
index 8a89989f59fd..003bf0848386 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
@@ -19,9 +19,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
  * General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program
- *
  * The full GNU General Public License is included in this distribution
  * in the file called COPYING.
  *
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sf.c b/drivers/net/wireless/intel/iwlwifi/mvm/sf.c
index 539b06bf0803..d1d76bb9a750 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sf.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sf.c
@@ -17,11 +17,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
  * General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110,
- * USA
- *
  * The full GNU General Public License is included in this distribution
  * in the file called COPYING.
  *
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
index 18db1ed92d9b..6ebc715d90df 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
@@ -19,11 +19,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
  * General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110,
- * USA
- *
  * The full GNU General Public License is included in this distribution
  * in the file called COPYING.
  *
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tdls.c b/drivers/net/wireless/intel/iwlwifi/mvm/tdls.c
index 67f360c0d17e..e02f4eb20359 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tdls.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tdls.c
@@ -18,9 +18,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
  * General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program.
- *
  * The full GNU General Public License is included in this distribution
  * in the file called COPYING.
  *
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/testmode.h b/drivers/net/wireless/intel/iwlwifi/mvm/testmode.h
index cbbc16fd006a..ff82af11de8d 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/testmode.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/testmode.h
@@ -17,11 +17,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
  * General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110,
- * USA
- *
  * The full GNU General Public License is included in this distribution
  * in the file called COPYING.
  *
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/time-event.h b/drivers/net/wireless/intel/iwlwifi/mvm/time-event.h
index 3d2e8b6159bb..1dd3d01245ea 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/time-event.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/time-event.h
@@ -17,11 +17,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
  * General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110,
- * USA
- *
  * The full GNU General Public License is included in this distribution
  * in the file called COPYING.
  *
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tof.c b/drivers/net/wireless/intel/iwlwifi/mvm/tof.c
index 2d0b8a391308..01e0a999063b 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tof.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tof.c
@@ -16,11 +16,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
  * General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110,
- * USA
- *
  * The full GNU General Public License is included in this distribution
  * in the file called COPYING.
  *
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tof.h b/drivers/net/wireless/intel/iwlwifi/mvm/tof.h
index 2ff560aa1a82..8138d0606c52 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tof.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tof.h
@@ -16,11 +16,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
  * General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110,
- * USA
- *
  * The full GNU General Public License is included in this distribution
  * in the file called COPYING.
  *
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tt.c b/drivers/net/wireless/intel/iwlwifi/mvm/tt.c
index 1232f63278eb..0b3e5c99d316 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tt.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tt.c
@@ -18,11 +18,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
  * General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110,
- * USA
- *
  * The full GNU General Public License is included in this distribution
  * in the file called COPYING.
  *
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
index b33b8357a8f7..c99b79d686d0 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
@@ -19,11 +19,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
  * General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110,
- * USA
- *
  * The full GNU General Public License is included in this distribution
  * in the file called COPYING.
  *
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/utils.c b/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
index 6a5349401aa9..f5a9e4026094 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
@@ -19,11 +19,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
  * General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110,
- * USA
- *
  * The full GNU General Public License is included in this distribution
  * in the file called COPYING.
  *
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
index 562cc79288a6..6fe92ce4a3aa 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
@@ -19,11 +19,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
  * General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110,
- * USA
- *
  * The full GNU General Public License is included in this distribution
  * in the file called COPYING.
  *
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
index 1089e6b216aa..a7896fcc44cf 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
@@ -17,9 +17,6 @@
  * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
  * more details.
  *
- * You should have received a copy of the GNU General Public License along with
- * this program.
- *
  * The full GNU General Public License is included in this distribution in the
  * file called LICENSE.
  *
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
index 7d9a4e5d4926..d519e7ebdbe8 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
@@ -17,9 +17,6 @@
  * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
  * more details.
  *
- * You should have received a copy of the GNU General Public License along with
- * this program.
- *
  * The full GNU General Public License is included in this distribution in the
  * file called LICENSE.
  *
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index 2a20999d4c15..8925b10217d7 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -19,11 +19,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
  * General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110,
- * USA
- *
  * The full GNU General Public License is included in this distribution
  * in the file called COPYING.
  *
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c b/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
index b89e976ecfcd..5091cd567b63 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
@@ -17,10 +17,6 @@
  * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
  * more details.
  *
- * You should have received a copy of the GNU General Public License along with
- * this program; if not, write to the Free Software Foundation, Inc.,
- * 51 Franklin Street, Fifth Floor, Boston, MA 02110, USA
- *
  * The full GNU General Public License is included in this distribution in the
  * file called LICENSE.
  *
-- 
2.18.0
