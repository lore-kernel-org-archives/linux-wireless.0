Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:33937 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751968AbcJEEIX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 5 Oct 2016 00:08:23 -0400
Received: by mail-oi0-f66.google.com with SMTP id r132so11470389oig.1
        for <linux-wireless@vger.kernel.org>; Tue, 04 Oct 2016 21:08:22 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH 5/8] rtlwifi: rtl8723ae: Remove address of Free Software Foundation
Date: Tue,  4 Oct 2016 23:08:07 -0500
Message-Id: <1475640490-5895-6-git-send-email-Larry.Finger@lwfinger.net> (sfid-20161005_060828_924872_52A5F8DD)
In-Reply-To: <1475640490-5895-1-git-send-email-Larry.Finger@lwfinger.net>
References: <1475640490-5895-1-git-send-email-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since this driver was added to the kernel, the checkpatch script was
modified to request that the address of the FSF not be included.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8723ae/dm.h             | 4 ----
 drivers/net/wireless/realtek/rtlwifi/rtl8723ae/fw.h             | 4 ----
 drivers/net/wireless/realtek/rtlwifi/rtl8723ae/hal_bt_coexist.h | 4 ----
 drivers/net/wireless/realtek/rtlwifi/rtl8723ae/led.c            | 4 ----
 4 files changed, 16 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/dm.h b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/dm.h
index 5711105..a113780 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/dm.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/dm.h
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
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/fw.h b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/fw.h
index 9d1fe25..2e668fc 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/fw.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/fw.h
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
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/hal_bt_coexist.h b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/hal_bt_coexist.h
index bcd64a2..45719fd 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/hal_bt_coexist.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/hal_bt_coexist.h
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
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/led.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/led.c
index c7be934..77c1004 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/led.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/led.c
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
