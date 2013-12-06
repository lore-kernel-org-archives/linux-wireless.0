Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:59887 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757525Ab3LFLc0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Dec 2013 06:32:26 -0500
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
	linux-wireless@vger.kernel.org,
	Simon Kelley <simon@thekelleys.org.uk>,
	Christian Lamparter <chunkeey@googlemail.com>,
	Jussi Kivilinna <jussi.kivilinna@iki.fi>
Subject: [net 4/5] drivers/net/wireless: Fix FSF address in file headers
Date: Fri,  6 Dec 2013 03:32:13 -0800
Message-Id: <1386329534-21739-4-git-send-email-jeffrey.t.kirsher@intel.com> (sfid-20131206_123256_333790_EDB573CF)
In-Reply-To: <1386329534-21739-1-git-send-email-jeffrey.t.kirsher@intel.com>
References: <1386329534-21739-1-git-send-email-jeffrey.t.kirsher@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Several files refer to an old address for the Free Software Foundation
in the file header comment.  Resolve by replacing the address with
the URL <http://www.gnu.org/licenses/> so that we do not have to keep
updating the header comments anytime the address changes.

CC: linux-wireless@vger.kernel.org
CC: Simon Kelley <simon@thekelleys.org.uk>
CC: Christian Lamparter <chunkeey@googlemail.com>
CC: Jussi Kivilinna <jussi.kivilinna@iki.fi>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/wireless/atmel.c         | 7 +++----
 drivers/net/wireless/atmel.h         | 4 ++--
 drivers/net/wireless/atmel_cs.c      | 4 ++--
 drivers/net/wireless/atmel_pci.c     | 4 ++--
 drivers/net/wireless/libertas/README | 5 ++---
 drivers/net/wireless/p54/net2280.h   | 3 +--
 drivers/net/wireless/ray_cs.c        | 3 +--
 drivers/net/wireless/rndis_wlan.c    | 3 +--
 8 files changed, 14 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/atmel.c b/drivers/net/wireless/atmel.c
index 0d950f2..b73b7e3 100644
--- a/drivers/net/wireless/atmel.c
+++ b/drivers/net/wireless/atmel.c
@@ -28,8 +28,8 @@
     GNU General Public License for more details.
 
     You should have received a copy of the GNU General Public License
-    along with Atmel wireless lan drivers; if not, write to the Free Software
-    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+    along with Atmel wireless lan drivers; if not, see
+    <http://www.gnu.org/licenses/>.
 
     For all queries about this code, please contact the current author,
     Simon Kelley <simon@thekelleys.org.uk> and not Atmel Corporation.
@@ -4278,8 +4278,7 @@ static void atmel_wmem32(struct atmel_private *priv, u16 pos, u32 data)
     GNU General Public License for more details.
 
     You should have received a copy of the GNU General Public License
-    along with AtmelMACFW; if not, write to the Free Software
-    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+    along with AtmelMACFW; if not, see <http://www.gnu.org/licenses/>.
 
 ****************************************************************************/
 /* This firmware should work on the 76C502 RFMD, RFMD_D, and RFMD_E        */
diff --git a/drivers/net/wireless/atmel.h b/drivers/net/wireless/atmel.h
index b9b3e5b..96f7318 100644
--- a/drivers/net/wireless/atmel.h
+++ b/drivers/net/wireless/atmel.h
@@ -15,8 +15,8 @@
     GNU General Public License for more details.
 
     You should have received a copy of the GNU General Public License
-    along with Atmel wireless lan drivers; if not, write to the Free Software
-    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+    along with Atmel wireless lan drivers; if not, see
+    <http://www.gnu.org/licenses/>.
 
 ******************************************************************************/
 
diff --git a/drivers/net/wireless/atmel_cs.c b/drivers/net/wireless/atmel_cs.c
index 5225722..5e2749d 100644
--- a/drivers/net/wireless/atmel_cs.c
+++ b/drivers/net/wireless/atmel_cs.c
@@ -24,8 +24,8 @@
     GNU General Public License for more details.
 
     You should have received a copy of the GNU General Public License
-    along with Atmel wireless lan drivers; if not, write to the Free Software
-    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+    along with Atmel wireless lan drivers; if not, see
+    <http://www.gnu.org/licenses/>.
 
 ******************************************************************************/
 
diff --git a/drivers/net/wireless/atmel_pci.c b/drivers/net/wireless/atmel_pci.c
index c1b159e..64d5973 100644
--- a/drivers/net/wireless/atmel_pci.c
+++ b/drivers/net/wireless/atmel_pci.c
@@ -15,8 +15,8 @@
     GNU General Public License for more details.
 
     You should have received a copy of the GNU General Public License
-    along with Atmel wireless lan drivers; if not, write to the Free Software
-    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+    along with Atmel wireless lan drivers; if not, see
+    <http://www.gnu.org/licenses/>.
 
 ******************************************************************************/
 #include <linux/pci.h>
diff --git a/drivers/net/wireless/libertas/README b/drivers/net/wireless/libertas/README
index 91f2ca9..1a554a6 100644
--- a/drivers/net/wireless/libertas/README
+++ b/drivers/net/wireless/libertas/README
@@ -8,9 +8,8 @@
  Ltd. under the terms of the GNU General Public License Version 2, June 1991
  (the "License").  You may use, redistribute and/or modify this File in
  accordance with the terms and conditions of the License, a copy of which
- is available along with the File in the license.txt file or by writing to
- the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
- 02111-1307 or on the worldwide web at http://www.gnu.org/licenses/gpl.txt.
+ is available along with the File in the license.txt file or on the worldwide
+ web at http://www.gnu.org/licenses/gpl.txt.
 
  THE FILE IS DISTRIBUTED AS-IS, WITHOUT WARRANTY OF ANY KIND, AND THE
  IMPLIED WARRANTIES OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE
diff --git a/drivers/net/wireless/p54/net2280.h b/drivers/net/wireless/p54/net2280.h
index e3ed893..aedfaf2 100644
--- a/drivers/net/wireless/p54/net2280.h
+++ b/drivers/net/wireless/p54/net2280.h
@@ -20,8 +20,7 @@
  * GNU General Public License for more details.
  *
  * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ * along with this program; if not, see <http://www.gnu.org/licenses/>.
  */
 
 /*-------------------------------------------------------------------------*/
diff --git a/drivers/net/wireless/ray_cs.c b/drivers/net/wireless/ray_cs.c
index 9b557a1..cbf0a58 100644
--- a/drivers/net/wireless/ray_cs.c
+++ b/drivers/net/wireless/ray_cs.c
@@ -17,8 +17,7 @@
  * GNU General Public License for more details.
  *
  * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA
+ * along with this program; if not, see <http://www.gnu.org/licenses/>.
  *
  * Changes:
  * Arnaldo Carvalho de Melo <acme@conectiva.com.br> - 08/08/2000
diff --git a/drivers/net/wireless/rndis_wlan.c b/drivers/net/wireless/rndis_wlan.c
index 8169a85..c3cdda1 100644
--- a/drivers/net/wireless/rndis_wlan.c
+++ b/drivers/net/wireless/rndis_wlan.c
@@ -15,8 +15,7 @@
  * GNU General Public License for more details.
  *
  * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ * along with this program; if not, see <http://www.gnu.org/licenses/>.
  *
  *  Portions of this file are based on NDISwrapper project,
  *  Copyright (C) 2003-2005 Pontus Fuchs, Giridhar Pemmasani
-- 
1.8.3.1

