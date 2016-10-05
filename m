Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:33932 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750860AbcJEEIV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 5 Oct 2016 00:08:21 -0400
Received: by mail-oi0-f66.google.com with SMTP id r132so11470326oig.1
        for <linux-wireless@vger.kernel.org>; Tue, 04 Oct 2016 21:08:20 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH 2/8] rtlwifi: rtl8192se: Remove address of Free Software Foundation
Date: Tue,  4 Oct 2016 23:08:04 -0500
Message-Id: <1475640490-5895-3-git-send-email-Larry.Finger@lwfinger.net> (sfid-20161005_060825_353510_B173782A)
In-Reply-To: <1475640490-5895-1-git-send-email-Larry.Finger@lwfinger.net>
References: <1475640490-5895-1-git-send-email-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since this driver was added to the kernel, the checkpatch script was
modified to request that the address of the FSF not be included.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8192se/def.h   | 4 ----
 drivers/net/wireless/realtek/rtlwifi/rtl8192se/dm.c    | 4 ----
 drivers/net/wireless/realtek/rtlwifi/rtl8192se/dm.h    | 4 ----
 drivers/net/wireless/realtek/rtlwifi/rtl8192se/fw.c    | 4 ----
 drivers/net/wireless/realtek/rtlwifi/rtl8192se/fw.h    | 4 ----
 drivers/net/wireless/realtek/rtlwifi/rtl8192se/hw.c    | 4 ----
 drivers/net/wireless/realtek/rtlwifi/rtl8192se/hw.h    | 4 ----
 drivers/net/wireless/realtek/rtlwifi/rtl8192se/led.c   | 4 ----
 drivers/net/wireless/realtek/rtlwifi/rtl8192se/led.h   | 4 ----
 drivers/net/wireless/realtek/rtlwifi/rtl8192se/phy.c   | 4 ----
 drivers/net/wireless/realtek/rtlwifi/rtl8192se/phy.h   | 4 ----
 drivers/net/wireless/realtek/rtlwifi/rtl8192se/reg.h   | 4 ----
 drivers/net/wireless/realtek/rtlwifi/rtl8192se/rf.c    | 4 ----
 drivers/net/wireless/realtek/rtlwifi/rtl8192se/rf.h    | 4 ----
 drivers/net/wireless/realtek/rtlwifi/rtl8192se/sw.c    | 4 ----
 drivers/net/wireless/realtek/rtlwifi/rtl8192se/sw.h    | 4 ----
 drivers/net/wireless/realtek/rtlwifi/rtl8192se/table.c | 4 ----
 drivers/net/wireless/realtek/rtlwifi/rtl8192se/table.h | 4 ----
 drivers/net/wireless/realtek/rtlwifi/rtl8192se/trx.c   | 4 ----
 drivers/net/wireless/realtek/rtlwifi/rtl8192se/trx.h   | 4 ----
 20 files changed, 80 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192se/def.h b/drivers/net/wireless/realtek/rtlwifi/rtl8192se/def.h
index 41466f9..b5ba055 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192se/def.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192se/def.h
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
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192se/dm.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192se/dm.c
index 9bae5a9..2c073a7 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192se/dm.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192se/dm.c
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
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192se/dm.h b/drivers/net/wireless/realtek/rtlwifi/rtl8192se/dm.h
index de6ac79..3af07ef 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192se/dm.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192se/dm.h
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
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192se/fw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192se/fw.c
index 331b158..32f9207 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192se/fw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192se/fw.c
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
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192se/fw.h b/drivers/net/wireless/realtek/rtlwifi/rtl8192se/fw.h
index b1e44b8..5827aa3 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192se/fw.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192se/fw.h
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
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192se/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192se/hw.c
index 52e4430..26e06b2 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192se/hw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192se/hw.c
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
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192se/hw.h b/drivers/net/wireless/realtek/rtlwifi/rtl8192se/hw.h
index 4cacee1..86bce1b 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192se/hw.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192se/hw.h
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
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192se/led.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192se/led.c
index 9849cb9..8700078 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192se/led.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192se/led.c
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
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192se/led.h b/drivers/net/wireless/realtek/rtlwifi/rtl8192se/led.h
index 2182dbe..90e265d 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192se/led.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192se/led.h
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
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192se/phy.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192se/phy.c
index 4bb7558..fcb9216 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192se/phy.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192se/phy.c
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
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192se/phy.h b/drivers/net/wireless/realtek/rtlwifi/rtl8192se/phy.h
index 8acf476..7a3b6b6 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192se/phy.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192se/phy.h
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
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192se/reg.h b/drivers/net/wireless/realtek/rtlwifi/rtl8192se/reg.h
index e130434..5d445c2 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192se/reg.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192se/reg.h
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
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192se/rf.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192se/rf.c
index 34e88a3..bd2fa77 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192se/rf.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192se/rf.c
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
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192se/rf.h b/drivers/net/wireless/realtek/rtlwifi/rtl8192se/rf.h
index 8a29eb9..e9ba283 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192se/rf.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192se/rf.h
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
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192se/sw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192se/sw.c
index 5e8e02d..a652d45 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192se/sw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192se/sw.c
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
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192se/sw.h b/drivers/net/wireless/realtek/rtlwifi/rtl8192se/sw.h
index 2eb8886..af449d6 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192se/sw.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192se/sw.h
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
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192se/table.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192se/table.c
index f1a73f7..162578f 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192se/table.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192se/table.c
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
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192se/table.h b/drivers/net/wireless/realtek/rtlwifi/rtl8192se/table.h
index 2feb73b..aa3c768 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192se/table.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192se/table.h
@@ -6,10 +6,6 @@
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
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192se/trx.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192se/trx.c
index d53bbf6..9a5a113 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192se/trx.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192se/trx.c
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
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192se/trx.h b/drivers/net/wireless/realtek/rtlwifi/rtl8192se/trx.h
index 5a13f17..7285891 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192se/trx.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192se/trx.h
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
-- 
2.6.6
