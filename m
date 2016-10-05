Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:33552 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751320AbcJEEIW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 5 Oct 2016 00:08:22 -0400
Received: by mail-oi0-f65.google.com with SMTP id o93so3194739oik.0
        for <linux-wireless@vger.kernel.org>; Tue, 04 Oct 2016 21:08:22 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH 4/8] rtlwifi: rtl8192cu: Remove address of Free Software Foundation
Date: Tue,  4 Oct 2016 23:08:06 -0500
Message-Id: <1475640490-5895-5-git-send-email-Larry.Finger@lwfinger.net> (sfid-20161005_060827_216306_EAB52B68)
In-Reply-To: <1475640490-5895-1-git-send-email-Larry.Finger@lwfinger.net>
References: <1475640490-5895-1-git-send-email-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since this driver was added to the kernel, the checkpatch script was
modified to request that the address of the FSF not be included.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8192cu/def.h   | 4 ----
 drivers/net/wireless/realtek/rtlwifi/rtl8192cu/dm.c    | 4 ----
 drivers/net/wireless/realtek/rtlwifi/rtl8192cu/dm.h    | 4 ----
 drivers/net/wireless/realtek/rtlwifi/rtl8192cu/hw.c    | 4 ----
 drivers/net/wireless/realtek/rtlwifi/rtl8192cu/hw.h    | 4 ----
 drivers/net/wireless/realtek/rtlwifi/rtl8192cu/led.c   | 4 ----
 drivers/net/wireless/realtek/rtlwifi/rtl8192cu/led.h   | 4 ----
 drivers/net/wireless/realtek/rtlwifi/rtl8192cu/mac.c   | 4 ----
 drivers/net/wireless/realtek/rtlwifi/rtl8192cu/mac.h   | 4 ----
 drivers/net/wireless/realtek/rtlwifi/rtl8192cu/phy.c   | 4 ----
 drivers/net/wireless/realtek/rtlwifi/rtl8192cu/phy.h   | 4 ----
 drivers/net/wireless/realtek/rtlwifi/rtl8192cu/reg.h   | 4 ----
 drivers/net/wireless/realtek/rtlwifi/rtl8192cu/rf.c    | 4 ----
 drivers/net/wireless/realtek/rtlwifi/rtl8192cu/rf.h    | 4 ----
 drivers/net/wireless/realtek/rtlwifi/rtl8192cu/sw.c    | 4 ----
 drivers/net/wireless/realtek/rtlwifi/rtl8192cu/sw.h    | 4 ----
 drivers/net/wireless/realtek/rtlwifi/rtl8192cu/table.c | 4 ----
 drivers/net/wireless/realtek/rtlwifi/rtl8192cu/table.h | 4 ----
 drivers/net/wireless/realtek/rtlwifi/rtl8192cu/trx.c   | 4 ----
 drivers/net/wireless/realtek/rtlwifi/rtl8192cu/trx.h   | 4 ----
 20 files changed, 80 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/def.h b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/def.h
index 74a479a..316fe99 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/def.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/def.h
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
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/dm.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/dm.c
index c16209a..00fc068 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/dm.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/dm.c
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
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/dm.h b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/dm.h
index fafa6ba..ce71433 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/dm.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/dm.h
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
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/hw.c
index ae8f055..5c7da0c 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/hw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/hw.c
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
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/hw.h b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/hw.h
index 6758808..932f056 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/hw.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/hw.h
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
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/led.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/led.c
index 8514ab65..c624081 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/led.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/led.c
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
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/led.h b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/led.h
index 0f37227..551deb8 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/led.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/led.h
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
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/mac.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/mac.c
index 68ca734..cf212f6 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/mac.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/mac.c
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
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/mac.h b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/mac.h
index 20a49ec..8573b7e 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/mac.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/mac.h
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
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/phy.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/phy.c
index 4b29764..f35f435 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/phy.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/phy.c
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
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/phy.h b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/phy.h
index 42b0686..a422c4d 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/phy.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/phy.h
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
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/reg.h b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/reg.h
index 8b81465..8185886 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/reg.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/reg.h
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
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/rf.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/rf.c
index ec2ea56..5e31830 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/rf.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/rf.c
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
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/rf.h b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/rf.h
index 6f987de..07aec0b 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/rf.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/rf.h
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
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/sw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/sw.c
index 7c6f7f0..92588e0 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/sw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/sw.c
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
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/sw.h b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/sw.h
index a1310ab..4ea2cb2 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/sw.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/sw.h
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
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/table.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/table.c
index 7903c15..b3ac981 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/table.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/table.c
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
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/table.h b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/table.h
index 4b020e9..851bf53 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/table.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/table.h
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
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/trx.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/trx.c
index 95880fe..1ea878f 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/trx.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/trx.c
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
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/trx.h b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/trx.h
index fd8051d..df88e39 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/trx.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/trx.h
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
