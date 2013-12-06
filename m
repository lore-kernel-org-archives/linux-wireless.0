Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:59887 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757198Ab3LFLcZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Dec 2013 06:32:25 -0500
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
	linux-wireless@vger.kernel.org, Ivo van Doorn <IvDoorn@gmail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>
Subject: [net 2/5] rt2x00: Fix FSF address in file headers
Date: Fri,  6 Dec 2013 03:32:11 -0800
Message-Id: <1386329534-21739-2-git-send-email-jeffrey.t.kirsher@intel.com> (sfid-20131206_123348_122367_AFA1EA34)
In-Reply-To: <1386329534-21739-1-git-send-email-jeffrey.t.kirsher@intel.com>
References: <1386329534-21739-1-git-send-email-jeffrey.t.kirsher@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Several files refer to an old address for the Free Software Foundation
in the file header comment.  Resolve by replacing the address with
the URL <http://www.gnu.org/licenses/> so that we do not have to keep
updating the header comments anytime the address changes.

CC: linux-wireless@vger.kernel.org
CC: Ivo van Doorn <IvDoorn@gmail.com>
CC: Gertjan van Wingerde <gwingerde@gmail.com>
CC: Helmut Schaa <helmut.schaa@googlemail.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/wireless/rt2x00/rt2400pci.c      | 4 +---
 drivers/net/wireless/rt2x00/rt2400pci.h      | 4 +---
 drivers/net/wireless/rt2x00/rt2500pci.c      | 4 +---
 drivers/net/wireless/rt2x00/rt2500pci.h      | 4 +---
 drivers/net/wireless/rt2x00/rt2500usb.c      | 4 +---
 drivers/net/wireless/rt2x00/rt2500usb.h      | 4 +---
 drivers/net/wireless/rt2x00/rt2800.h         | 4 +---
 drivers/net/wireless/rt2x00/rt2800lib.c      | 4 +---
 drivers/net/wireless/rt2x00/rt2800lib.h      | 4 +---
 drivers/net/wireless/rt2x00/rt2800mmio.c     | 4 +---
 drivers/net/wireless/rt2x00/rt2800mmio.h     | 4 +---
 drivers/net/wireless/rt2x00/rt2800pci.c      | 4 +---
 drivers/net/wireless/rt2x00/rt2800pci.h      | 4 +---
 drivers/net/wireless/rt2x00/rt2800soc.c      | 4 +---
 drivers/net/wireless/rt2x00/rt2800usb.c      | 4 +---
 drivers/net/wireless/rt2x00/rt2800usb.h      | 4 +---
 drivers/net/wireless/rt2x00/rt2x00.h         | 4 +---
 drivers/net/wireless/rt2x00/rt2x00config.c   | 4 +---
 drivers/net/wireless/rt2x00/rt2x00crypto.c   | 4 +---
 drivers/net/wireless/rt2x00/rt2x00debug.c    | 4 +---
 drivers/net/wireless/rt2x00/rt2x00debug.h    | 4 +---
 drivers/net/wireless/rt2x00/rt2x00dev.c      | 4 +---
 drivers/net/wireless/rt2x00/rt2x00dump.h     | 4 +---
 drivers/net/wireless/rt2x00/rt2x00firmware.c | 4 +---
 drivers/net/wireless/rt2x00/rt2x00leds.c     | 4 +---
 drivers/net/wireless/rt2x00/rt2x00leds.h     | 4 +---
 drivers/net/wireless/rt2x00/rt2x00lib.h      | 4 +---
 drivers/net/wireless/rt2x00/rt2x00link.c     | 4 +---
 drivers/net/wireless/rt2x00/rt2x00mac.c      | 4 +---
 drivers/net/wireless/rt2x00/rt2x00mmio.c     | 4 +---
 drivers/net/wireless/rt2x00/rt2x00mmio.h     | 4 +---
 drivers/net/wireless/rt2x00/rt2x00pci.c      | 4 +---
 drivers/net/wireless/rt2x00/rt2x00pci.h      | 4 +---
 drivers/net/wireless/rt2x00/rt2x00queue.c    | 4 +---
 drivers/net/wireless/rt2x00/rt2x00queue.h    | 4 +---
 drivers/net/wireless/rt2x00/rt2x00reg.h      | 4 +---
 drivers/net/wireless/rt2x00/rt2x00soc.c      | 4 +---
 drivers/net/wireless/rt2x00/rt2x00soc.h      | 4 +---
 drivers/net/wireless/rt2x00/rt2x00usb.c      | 4 +---
 drivers/net/wireless/rt2x00/rt2x00usb.h      | 4 +---
 drivers/net/wireless/rt2x00/rt61pci.c        | 4 +---
 drivers/net/wireless/rt2x00/rt61pci.h        | 4 +---
 drivers/net/wireless/rt2x00/rt73usb.c        | 4 +---
 drivers/net/wireless/rt2x00/rt73usb.h        | 4 +---
 44 files changed, 44 insertions(+), 132 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2400pci.c b/drivers/net/wireless/rt2x00/rt2400pci.c
