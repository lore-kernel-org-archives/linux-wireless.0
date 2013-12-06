Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:49959 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757469Ab3LFLcZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Dec 2013 06:32:25 -0500
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
	linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: [net 3/5] prism54: Fix FSF address in file headers
Date: Fri,  6 Dec 2013 03:32:12 -0800
Message-Id: <1386329534-21739-3-git-send-email-jeffrey.t.kirsher@intel.com> (sfid-20131206_123257_081776_395E72EB)
In-Reply-To: <1386329534-21739-1-git-send-email-jeffrey.t.kirsher@intel.com>
References: <1386329534-21739-1-git-send-email-jeffrey.t.kirsher@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Several files refer to an old address for the Free Software Foundation
in the file header comment.  Resolve by replacing the address with
the URL <http://www.gnu.org/licenses/> so that we do not have to keep
updating the header comments anytime the address changes.

CC: linux-wireless@vger.kernel.org
CC: "Luis R. Rodriguez" <mcgrof@gmail.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/wireless/prism54/isl_38xx.c       | 3 +--
 drivers/net/wireless/prism54/isl_38xx.h       | 3 +--
 drivers/net/wireless/prism54/isl_ioctl.c      | 3 +--
 drivers/net/wireless/prism54/isl_ioctl.h      | 3 +--
 drivers/net/wireless/prism54/isl_oid.h        | 3 +--
 drivers/net/wireless/prism54/islpci_dev.c     | 3 +--
 drivers/net/wireless/prism54/islpci_dev.h     | 3 +--
 drivers/net/wireless/prism54/islpci_eth.c     | 3 +--
 drivers/net/wireless/prism54/islpci_eth.h     | 3 +--
 drivers/net/wireless/prism54/islpci_hotplug.c | 3 +--
 drivers/net/wireless/prism54/islpci_mgt.c     | 3 +--
 drivers/net/wireless/prism54/islpci_mgt.h     | 3 +--
 drivers/net/wireless/prism54/oid_mgt.c        | 3 +--
 drivers/net/wireless/prism54/oid_mgt.h        | 3 +--
 drivers/net/wireless/prism54/prismcompat.h    | 3 +--
 15 files changed, 15 insertions(+), 30 deletions(-)

diff --git a/drivers/net/wireless/prism54/isl_38xx.c b/drivers/net/wireless/prism54/isl_38xx.c
index 02fc67b..333c1a2 100644
--- a/drivers/net/wireless/prism54/isl_38xx.c
+++ b/drivers/net/wireless/prism54/isl_38xx.c
@@ -12,8 +12,7 @@
  *  GNU General Public License for more details.
  *
  *  You should have received a copy of the GNU General Public License
- *  along with this program; if not, write to the Free Software
- *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ *  along with this program; if not, see <http://www.gnu.org/licenses/>.
  *
  */
 
diff --git a/drivers/net/wireless/prism54/isl_38xx.h b/drivers/net/wireless/prism54/isl_38xx.h
index 19c33d3..547ab88 100644
--- a/drivers/net/wireless/prism54/isl_38xx.h
+++ b/drivers/net/wireless/prism54/isl_38xx.h
@@ -11,8 +11,7 @@
  *  GNU General Public License for more details.
  *
  *  You should have received a copy of the GNU General Public License
- *  along with this program; if not, write to the Free Software
- *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ *  along with this program; if not, see <http://www.gnu.org/licenses/>.
  *
  */
 
diff --git a/drivers/net/wireless/prism54/isl_ioctl.c b/drivers/net/wireless/prism54/isl_ioctl.c
index 8863a6c..df784fe 100644
--- a/drivers/net/wireless/prism54/isl_ioctl.c
+++ b/drivers/net/wireless/prism54/isl_ioctl.c
@@ -14,8 +14,7 @@
  *  GNU General Public License for more details.
  *
  *  You should have received a copy of the GNU General Public License
- *  along with this program; if not, write to the Free Software
- *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ *  along with this program; if not, see <http://www.gnu.org/licenses/>.
  *
  */
 
diff --git a/drivers/net/wireless/prism54/isl_ioctl.h b/drivers/net/wireless/prism54/isl_ioctl.h
index a34bceb..842a254 100644
--- a/drivers/net/wireless/prism54/isl_ioctl.h
+++ b/drivers/net/wireless/prism54/isl_ioctl.h
@@ -13,8 +13,7 @@
  *  GNU General Public License for more details.
  *
  *  You should have received a copy of the GNU General Public License
- *  along with this program; if not, write to the Free Software
- *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ *  along with this program; if not, see <http://www.gnu.org/licenses/>.
  *
  */
 
diff --git a/drivers/net/wireless/prism54/isl_oid.h b/drivers/net/wireless/prism54/isl_oid.h
index 59e3125..83fec55 100644
--- a/drivers/net/wireless/prism54/isl_oid.h
+++ b/drivers/net/wireless/prism54/isl_oid.h
@@ -13,8 +13,7 @@
  *  GNU General Public License for more details.
  *
  *  You should have received a copy of the GNU General Public License
- *  along with this program; if not, write to the Free Software
- *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ *  along with this program; if not, see <http://www.gnu.org/licenses/>.
  *
  */
 
diff --git a/drivers/net/wireless/prism54/islpci_dev.c b/drivers/net/wireless/prism54/islpci_dev.c
index e05d9b4..53884ca 100644
--- a/drivers/net/wireless/prism54/islpci_dev.c
+++ b/drivers/net/wireless/prism54/islpci_dev.c
@@ -13,8 +13,7 @@
  *  GNU General Public License for more details.
  *
  *  You should have received a copy of the GNU General Public License
