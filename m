Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:59887 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753212Ab3LFLcY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Dec 2013 06:32:24 -0500
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
	linux-wireless@vger.kernel.org, Daniel Drake <dsd@gentoo.org>,
	Ulrich Kunitz <kune@deine-taler.de>
Subject: [net 1/5] zd1211rw: Fix FSF address in file headers
Date: Fri,  6 Dec 2013 03:32:10 -0800
Message-Id: <1386329534-21739-1-git-send-email-jeffrey.t.kirsher@intel.com> (sfid-20131206_123255_302622_CDFB743E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Several files refer to an old address for the Free Software Foundation
in the file header comment.  Resolve by replacing the address with
the URL <http://www.gnu.org/licenses/> so that we do not have to keep
updating the header comments anytime the address changes.

CC: linux-wireless@vger.kernel.org
CC: Daniel Drake <dsd@gentoo.org>
CC: Ulrich Kunitz <kune@deine-taler.de>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/wireless/zd1211rw/zd_chip.c       | 3 +--
 drivers/net/wireless/zd1211rw/zd_chip.h       | 3 +--
 drivers/net/wireless/zd1211rw/zd_def.h        | 3 +--
 drivers/net/wireless/zd1211rw/zd_mac.c        | 3 +--
 drivers/net/wireless/zd1211rw/zd_mac.h        | 3 +--
 drivers/net/wireless/zd1211rw/zd_rf.c         | 3 +--
 drivers/net/wireless/zd1211rw/zd_rf.h         | 3 +--
 drivers/net/wireless/zd1211rw/zd_rf_al2230.c  | 3 +--
 drivers/net/wireless/zd1211rw/zd_rf_al7230b.c | 3 +--
 drivers/net/wireless/zd1211rw/zd_rf_rf2959.c  | 3 +--
 drivers/net/wireless/zd1211rw/zd_rf_uw2453.c  | 3 +--
 drivers/net/wireless/zd1211rw/zd_usb.c        | 3 +--
 drivers/net/wireless/zd1211rw/zd_usb.h        | 3 +--
 13 files changed, 13 insertions(+), 26 deletions(-)

diff --git a/drivers/net/wireless/zd1211rw/zd_chip.c b/drivers/net/wireless/zd1211rw/zd_chip.c
index 71ab320..73a49b8 100644
--- a/drivers/net/wireless/zd1211rw/zd_chip.c
+++ b/drivers/net/wireless/zd1211rw/zd_chip.c
@@ -14,8 +14,7 @@
  * GNU General Public License for more details.
  *
  * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+ * along with this program; if not, see <http://www.gnu.org/licenses/>.
  */
 
 /* This file implements all the hardware specific functions for the ZD1211
diff --git a/drivers/net/wireless/zd1211rw/zd_chip.h b/drivers/net/wireless/zd1211rw/zd_chip.h
index 7ab9222..b03786c 100644
--- a/drivers/net/wireless/zd1211rw/zd_chip.h
+++ b/drivers/net/wireless/zd1211rw/zd_chip.h
@@ -14,8 +14,7 @@
  * GNU General Public License for more details.
  *
  * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+ * along with this program; if not, see <http://www.gnu.org/licenses/>.
  */
 
 #ifndef _ZD_CHIP_H
diff --git a/drivers/net/wireless/zd1211rw/zd_def.h b/drivers/net/wireless/zd1211rw/zd_def.h
index 9a1b013..41bd755 100644
--- a/drivers/net/wireless/zd1211rw/zd_def.h
+++ b/drivers/net/wireless/zd1211rw/zd_def.h
@@ -14,8 +14,7 @@
  * GNU General Public License for more details.
  *
  * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+ * along with this program; if not, see <http://www.gnu.org/licenses/>.
  */
 
 #ifndef _ZD_DEF_H
diff --git a/drivers/net/wireless/zd1211rw/zd_mac.c b/drivers/net/wireless/zd1211rw/zd_mac.c
index c6208a7..eff79a3 100644
--- a/drivers/net/wireless/zd1211rw/zd_mac.c
+++ b/drivers/net/wireless/zd1211rw/zd_mac.c
@@ -16,8 +16,7 @@
  * GNU General Public License for more details.
  *
  * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+ * along with this program; if not, see <http://www.gnu.org/licenses/>.
  */
 
 #include <linux/netdevice.h>
diff --git a/drivers/net/wireless/zd1211rw/zd_mac.h b/drivers/net/wireless/zd1211rw/zd_mac.h
index c01eca8..5a48423 100644
--- a/drivers/net/wireless/zd1211rw/zd_mac.h
+++ b/drivers/net/wireless/zd1211rw/zd_mac.h
@@ -14,8 +14,7 @@
  * GNU General Public License for more details.
  *
  * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+ * along with this program; if not, see <http://www.gnu.org/licenses/>.
  */
 
 #ifndef _ZD_MAC_H
diff --git a/drivers/net/wireless/zd1211rw/zd_rf.c b/drivers/net/wireless/zd1211rw/zd_rf.c
index c875ee0..dc179c4 100644
--- a/drivers/net/wireless/zd1211rw/zd_rf.c
+++ b/drivers/net/wireless/zd1211rw/zd_rf.c
@@ -14,8 +14,7 @@
  * GNU General Public License for more details.
  *
  * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+ * along with this program; if not, see <http://www.gnu.org/licenses/>.
  */
 
 #include <linux/errno.h>
diff --git a/drivers/net/wireless/zd1211rw/zd_rf.h b/drivers/net/wireless/zd1211rw/zd_rf.h
index 725b7c9..8f14e25 100644
--- a/drivers/net/wireless/zd1211rw/zd_rf.h
+++ b/drivers/net/wireless/zd1211rw/zd_rf.h
@@ -14,8 +14,7 @@
  * GNU General Public License for more details.
  *
  * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+ * along with this program; if not, see <http://www.gnu.org/licenses/>.
  */
 
 #ifndef _ZD_RF_H
diff --git a/drivers/net/wireless/zd1211rw/zd_rf_al2230.c b/drivers/net/wireless/zd1211rw/zd_rf_al2230.c
index 12babcb..99aed7d 100644
--- a/drivers/net/wireless/zd1211rw/zd_rf_al2230.c
+++ b/drivers/net/wireless/zd1211rw/zd_rf_al2230.c
@@ -14,8 +14,7 @@
  * GNU General Public License for more details.
  *
  * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+ * along with this program; if not, see <http://www.gnu.org/licenses/>.
  */
 
 #include <linux/kernel.h>
diff --git a/drivers/net/wireless/zd1211rw/zd_rf_al7230b.c b/drivers/net/wireless/zd1211rw/zd_rf_al7230b.c
index 385c670..5fea485 100644
--- a/drivers/net/wireless/zd1211rw/zd_rf_al7230b.c
+++ b/drivers/net/wireless/zd1211rw/zd_rf_al7230b.c
@@ -14,8 +14,7 @@
  * GNU General Public License for more details.
  *
  * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+ * along with this program; if not, see <http://www.gnu.org/licenses/>.
  */
 
 #include <linux/kernel.h>
diff --git a/drivers/net/wireless/zd1211rw/zd_rf_rf2959.c b/drivers/net/wireless/zd1211rw/zd_rf_rf2959.c
index 784d9cc..a93f657 100644
--- a/drivers/net/wireless/zd1211rw/zd_rf_rf2959.c
+++ b/drivers/net/wireless/zd1211rw/zd_rf_rf2959.c
@@ -14,8 +14,7 @@
  * GNU General Public License for more details.
  *
  * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+ * along with this program; if not, see <http://www.gnu.org/licenses/>.
  */
 
 #include <linux/kernel.h>
diff --git a/drivers/net/wireless/zd1211rw/zd_rf_uw2453.c b/drivers/net/wireless/zd1211rw/zd_rf_uw2453.c
index c4d324e..61b9240 100644
--- a/drivers/net/wireless/zd1211rw/zd_rf_uw2453.c
+++ b/drivers/net/wireless/zd1211rw/zd_rf_uw2453.c
@@ -14,8 +14,7 @@
  * GNU General Public License for more details.
  *
  * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+ * along with this program; if not, see <http://www.gnu.org/licenses/>.
  */
 
 #include <linux/kernel.h>
diff --git a/drivers/net/wireless/zd1211rw/zd_usb.c b/drivers/net/wireless/zd1211rw/zd_usb.c
index 84d94f5..a912dc0 100644
--- a/drivers/net/wireless/zd1211rw/zd_usb.c
+++ b/drivers/net/wireless/zd1211rw/zd_usb.c
@@ -15,8 +15,7 @@
  * GNU General Public License for more details.
  *
  * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+ * along with this program; if not, see <http://www.gnu.org/licenses/>.
  */
 
 #include <linux/kernel.h>
diff --git a/drivers/net/wireless/zd1211rw/zd_usb.h b/drivers/net/wireless/zd1211rw/zd_usb.h
index 45e3bb2..a9075f2 100644
--- a/drivers/net/wireless/zd1211rw/zd_usb.h
+++ b/drivers/net/wireless/zd1211rw/zd_usb.h
@@ -14,8 +14,7 @@
  * GNU General Public License for more details.
  *
  * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+ * along with this program; if not, see <http://www.gnu.org/licenses/>.
  */
 
 #ifndef _ZD_USB_H
-- 
1.8.3.1