index 38ed9a3..4ad0de9 100644
--- a/drivers/net/wireless/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/rt2x00/rt2400pci.c
@@ -13,9 +13,7 @@
 	GNU General Public License for more details.
 
 	You should have received a copy of the GNU General Public License
-	along with this program; if not, write to the
-	Free Software Foundation, Inc.,
-	59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+	along with this program; if not, see <http://www.gnu.org/licenses/>.
  */
 
 /*
diff --git a/drivers/net/wireless/rt2x00/rt2400pci.h b/drivers/net/wireless/rt2x00/rt2400pci.h
index e4b07f0..0fd3a9d 100644
--- a/drivers/net/wireless/rt2x00/rt2400pci.h
+++ b/drivers/net/wireless/rt2x00/rt2400pci.h
@@ -13,9 +13,7 @@
 	GNU General Public License for more details.
 
 	You should have received a copy of the GNU General Public License
-	along with this program; if not, write to the
-	Free Software Foundation, Inc.,
-	59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+	along with this program; if not, see <http://www.gnu.org/licenses/>.
  */
 
 /*
diff --git a/drivers/net/wireless/rt2x00/rt2500pci.c b/drivers/net/wireless/rt2x00/rt2500pci.c
index 0ac5c58..4f61ffb 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/rt2x00/rt2500pci.c
@@ -13,9 +13,7 @@
 	GNU General Public License for more details.
 
 	You should have received a copy of the GNU General Public License
-	along with this program; if not, write to the
-	Free Software Foundation, Inc.,
-	59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+	along with this program; if not, see <http://www.gnu.org/licenses/>.
  */
 
 /*
diff --git a/drivers/net/wireless/rt2x00/rt2500pci.h b/drivers/net/wireless/rt2x00/rt2500pci.h
index 9c10068..573e87b 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.h
+++ b/drivers/net/wireless/rt2x00/rt2500pci.h
@@ -13,9 +13,7 @@
 	GNU General Public License for more details.
 
 	You should have received a copy of the GNU General Public License
-	along with this program; if not, write to the
-	Free Software Foundation, Inc.,
-	59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+	along with this program; if not, see <http://www.gnu.org/licenses/>.
  */
 
 /*
diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index 85acc79..1bb7693 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -13,9 +13,7 @@
 	GNU General Public License for more details.
 
 	You should have received a copy of the GNU General Public License
-	along with this program; if not, write to the
-	Free Software Foundation, Inc.,
-	59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+	along with this program; if not, see <http://www.gnu.org/licenses/>.
  */
 
 /*
diff --git a/drivers/net/wireless/rt2x00/rt2500usb.h b/drivers/net/wireless/rt2x00/rt2500usb.h
index 1b91a4c..afba073 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.h
+++ b/drivers/net/wireless/rt2x00/rt2500usb.h
@@ -13,9 +13,7 @@
 	GNU General Public License for more details.
 
 	You should have received a copy of the GNU General Public License
-	along with this program; if not, write to the
-	Free Software Foundation, Inc.,
-	59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+	along with this program; if not, see <http://www.gnu.org/licenses/>.
  */
 
 /*
diff --git a/drivers/net/wireless/rt2x00/rt2800.h b/drivers/net/wireless/rt2x00/rt2800.h
index aab6b5e..a394a9a 100644
--- a/drivers/net/wireless/rt2x00/rt2800.h
+++ b/drivers/net/wireless/rt2x00/rt2800.h
@@ -21,9 +21,7 @@
 	GNU General Public License for more details.
 
 	You should have received a copy of the GNU General Public License
-	along with this program; if not, write to the
-	Free Software Foundation, Inc.,
-	59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+	along with this program; if not, see <http://www.gnu.org/licenses/>.
  */
 
 /*
diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 776aff3..e1145c0 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -24,9 +24,7 @@
 	GNU General Public License for more details.
 
 	You should have received a copy of the GNU General Public License
-	along with this program; if not, write to the
-	Free Software Foundation, Inc.,
-	59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+	along with this program; if not, see <http://www.gnu.org/licenses/>.
  */
 
 /*
diff --git a/drivers/net/wireless/rt2x00/rt2800lib.h b/drivers/net/wireless/rt2x00/rt2800lib.h
index a94ba44..3019db6 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.h
+++ b/drivers/net/wireless/rt2x00/rt2800lib.h
@@ -14,9 +14,7 @@
 	GNU General Public License for more details.
 
 	You should have received a copy of the GNU General Public License
-	along with this program; if not, write to the
-	Free Software Foundation, Inc.,
-	59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+	along with this program; if not, see <http://www.gnu.org/licenses/>.
  */
 
 #ifndef RT2800LIB_H
