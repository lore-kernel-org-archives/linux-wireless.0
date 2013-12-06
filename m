Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:49959 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757528Ab3LFLc1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Dec 2013 06:32:27 -0500
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
	linux-wireless@vger.kernel.org
Subject: [net 5/5] rfkill: Fix FSF address in file headers
Date: Fri,  6 Dec 2013 03:32:14 -0800
Message-Id: <1386329534-21739-5-git-send-email-jeffrey.t.kirsher@intel.com> (sfid-20131206_123257_671306_3F814CA2)
In-Reply-To: <1386329534-21739-1-git-send-email-jeffrey.t.kirsher@intel.com>
References: <1386329534-21739-1-git-send-email-jeffrey.t.kirsher@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Several files refer to an old address for the Free Software Foundation
in the file header comment.  Resolve by replacing the address with
the URL <http://www.gnu.org/licenses/> so that we do not have to keep
updating the header comments anytime the address changes.

CC: linux-wireless@vger.kernel.org
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 net/rfkill/core.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/net/rfkill/core.c b/net/rfkill/core.c
index 1bacc10..ed7e0b4 100644
--- a/net/rfkill/core.c
+++ b/net/rfkill/core.c
@@ -14,9 +14,7 @@
  * GNU General Public License for more details.
  *
  * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the
- * Free Software Foundation, Inc.,
- * 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ * along with this program; if not, see <http://www.gnu.org/licenses/>.
  */
 
 #include <linux/kernel.h>
-- 
1.8.3.1

