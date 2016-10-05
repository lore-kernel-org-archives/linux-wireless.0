Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:35802 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751320AbcJEEIU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 5 Oct 2016 00:08:20 -0400
Received: by mail-oi0-f68.google.com with SMTP id d132so1599455oib.2
        for <linux-wireless@vger.kernel.org>; Tue, 04 Oct 2016 21:08:19 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH 1/8] rtlwifi: rtl8192de: Remove address of Free Software Foundation
Date: Tue,  4 Oct 2016 23:08:03 -0500
Message-Id: <1475640490-5895-2-git-send-email-Larry.Finger@lwfinger.net> (sfid-20161005_060836_271433_F820F18D)
In-Reply-To: <1475640490-5895-1-git-send-email-Larry.Finger@lwfinger.net>
References: <1475640490-5895-1-git-send-email-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since this driver was added to the kernel, the checkpatch script was
modified to request that the address of the FSF not be included.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8192de/def.h   | 4 ----
 drivers/net/wireless/realtek/rtlwifi/rtl8192de/dm.c    | 4 ----
 drivers/net/wireless/realtek/rtlwifi/rtl8192de/dm.h    | 4 ----
 drivers/net/wireless/realtek/rtlwifi/rtl8192de/fw.c    | 4 ----
 drivers/net/wireless/realtek/rtlwifi/rtl8192de/fw.h    | 4 ----
 drivers/net/wireless/realtek/rtlwifi/rtl8192de/hw.c    | 4 ----
 drivers/net/wireless/realtek/rtlwifi/rtl8192de/hw.h    | 4 ----
 drivers/net/wireless/realtek/rtlwifi/rtl8192de/led.c   | 4 ----
 drivers/net/wireless/realtek/rtlwifi/rtl8192de/led.h   | 4 ----
 drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c   | 4 ----
 drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.h   | 4 ----
 drivers/net/wireless/realtek/rtlwifi/rtl8192de/reg.h   | 4 ----
 drivers/net/wireless/realtek/rtlwifi/rtl8192de/rf.c    | 4 ----
 drivers/net/wireless/realtek/rtlwifi/rtl8192de/rf.h    | 4 ----
 drivers/net/wireless/realtek/rtlwifi/rtl8192de/sw.c    | 4 ----
 drivers/net/wireless/realtek/rtlwifi/rtl8192de/sw.h    | 4 ----
 drivers/net/wireless/realtek/rtlwifi/rtl8192de/table.c | 4 ----
 drivers/net/wireless/realtek/rtlwifi/rtl8192de/table.h | 4 ----
 drivers/net/wireless/realtek/rtlwifi/rtl8192de/trx.c   | 4 ----
 drivers/net/wireless/realtek/rtlwifi/rtl8192de/trx.h   | 4 ----
 20 files changed, 80 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/def.h b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/def.h
index 0a443ed..cb7b9b7 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/def.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/def.h
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
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/dm.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/dm.c
index 7c1db7e..ac6d554 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/dm.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/dm.c
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
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/dm.h b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/dm.h
index f2d318c..5d346ec 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/dm.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/dm.h
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
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/fw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/fw.c
index 09e0057..83a87eb 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/fw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/fw.c
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
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/fw.h b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/fw.h
index 8a38daa..6b43523 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/fw.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/fw.h
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
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/hw.c
index d91f8bb..fcb14c5 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/hw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/hw.c
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
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/hw.h b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/hw.h
index 1bc7b1a..24b03b9 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/hw.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/hw.h
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
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/led.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/led.c
index 811ba57..c22b8a2 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/led.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/led.c
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
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/led.h b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/led.h
index a29df30..9874519 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/led.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/led.h
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
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c
index 2a1edfd..424f54b 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c
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
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.h b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.h
index 8115bf4..58b56b5 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.h
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
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/reg.h b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/reg.h
index 315a298..b354b95 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/reg.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/reg.h
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
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/rf.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/rf.c
index 2f479d3..9dc9e91 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/rf.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/rf.c
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
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/rf.h b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/rf.h
index 7303d12..c650a8d 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/rf.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/rf.h
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
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/sw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/sw.c
index 0538a4d..a9c39eb 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/sw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/sw.c
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
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/sw.h b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/sw.h
index 0e6035b..fd7d036 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/sw.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/sw.h
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
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/table.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/table.c
index 8ea6f52..4badb18 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/table.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/table.c
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
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/table.h b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/table.h
index 8b724a8..7fefc48 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/table.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/table.h
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
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/trx.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/trx.c
index e998e98..5fb3756 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/trx.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/trx.c
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
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/trx.h b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/trx.h
index 194d99f..9bb6cc6 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/trx.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/trx.h
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