diff --git a/drivers/net/wireless/rt2x00/rt2800mmio.c b/drivers/net/wireless/rt2x00/rt2800mmio.c
index a8cc736..de4790b 100644
--- a/drivers/net/wireless/rt2x00/rt2800mmio.c
+++ b/drivers/net/wireless/rt2x00/rt2800mmio.c
@@ -19,9 +19,7 @@
  *	GNU General Public License for more details.
  *
  *	You should have received a copy of the GNU General Public License
- *	along with this program; if not, write to the
- *	Free Software Foundation, Inc.,
- *	59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ *	along with this program; if not, see <http://www.gnu.org/licenses/>.
  */
 
 /*	Module: rt2800mmio
diff --git a/drivers/net/wireless/rt2x00/rt2800mmio.h b/drivers/net/wireless/rt2x00/rt2800mmio.h
index 6a10de3..b63312c 100644
--- a/drivers/net/wireless/rt2x00/rt2800mmio.h
+++ b/drivers/net/wireless/rt2x00/rt2800mmio.h
@@ -19,9 +19,7 @@
  *	GNU General Public License for more details.
  *
  *	You should have received a copy of the GNU General Public License
- *	along with this program; if not, write to the
- *	Free Software Foundation, Inc.,
- *	59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ *	along with this program; if not, see <http://www.gnu.org/licenses/>.
  */
 
 /*	Module: rt2800mmio
diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
index b504455..a5b32ca 100644
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -20,9 +20,7 @@
 	GNU General Public License for more details.
 
 	You should have received a copy of the GNU General Public License
-	along with this program; if not, write to the
-	Free Software Foundation, Inc.,
-	59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+	along with this program; if not, see <http://www.gnu.org/licenses/>.
  */
 
 /*
diff --git a/drivers/net/wireless/rt2x00/rt2800pci.h b/drivers/net/wireless/rt2x00/rt2800pci.h
index a81c9ee..9dfef46 100644
--- a/drivers/net/wireless/rt2x00/rt2800pci.h
+++ b/drivers/net/wireless/rt2x00/rt2800pci.h
@@ -20,9 +20,7 @@
 	GNU General Public License for more details.
 
 	You should have received a copy of the GNU General Public License
-	along with this program; if not, write to the
-	Free Software Foundation, Inc.,
-	59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+	along with this program; if not, see <http://www.gnu.org/licenses/>.
  */
 
 /*
diff --git a/drivers/net/wireless/rt2x00/rt2800soc.c b/drivers/net/wireless/rt2x00/rt2800soc.c
index 1359227..f6d1bf5 100644
--- a/drivers/net/wireless/rt2x00/rt2800soc.c
+++ b/drivers/net/wireless/rt2x00/rt2800soc.c
@@ -19,9 +19,7 @@
  *	GNU General Public License for more details.
  *
  *	You should have received a copy of the GNU General Public License
- *	along with this program; if not, write to the
- *	Free Software Foundation, Inc.,
- *	59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ *	along with this program; if not, see <http://www.gnu.org/licenses/>.
  */
 
 /*	Module: rt2800soc
diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index a81ceb6..49ff178 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -18,9 +18,7 @@
 	GNU General Public License for more details.
 
 	You should have received a copy of the GNU General Public License
-	along with this program; if not, write to the
-	Free Software Foundation, Inc.,
-	59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+	along with this program; if not, see <http://www.gnu.org/licenses/>.
  */
 
 /*
diff --git a/drivers/net/wireless/rt2x00/rt2800usb.h b/drivers/net/wireless/rt2x00/rt2800usb.h
index 671ea35..ea7cac0 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.h
+++ b/drivers/net/wireless/rt2x00/rt2800usb.h
@@ -17,9 +17,7 @@
 	GNU General Public License for more details.
 
 	You should have received a copy of the GNU General Public License
-	along with this program; if not, write to the
-	Free Software Foundation, Inc.,
-	59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+	along with this program; if not, see <http://www.gnu.org/licenses/>.
  */
 
 /*
diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index e4ba2ce..e3b885d 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -15,9 +15,7 @@
 	GNU General Public License for more details.
 
 	You should have received a copy of the GNU General Public License
-	along with this program; if not, write to the
-	Free Software Foundation, Inc.,
-	59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+	along with this program; if not, see <http://www.gnu.org/licenses/>.
  */
 
 /*
diff --git a/drivers/net/wireless/rt2x00/rt2x00config.c b/drivers/net/wireless/rt2x00/rt2x00config.c
index 8cb43f8..1122dc4 100644
--- a/drivers/net/wireless/rt2x00/rt2x00config.c
+++ b/drivers/net/wireless/rt2x00/rt2x00config.c
@@ -13,9 +13,7 @@
 	GNU General Public License for more details.
 
 	You should have received a copy of the GNU General Public License
-	along with this program; if not, write to the
-	Free Software Foundation, Inc.,
-	59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+	along with this program; if not, see <http://www.gnu.org/licenses/>.
  */
 
 /*
diff --git a/drivers/net/wireless/rt2x00/rt2x00crypto.c b/drivers/net/wireless/rt2x00/rt2x00crypto.c
index 3db0d99..a2fd05b 100644
--- a/drivers/net/wireless/rt2x00/rt2x00crypto.c
+++ b/drivers/net/wireless/rt2x00/rt2x00crypto.c
@@ -13,9 +13,7 @@
 	GNU General Public License for more details.
 
 	You should have received a copy of the GNU General Public License
-	along with this program; if not, write to the
-	Free Software Foundation, Inc.,
-	59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+	along with this program; if not, see <http://www.gnu.org/licenses/>.
  */
 
 /*
diff --git a/drivers/net/wireless/rt2x00/rt2x00debug.c b/drivers/net/wireless/rt2x00/rt2x00debug.c
index 7f7baae..2e3d164 100644
--- a/drivers/net/wireless/rt2x00/rt2x00debug.c
+++ b/drivers/net/wireless/rt2x00/rt2x00debug.c
@@ -13,9 +13,7 @@
 	GNU General Public License for more details.
 
 	You should have received a copy of the GNU General Public License
-	along with this program; if not, write to the
-	Free Software Foundation, Inc.,
-	59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+	along with this program; if not, see <http://www.gnu.org/licenses/>.
  */
 
 /*
diff --git a/drivers/net/wireless/rt2x00/rt2x00debug.h b/drivers/net/wireless/rt2x00/rt2x00debug.h
index e11d39b..e65712c 100644
--- a/drivers/net/wireless/rt2x00/rt2x00debug.h
+++ b/drivers/net/wireless/rt2x00/rt2x00debug.h
@@ -13,9 +13,7 @@
 	GNU General Public License for more details.
 
 	You should have received a copy of the GNU General Public License
-	along with this program; if not, write to the
-	Free Software Foundation, Inc.,
-	59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+	along with this program; if not, see <http://www.gnu.org/licenses/>.
  */
 
 /*
diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index 9dd92a7..00c3fae 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -14,9 +14,7 @@
 	GNU General Public License for more details.
 
 	You should have received a copy of the GNU General Public License
-	along with this program; if not, write to the
-	Free Software Foundation, Inc.,
-	59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+	along with this program; if not, see <http://www.gnu.org/licenses/>.
  */
 
 /*
diff --git a/drivers/net/wireless/rt2x00/rt2x00dump.h b/drivers/net/wireless/rt2x00/rt2x00dump.h
index 063ebcc..4c0e01b 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dump.h
+++ b/drivers/net/wireless/rt2x00/rt2x00dump.h
@@ -13,9 +13,7 @@
 	GNU General Public License for more details.
 
 	You should have received a copy of the GNU General Public License
-	along with this program; if not, write to the
-	Free Software Foundation, Inc.,
-	59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+	along with this program; if not, see <http://www.gnu.org/licenses/>.
  */
 
 /*
diff --git a/drivers/net/wireless/rt2x00/rt2x00firmware.c b/drivers/net/wireless/rt2x00/rt2x00firmware.c
index 1b4254b..fbae279 100644
--- a/drivers/net/wireless/rt2x00/rt2x00firmware.c
+++ b/drivers/net/wireless/rt2x00/rt2x00firmware.c
@@ -14,9 +14,7 @@
 	GNU General Public License for more details.
 
 	You should have received a copy of the GNU General Public License
-	along with this program; if not, write to the
-	Free Software Foundation, Inc.,
-	59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+	along with this program; if not, see <http://www.gnu.org/licenses/>.
  */
 
 /*
diff --git a/drivers/net/wireless/rt2x00/rt2x00leds.c b/drivers/net/wireless/rt2x00/rt2x00leds.c
index 997a6c8..c681d04 100644
--- a/drivers/net/wireless/rt2x00/rt2x00leds.c
+++ b/drivers/net/wireless/rt2x00/rt2x00leds.c
@@ -13,9 +13,7 @@
 	GNU General Public License for more details.
 
 	You should have received a copy of the GNU General Public License
-	along with this program; if not, write to the
-	Free Software Foundation, Inc.,
-	59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+	along with this program; if not, see <http://www.gnu.org/licenses/>.
  */
 
 /*
diff --git a/drivers/net/wireless/rt2x00/rt2x00leds.h b/drivers/net/wireless/rt2x00/rt2x00leds.h
index 3b46f0c..b2c5269 100644
--- a/drivers/net/wireless/rt2x00/rt2x00leds.h
+++ b/drivers/net/wireless/rt2x00/rt2x00leds.h
@@ -13,9 +13,7 @@
 	GNU General Public License for more details.
 
 	You should have received a copy of the GNU General Public License
-	along with this program; if not, write to the
-	Free Software Foundation, Inc.,
-	59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+	along with this program; if not, see <http://www.gnu.org/licenses/>.
  */
 
 /*
diff --git a/drivers/net/wireless/rt2x00/rt2x00lib.h b/drivers/net/wireless/rt2x00/rt2x00lib.h
index 7f40ab8..fb7c349 100644
--- a/drivers/net/wireless/rt2x00/rt2x00lib.h
+++ b/drivers/net/wireless/rt2x00/rt2x00lib.h
@@ -14,9 +14,7 @@
 	GNU General Public License for more details.
 
 	You should have received a copy of the GNU General Public License
-	along with this program; if not, write to the
-	Free Software Foundation, Inc.,
-	59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+	along with this program; if not, see <http://www.gnu.org/licenses/>.
  */
 
 /*
diff --git a/drivers/net/wireless/rt2x00/rt2x00link.c b/drivers/net/wireless/rt2x00/rt2x00link.c
index c2b3b66..9b941c0 100644
--- a/drivers/net/wireless/rt2x00/rt2x00link.c
+++ b/drivers/net/wireless/rt2x00/rt2x00link.c
@@ -13,9 +13,7 @@
 	GNU General Public License for more details.
 
 	You should have received a copy of the GNU General Public License
-	along with this program; if not, write to the
-	Free Software Foundation, Inc.,
-	59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+	along with this program; if not, see <http://www.gnu.org/licenses/>.
  */
 
 /*
diff --git a/drivers/net/wireless/rt2x00/rt2x00mac.c b/drivers/net/wireless/rt2x00/rt2x00mac.c
index 2183e79..ddeb5a7 100644
--- a/drivers/net/wireless/rt2x00/rt2x00mac.c
+++ b/drivers/net/wireless/rt2x00/rt2x00mac.c
@@ -13,9 +13,7 @@
 	GNU General Public License for more details.
 
 	You should have received a copy of the GNU General Public License
-	along with this program; if not, write to the
-	Free Software Foundation, Inc.,
-	59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+	along with this program; if not, see <http://www.gnu.org/licenses/>.
  */
 
 /*
diff --git a/drivers/net/wireless/rt2x00/rt2x00mmio.c b/drivers/net/wireless/rt2x00/rt2x00mmio.c
index 64b06c6..6f236ea 100644
--- a/drivers/net/wireless/rt2x00/rt2x00mmio.c
+++ b/drivers/net/wireless/rt2x00/rt2x00mmio.c
@@ -13,9 +13,7 @@
 	GNU General Public License for more details.
 
 	You should have received a copy of the GNU General Public License
-	along with this program; if not, write to the
-	Free Software Foundation, Inc.,
-	59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+	along with this program; if not, see <http://www.gnu.org/licenses/>.
  */
 
 /*
diff --git a/drivers/net/wireless/rt2x00/rt2x00mmio.h b/drivers/net/wireless/rt2x00/rt2x00mmio.h
index cda3dbc..701c312 100644
--- a/drivers/net/wireless/rt2x00/rt2x00mmio.h
+++ b/drivers/net/wireless/rt2x00/rt2x00mmio.h
@@ -13,9 +13,7 @@
 	GNU General Public License for more details.
 
 	You should have received a copy of the GNU General Public License
-	along with this program; if not, write to the
-	Free Software Foundation, Inc.,
-	59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+	along with this program; if not, see <http://www.gnu.org/licenses/>.
  */
 
 /*
diff --git a/drivers/net/wireless/rt2x00/rt2x00pci.c b/drivers/net/wireless/rt2x00/rt2x00pci.c
index 25da20e..82819e0 100644
--- a/drivers/net/wireless/rt2x00/rt2x00pci.c
+++ b/drivers/net/wireless/rt2x00/rt2x00pci.c
@@ -13,9 +13,7 @@
 	GNU General Public License for more details.
 
 	You should have received a copy of the GNU General Public License
-	along with this program; if not, write to the
-	Free Software Foundation, Inc.,
-	59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+	along with this program; if not, see <http://www.gnu.org/licenses/>.
  */
 
 /*
diff --git a/drivers/net/wireless/rt2x00/rt2x00pci.h b/drivers/net/wireless/rt2x00/rt2x00pci.h
index 60d90b2..bc0ca5f 100644
--- a/drivers/net/wireless/rt2x00/rt2x00pci.h
+++ b/drivers/net/wireless/rt2x00/rt2x00pci.h
@@ -13,9 +13,7 @@
 	GNU General Public License for more details.
 
 	You should have received a copy of the GNU General Public License
-	along with this program; if not, write to the
-	Free Software Foundation, Inc.,
-	59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+	along with this program; if not, see <http://www.gnu.org/licenses/>.
  */
 
 /*
diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.c b/drivers/net/wireless/rt2x00/rt2x00queue.c
index a5d38e8..5642ccc 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.c
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
@@ -15,9 +15,7 @@
 	GNU General Public License for more details.
 
 	You should have received a copy of the GNU General Public License
-	along with this program; if not, write to the
-	Free Software Foundation, Inc.,
-	59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+	along with this program; if not, see <http://www.gnu.org/licenses/>.
  */
 
 /*
diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.h b/drivers/net/wireless/rt2x00/rt2x00queue.h
index ebe1172..c48125b 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.h
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.h
@@ -13,9 +13,7 @@
 	GNU General Public License for more details.
 
 	You should have received a copy of the GNU General Public License
-	along with this program; if not, write to the
-	Free Software Foundation, Inc.,
-	59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+	along with this program; if not, see <http://www.gnu.org/licenses/>.
  */
 
 /*
diff --git a/drivers/net/wireless/rt2x00/rt2x00reg.h b/drivers/net/wireless/rt2x00/rt2x00reg.h
index 6f867ee..3cc541d 100644
--- a/drivers/net/wireless/rt2x00/rt2x00reg.h
+++ b/drivers/net/wireless/rt2x00/rt2x00reg.h
@@ -13,9 +13,7 @@
 	GNU General Public License for more details.
 
 	You should have received a copy of the GNU General Public License
-	along with this program; if not, write to the
-	Free Software Foundation, Inc.,
-	59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+	along with this program; if not, see <http://www.gnu.org/licenses/>.
  */
 
 /*
diff --git a/drivers/net/wireless/rt2x00/rt2x00soc.c b/drivers/net/wireless/rt2x00/rt2x00soc.c
index 9271a5f..69a0cda 100644
--- a/drivers/net/wireless/rt2x00/rt2x00soc.c
+++ b/drivers/net/wireless/rt2x00/rt2x00soc.c
@@ -14,9 +14,7 @@
 	GNU General Public License for more details.
 
 	You should have received a copy of the GNU General Public License
-	along with this program; if not, write to the
-	Free Software Foundation, Inc.,
-	59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+	along with this program; if not, see <http://www.gnu.org/licenses/>.
  */
 
 /*
diff --git a/drivers/net/wireless/rt2x00/rt2x00soc.h b/drivers/net/wireless/rt2x00/rt2x00soc.h
index 474cbfc..9948d35 100644
--- a/drivers/net/wireless/rt2x00/rt2x00soc.h
+++ b/drivers/net/wireless/rt2x00/rt2x00soc.h
@@ -13,9 +13,7 @@
 	GNU General Public License for more details.
 
 	You should have received a copy of the GNU General Public License
-	along with this program; if not, write to the
-	Free Software Foundation, Inc.,
-	59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+	along with this program; if not, see <http://www.gnu.org/licenses/>.
  */
 
 /*
diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.c b/drivers/net/wireless/rt2x00/rt2x00usb.c
index 4e12162..1057245 100644
--- a/drivers/net/wireless/rt2x00/rt2x00usb.c
+++ b/drivers/net/wireless/rt2x00/rt2x00usb.c
@@ -14,9 +14,7 @@
 	GNU General Public License for more details.
 
 	You should have received a copy of the GNU General Public License
-	along with this program; if not, write to the
-	Free Software Foundation, Inc.,
-	59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+	along with this program; if not, see <http://www.gnu.org/licenses/>.
  */
 
 /*
diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.h b/drivers/net/wireless/rt2x00/rt2x00usb.h
index 323ca7b..e7bcf62 100644
--- a/drivers/net/wireless/rt2x00/rt2x00usb.h
+++ b/drivers/net/wireless/rt2x00/rt2x00usb.h
@@ -13,9 +13,7 @@
 	GNU General Public License for more details.
 
 	You should have received a copy of the GNU General Public License
-	along with this program; if not, write to the
-	Free Software Foundation, Inc.,
-	59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+	along with this program; if not, see <http://www.gnu.org/licenses/>.
  */
 
 /*
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index a5b69cb..b76f604 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -13,9 +13,7 @@
 	GNU General Public License for more details.
 
 	You should have received a copy of the GNU General Public License
-	along with this program; if not, write to the
-	Free Software Foundation, Inc.,
-	59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+	along with this program; if not, see <http://www.gnu.org/licenses/>.
  */
 
 /*
diff --git a/drivers/net/wireless/rt2x00/rt61pci.h b/drivers/net/wireless/rt2x00/rt61pci.h
index 9bc6b60..1442075 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.h
+++ b/drivers/net/wireless/rt2x00/rt61pci.h
@@ -13,9 +13,7 @@
 	GNU General Public License for more details.
 
 	You should have received a copy of the GNU General Public License
-	along with this program; if not, write to the
-	Free Software Foundation, Inc.,
-	59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+	along with this program; if not, see <http://www.gnu.org/licenses/>.
  */
 
 /*
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index 1baf9c8..ade88d7 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -13,9 +13,7 @@
 	GNU General Public License for more details.
 
 	You should have received a copy of the GNU General Public License
-	along with this program; if not, write to the
-	Free Software Foundation, Inc.,
-	59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+	along with this program; if not, see <http://www.gnu.org/licenses/>.
  */
 
 /*
diff --git a/drivers/net/wireless/rt2x00/rt73usb.h b/drivers/net/wireless/rt2x00/rt73usb.h
index 7577e0b..4a4f235 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.h
+++ b/drivers/net/wireless/rt2x00/rt73usb.h
@@ -13,9 +13,7 @@
 	GNU General Public License for more details.
 
 	You should have received a copy of the GNU General Public License
-	along with this program; if not, write to the
-	Free Software Foundation, Inc.,
-	59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+	along with this program; if not, see <http://www.gnu.org/licenses/>.
  */
 
 /*
-- 
1.8.3.1

