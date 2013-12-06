Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:41607 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751130Ab3LFQ4b (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Dec 2013 11:56:31 -0500
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
	linux-wireless@vger.kernel.org,
	Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Samuel Ortiz <sameo@linux.intel.com>
Subject: [net] nfc: Fix FSF address in file headers
Date: Fri,  6 Dec 2013 08:56:16 -0800
Message-Id: <1386348976-24657-1-git-send-email-jeffrey.t.kirsher@intel.com> (sfid-20131206_175635_443801_84A2A134)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Several files refer to an old address for the Free Software Foundation
in the file header comment.  Resolve by replacing the address with
the URL <http://www.gnu.org/licenses/> so that we do not have to keep
updating the header comments anytime the address changes.

CC: linux-wireless@vger.kernel.org
CC: Lauro Ramos Venancio <lauro.venancio@openbossa.org>
CC: Aloisio Almeida Jr <aloisio.almeida@openbossa.org>
CC: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/nfc/mei_phy.c               | 4 +---
 drivers/nfc/microread/i2c.c         | 4 +---
 drivers/nfc/microread/mei.c         | 4 +---
 drivers/nfc/microread/microread.c   | 4 +---
 drivers/nfc/microread/microread.h   | 4 +---
 drivers/nfc/nfcwilink.c             | 3 +--
 drivers/nfc/pn533.c                 | 4 +---
 drivers/nfc/pn544/i2c.c             | 4 +---
 drivers/nfc/pn544/mei.c             | 4 +---
 drivers/nfc/pn544/pn544.c           | 4 +---
 drivers/nfc/pn544/pn544.h           | 4 +---
 include/linux/platform_data/pn544.h | 3 +--
 net/nfc/af_nfc.c                    | 4 +---
 net/nfc/core.c                      | 4 +---
 net/nfc/hci/command.c               | 4 +---
 net/nfc/hci/core.c                  | 4 +---
 net/nfc/hci/hci.h                   | 4 +---
 net/nfc/hci/hcp.c                   | 4 +---
 net/nfc/hci/llc.c                   | 4 +---
 net/nfc/hci/llc.h                   | 4 +---
 net/nfc/hci/llc_nop.c               | 4 +---
 net/nfc/hci/llc_shdlc.c             | 4 +---
 net/nfc/llcp.h                      | 4 +---
 net/nfc/llcp_commands.c             | 4 +---
 net/nfc/llcp_core.c                 | 4 +---
 net/nfc/llcp_sock.c                 | 4 +---
 net/nfc/nci/core.c                  | 3 +--
 net/nfc/nci/data.c                  | 3 +--
 net/nfc/nci/lib.c                   | 3 +--
 net/nfc/nci/ntf.c                   | 3 +--
 net/nfc/nci/rsp.c                   | 3 +--
 net/nfc/netlink.c                   | 4 +---
 net/nfc/nfc.h                       | 4 +---
 net/nfc/rawsock.c                   | 4 +---
 34 files changed, 34 insertions(+), 95 deletions(-)

diff --git a/drivers/nfc/mei_phy.c b/drivers/nfc/mei_phy.c
index 85f9009..1d78605 100644
--- a/drivers/nfc/mei_phy.c
+++ b/drivers/nfc/mei_phy.c
@@ -13,9 +13,7 @@
  * GNU General Public License for more details.
  *
  * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the
- * Free Software Foundation, Inc.,
- * 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ * along with this program; if not, see <http://www.gnu.org/licenses/>.
  */
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
diff --git a/drivers/nfc/microread/i2c.c b/drivers/nfc/microread/i2c.c
index 696e346..df85cd3 100644
--- a/drivers/nfc/microread/i2c.c
+++ b/drivers/nfc/microread/i2c.c
@@ -13,9 +13,7 @@
  * GNU General Public License for more details.
  *
  * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the
- * Free Software Foundation, Inc.,
- * 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ * along with this program; if not, see <http://www.gnu.org/licenses/>.
  */
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
diff --git a/drivers/nfc/microread/mei.c b/drivers/nfc/microread/mei.c
index 72fafec..2d1395b 100644
--- a/drivers/nfc/microread/mei.c
+++ b/drivers/nfc/microread/mei.c
@@ -13,9 +13,7 @@
  * GNU General Public License for more details.
  *
  * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the
- * Free Software Foundation, Inc.,
- * 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ * along with this program; if not, see <http://www.gnu.org/licenses/>.
  */
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
diff --git a/drivers/nfc/microread/microread.c b/drivers/nfc/microread/microread.c
index 970ded6..f868333 100644
--- a/drivers/nfc/microread/microread.c
+++ b/drivers/nfc/microread/microread.c
@@ -13,9 +13,7 @@
  * GNU General Public License for more details.
  *
  * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the
- * Free Software Foundation, Inc.,
- * 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ * along with this program; if not, see <http://www.gnu.org/licenses/>.
  */
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
diff --git a/drivers/nfc/microread/microread.h b/drivers/nfc/microread/microread.h
index 64b447a..f538641 100644
--- a/drivers/nfc/microread/microread.h
+++ b/drivers/nfc/microread/microread.h
@@ -12,9 +12,7 @@
  * GNU General Public License for more details.
  *
  * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the
- * Free Software Foundation, Inc.,
- * 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ * along with this program; if not, see <http://www.gnu.org/licenses/>.
  */
 
 #ifndef __LOCAL_MICROREAD_H_
diff --git a/drivers/nfc/nfcwilink.c b/drivers/nfc/nfcwilink.c
index 7130864..683671a 100644
--- a/drivers/nfc/nfcwilink.c
+++ b/drivers/nfc/nfcwilink.c
@@ -22,8 +22,7 @@
  *  GNU General Public License for more details.
  *
  *  You should have received a copy of the GNU General Public License
- *  along with this program; if not, write to the Free Software
- *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ *  along with this program; if not, see <http://www.gnu.org/licenses/>.
  *
  */
 #include <linux/platform_device.h>
diff --git a/drivers/nfc/pn533.c b/drivers/nfc/pn533.c
index 2daf04c..3df19e6 100644
--- a/drivers/nfc/pn533.c
+++ b/drivers/nfc/pn533.c
@@ -13,9 +13,7 @@
  * GNU General Public License for more details.
  *
  * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the
- * Free Software Foundation, Inc.,
- * 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ * along with this program; if not, see <http://www.gnu.org/licenses/>.
  */
 
 #include <linux/device.h>
diff --git a/drivers/nfc/pn544/i2c.c b/drivers/nfc/pn544/i2c.c
index b158ee1..d6185ff 100644
--- a/drivers/nfc/pn544/i2c.c
+++ b/drivers/nfc/pn544/i2c.c
@@ -13,9 +13,7 @@
  * GNU General Public License for more details.
  *
  * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the
- * Free Software Foundation, Inc.,
- * 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ * along with this program; if not, see <http://www.gnu.org/licenses/>.
  */
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
diff --git a/drivers/nfc/pn544/mei.c b/drivers/nfc/pn544/mei.c
index ee67de5..330cd40 100644
--- a/drivers/nfc/pn544/mei.c
+++ b/drivers/nfc/pn544/mei.c
@@ -13,9 +13,7 @@
  * GNU General Public License for more details.
  *
  * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the
- * Free Software Foundation, Inc.,
- * 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ * along with this program; if not, see <http://www.gnu.org/licenses/>.
  */
 
 #include <linux/module.h>
diff --git a/drivers/nfc/pn544/pn544.c b/drivers/nfc/pn544/pn544.c
index 74cfa0a..51e21a8 100644
--- a/drivers/nfc/pn544/pn544.c
+++ b/drivers/nfc/pn544/pn544.c
@@ -13,9 +13,7 @@
  * GNU General Public License for more details.
  *
  * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the
- * Free Software Foundation, Inc.,
- * 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ * along with this program; if not, see <http://www.gnu.org/licenses/>.
  */
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
diff --git a/drivers/nfc/pn544/pn544.h b/drivers/nfc/pn544/pn544.h
index 01020e5..491bf45 100644
--- a/drivers/nfc/pn544/pn544.h
+++ b/drivers/nfc/pn544/pn544.h
@@ -12,9 +12,7 @@
  * GNU General Public License for more details.
  *
  * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the
- * Free Software Foundation, Inc.,
- * 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ * along with this program; if not, see <http://www.gnu.org/licenses/>.
  */
 
 #ifndef __LOCAL_PN544_H_
diff --git a/include/linux/platform_data/pn544.h b/include/linux/platform_data/pn544.h
index 713bfd7..5ce1ab9 100644
--- a/include/linux/platform_data/pn544.h
+++ b/include/linux/platform_data/pn544.h
@@ -16,8 +16,7 @@
  * GNU General Public License for more details.
  *
  * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+ * along with this program; if not, see <http://www.gnu.org/licenses/>.
  */
 
 #ifndef _PN544_H_
diff --git a/net/nfc/af_nfc.c b/net/nfc/af_nfc.c
index 9d68441..2277276 100644
--- a/net/nfc/af_nfc.c
+++ b/net/nfc/af_nfc.c
@@ -16,9 +16,7 @@
  * GNU General Public License for more details.
  *
  * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the
- * Free Software Foundation, Inc.,
- * 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ * along with this program; if not, see <http://www.gnu.org/licenses/>.
  */
 
 #include <linux/nfc.h>
diff --git a/net/nfc/core.c b/net/nfc/core.c
index 8725291..02ab341 100644
--- a/net/nfc/core.c
+++ b/net/nfc/core.c
@@ -16,9 +16,7 @@
  * GNU General Public License for more details.
  *
  * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the
- * Free Software Foundation, Inc.,
- * 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ * along with this program; if not, see <http://www.gnu.org/licenses/>.
  */
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": %s: " fmt, __func__
diff --git a/net/nfc/hci/command.c b/net/nfc/hci/command.c
index 64f922b..a9f4d2e 100644
--- a/net/nfc/hci/command.c
+++ b/net/nfc/hci/command.c
@@ -12,9 +12,7 @@
  * GNU General Public License for more details.
  *
  * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the
- * Free Software Foundation, Inc.,
- * 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ * along with this program; if not, see <http://www.gnu.org/licenses/>.
  */
 
 #define pr_fmt(fmt) "hci: %s: " fmt, __func__
diff --git a/net/nfc/hci/core.c b/net/nfc/hci/core.c
index d07ca4c..3b96100 100644
--- a/net/nfc/hci/core.c
+++ b/net/nfc/hci/core.c
@@ -12,9 +12,7 @@
  * GNU General Public License for more details.
  *
  * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the
- * Free Software Foundation, Inc.,
- * 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ * along with this program; if not, see <http://www.gnu.org/licenses/>.
  */
 
 #define pr_fmt(fmt) "hci: %s: " fmt, __func__
diff --git a/net/nfc/hci/hci.h b/net/nfc/hci/hci.h
index b274d12..c3d2e2c 100644
--- a/net/nfc/hci/hci.h
+++ b/net/nfc/hci/hci.h
@@ -12,9 +12,7 @@
  * GNU General Public License for more details.
  *
  * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the
- * Free Software Foundation, Inc.,
- * 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ * along with this program; if not, see <http://www.gnu.org/licenses/>.
  */
 
 #ifndef __LOCAL_HCI_H
diff --git a/net/nfc/hci/hcp.c b/net/nfc/hci/hcp.c
index b6b4109..e9de151 100644
--- a/net/nfc/hci/hcp.c
+++ b/net/nfc/hci/hcp.c
@@ -12,9 +12,7 @@
  * GNU General Public License for more details.
  *
  * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the
- * Free Software Foundation, Inc.,
- * 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ * along with this program; if not, see <http://www.gnu.org/licenses/>.
  */
 
 #define pr_fmt(fmt) "hci: %s: " fmt, __func__
diff --git a/net/nfc/hci/llc.c b/net/nfc/hci/llc.c
index fe5e966..a07d2b8 100644
--- a/net/nfc/hci/llc.c
+++ b/net/nfc/hci/llc.c
@@ -13,9 +13,7 @@
  * GNU General Public License for more details.
  *
  * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the
- * Free Software Foundation, Inc.,
- * 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ * along with this program; if not, see <http://www.gnu.org/licenses/>.
  */
 
 #include <net/nfc/llc.h>
diff --git a/net/nfc/hci/llc.h b/net/nfc/hci/llc.h
index 7be0b7f..5dad4c5 100644
--- a/net/nfc/hci/llc.h
+++ b/net/nfc/hci/llc.h
@@ -13,9 +13,7 @@
  * GNU General Public License for more details.
  *
  * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the
- * Free Software Foundation, Inc.,
- * 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ * along with this program; if not, see <http://www.gnu.org/licenses/>.
  */
 
 #ifndef __LOCAL_LLC_H_
diff --git a/net/nfc/hci/llc_nop.c b/net/nfc/hci/llc_nop.c
index 87b1029..d0435d5 100644
--- a/net/nfc/hci/llc_nop.c
+++ b/net/nfc/hci/llc_nop.c
@@ -13,9 +13,7 @@
  * GNU General Public License for more details.
  *
  * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the
- * Free Software Foundation, Inc.,
- * 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ * along with this program; if not, see <http://www.gnu.org/licenses/>.
  */
 
 #include <linux/types.h>
diff --git a/net/nfc/hci/llc_shdlc.c b/net/nfc/hci/llc_shdlc.c
index 27b313b..719ad0a 100644
--- a/net/nfc/hci/llc_shdlc.c
+++ b/net/nfc/hci/llc_shdlc.c
@@ -13,9 +13,7 @@
  * GNU General Public License for more details.
  *
  * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the
- * Free Software Foundation, Inc.,
- * 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ * along with this program; if not, see <http://www.gnu.org/licenses/>.
  */
 
 #define pr_fmt(fmt) "shdlc: %s: " fmt, __func__
diff --git a/net/nfc/llcp.h b/net/nfc/llcp.h
index f4d48b5..de1789e 100644
--- a/net/nfc/llcp.h
+++ b/net/nfc/llcp.h
@@ -12,9 +12,7 @@
  * GNU General Public License for more details.
  *
  * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the
- * Free Software Foundation, Inc.,
- * 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ * along with this program; if not, see <http://www.gnu.org/licenses/>.
  */
 
 enum llcp_state {
diff --git a/net/nfc/llcp_commands.c b/net/nfc/llcp_commands.c
index 1017894..693cd1a 100644
--- a/net/nfc/llcp_commands.c
+++ b/net/nfc/llcp_commands.c
@@ -12,9 +12,7 @@
  * GNU General Public License for more details.
  *
  * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the
- * Free Software Foundation, Inc.,
- * 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ * along with this program; if not, see <http://www.gnu.org/licenses/>.
  */
 
 #define pr_fmt(fmt) "llcp: %s: " fmt, __func__
diff --git a/net/nfc/llcp_core.c b/net/nfc/llcp_core.c
index 81cd341..1349074 100644
--- a/net/nfc/llcp_core.c
+++ b/net/nfc/llcp_core.c
@@ -12,9 +12,7 @@
  * GNU General Public License for more details.
  *
  * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the
- * Free Software Foundation, Inc.,
- * 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ * along with this program; if not, see <http://www.gnu.org/licenses/>.
  */
 
 #define pr_fmt(fmt) "llcp: %s: " fmt, __func__
diff --git a/net/nfc/llcp_sock.c b/net/nfc/llcp_sock.c
index 824c605..69fbc8d 100644
--- a/net/nfc/llcp_sock.c
+++ b/net/nfc/llcp_sock.c
@@ -12,9 +12,7 @@
  * GNU General Public License for more details.
  *
  * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the
- * Free Software Foundation, Inc.,
- * 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ * along with this program; if not, see <http://www.gnu.org/licenses/>.
  */
 
 #define pr_fmt(fmt) "llcp: %s: " fmt, __func__
diff --git a/net/nfc/nci/core.c b/net/nfc/nci/core.c
index b943d46..f0e955e 100644
--- a/net/nfc/nci/core.c
+++ b/net/nfc/nci/core.c
@@ -20,8 +20,7 @@
  *  GNU General Public License for more details.
  *
  *  You should have received a copy of the GNU General Public License
- *  along with this program; if not, write to the Free Software
- *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ *  along with this program; if not, see <http://www.gnu.org/licenses/>.
  *
  */
 
diff --git a/net/nfc/nci/data.c b/net/nfc/nci/data.c
index 2a9399d..6c3aef8 100644
--- a/net/nfc/nci/data.c
+++ b/net/nfc/nci/data.c
@@ -16,8 +16,7 @@
  *  GNU General Public License for more details.
  *
  *  You should have received a copy of the GNU General Public License
- *  along with this program; if not, write to the Free Software
- *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ *  along with this program; if not, see <http://www.gnu.org/licenses/>.
  *
  */
 
diff --git a/net/nfc/nci/lib.c b/net/nfc/nci/lib.c
index 6b7fd26..ed774a2 100644
--- a/net/nfc/nci/lib.c
+++ b/net/nfc/nci/lib.c
@@ -20,8 +20,7 @@
  *  GNU General Public License for more details.
  *
  *  You should have received a copy of the GNU General Public License
- *  along with this program; if not, write to the Free Software
- *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ *  along with this program; if not, see <http://www.gnu.org/licenses/>.
  *
  */
 
diff --git a/net/nfc/nci/ntf.c b/net/nfc/nci/ntf.c
index b2aa98e..1e90509 100644
--- a/net/nfc/nci/ntf.c
+++ b/net/nfc/nci/ntf.c
@@ -20,8 +20,7 @@
  *  GNU General Public License for more details.
  *
  *  You should have received a copy of the GNU General Public License
- *  along with this program; if not, write to the Free Software
- *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ *  along with this program; if not, see <http://www.gnu.org/licenses/>.
  *
  */
 
diff --git a/net/nfc/nci/rsp.c b/net/nfc/nci/rsp.c
index dd072f3..041de51 100644
--- a/net/nfc/nci/rsp.c
+++ b/net/nfc/nci/rsp.c
@@ -20,8 +20,7 @@
  *  GNU General Public License for more details.
  *
  *  You should have received a copy of the GNU General Public License
- *  along with this program; if not, write to the Free Software
- *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ *  along with this program; if not, see <http://www.gnu.org/licenses/>.
  *
  */
 
diff --git a/net/nfc/netlink.c b/net/nfc/netlink.c
index a9b2342..ebbf6fb 100644
--- a/net/nfc/netlink.c
+++ b/net/nfc/netlink.c
@@ -16,9 +16,7 @@
  * GNU General Public License for more details.
  *
  * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the
- * Free Software Foundation, Inc.,
- * 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ * along with this program; if not, see <http://www.gnu.org/licenses/>.
  */
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": %s: " fmt, __func__
diff --git a/net/nfc/nfc.h b/net/nfc/nfc.h
index aaf606f..9d6e74f 100644
--- a/net/nfc/nfc.h
+++ b/net/nfc/nfc.h
@@ -16,9 +16,7 @@
  * GNU General Public License for more details.
  *
  * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the
- * Free Software Foundation, Inc.,
- * 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ * along with this program; if not, see <http://www.gnu.org/licenses/>.
  */
 
 #ifndef __LOCAL_NFC_H
diff --git a/net/nfc/rawsock.c b/net/nfc/rawsock.c
index 66bcd2e..c27a6e8 100644
--- a/net/nfc/rawsock.c
+++ b/net/nfc/rawsock.c
@@ -16,9 +16,7 @@
  * GNU General Public License for more details.
  *
  * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the
- * Free Software Foundation, Inc.,
- * 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ * along with this program; if not, see <http://www.gnu.org/licenses/>.
  */
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": %s: " fmt, __func__
-- 
1.8.3.1