- *  along with this program; if not, write to the Free Software
- *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ *  along with this program; if not, see <http://www.gnu.org/licenses/>.
  *
  */
 
diff --git a/drivers/net/wireless/prism54/islpci_dev.h b/drivers/net/wireless/prism54/islpci_dev.h
index c404038..f6f088e 100644
--- a/drivers/net/wireless/prism54/islpci_dev.h
+++ b/drivers/net/wireless/prism54/islpci_dev.h
@@ -14,8 +14,7 @@
  *  GNU General Public License for more details.
  *
  *  You should have received a copy of the GNU General Public License
- *  along with this program; if not, write to the Free Software
- *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ *  along with this program; if not, see <http://www.gnu.org/licenses/>.
  *
  */
 
diff --git a/drivers/net/wireless/prism54/islpci_eth.c b/drivers/net/wireless/prism54/islpci_eth.c
index 799e148..674658f 100644
--- a/drivers/net/wireless/prism54/islpci_eth.c
+++ b/drivers/net/wireless/prism54/islpci_eth.c
@@ -11,8 +11,7 @@
  *  GNU General Public License for more details.
  *
  *  You should have received a copy of the GNU General Public License
- *  along with this program; if not, write to the Free Software
- *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ *  along with this program; if not, see <http://www.gnu.org/licenses/>.
  *
  */
 
diff --git a/drivers/net/wireless/prism54/islpci_eth.h b/drivers/net/wireless/prism54/islpci_eth.h
index 6ca30a5..80f50f1 100644
--- a/drivers/net/wireless/prism54/islpci_eth.h
+++ b/drivers/net/wireless/prism54/islpci_eth.h
@@ -11,8 +11,7 @@
  *  GNU General Public License for more details.
  *
  *  You should have received a copy of the GNU General Public License
- *  along with this program; if not, write to the Free Software
- *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ *  along with this program; if not, see <http://www.gnu.org/licenses/>.
  *
  */
 
diff --git a/drivers/net/wireless/prism54/islpci_hotplug.c b/drivers/net/wireless/prism54/islpci_hotplug.c
index 9e68e0c..890334a 100644
--- a/drivers/net/wireless/prism54/islpci_hotplug.c
+++ b/drivers/net/wireless/prism54/islpci_hotplug.c
@@ -12,8 +12,7 @@
  *  GNU General Public License for more details.
  *
  *  You should have received a copy of the GNU General Public License
- *  along with this program; if not, write to the Free Software
- *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ *  along with this program; if not, see <http://www.gnu.org/licenses/>.
  *
  */
 
diff --git a/drivers/net/wireless/prism54/islpci_mgt.c b/drivers/net/wireless/prism54/islpci_mgt.c
index 9f19cce..0de14df 100644
--- a/drivers/net/wireless/prism54/islpci_mgt.c
+++ b/drivers/net/wireless/prism54/islpci_mgt.c
@@ -12,8 +12,7 @@
  *  GNU General Public License for more details.
  *
  *  You should have received a copy of the GNU General Public License
- *  along with this program; if not, write to the Free Software
- *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ *  along with this program; if not, see <http://www.gnu.org/licenses/>.
  *
  */
 
diff --git a/drivers/net/wireless/prism54/islpci_mgt.h b/drivers/net/wireless/prism54/islpci_mgt.h
index 0db93db..700c434 100644
--- a/drivers/net/wireless/prism54/islpci_mgt.h
+++ b/drivers/net/wireless/prism54/islpci_mgt.h
@@ -12,8 +12,7 @@
  *  GNU General Public License for more details.
  *
  *  You should have received a copy of the GNU General Public License
- *  along with this program; if not, write to the Free Software
- *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ *  along with this program; if not, see <http://www.gnu.org/licenses/>.
  *
  */
 
diff --git a/drivers/net/wireless/prism54/oid_mgt.c b/drivers/net/wireless/prism54/oid_mgt.c
index 056af38..47b34bf 100644
--- a/drivers/net/wireless/prism54/oid_mgt.c
+++ b/drivers/net/wireless/prism54/oid_mgt.c
@@ -11,8 +11,7 @@
  *  GNU General Public License for more details.
  *
  *  You should have received a copy of the GNU General Public License
- *  along with this program; if not, write to the Free Software
- *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ *  along with this program; if not, see <http://www.gnu.org/licenses/>.
  *
  */
 
diff --git a/drivers/net/wireless/prism54/oid_mgt.h b/drivers/net/wireless/prism54/oid_mgt.h
index 92c8a2d..cf5141d 100644
--- a/drivers/net/wireless/prism54/oid_mgt.h
+++ b/drivers/net/wireless/prism54/oid_mgt.h
@@ -11,8 +11,7 @@
  *  GNU General Public License for more details.
  *
  *  You should have received a copy of the GNU General Public License
- *  along with this program; if not, write to the Free Software
- *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ *  along with this program; if not, see <http://www.gnu.org/licenses/>.
  *
  */
 
diff --git a/drivers/net/wireless/prism54/prismcompat.h b/drivers/net/wireless/prism54/prismcompat.h
index aa1d174..bc1401e 100644
--- a/drivers/net/wireless/prism54/prismcompat.h
+++ b/drivers/net/wireless/prism54/prismcompat.h
@@ -11,8 +11,7 @@
  *  GNU General Public License for more details.
  *
  *  You should have received a copy of the GNU General Public License
- *  along with this program; if not, write to the Free Software
- *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ *  along with this program; if not, see <http://www.gnu.org/licenses/>.
  *
  */
 
-- 
1.8.3.1

