Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:2475 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753013Ab2D0Xf1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Apr 2012 19:35:27 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 2/2] iwlwifi: remove the iwl_shared reference
Date: Fri, 27 Apr 2012 16:29:39 -0700
Message-Id: <1335569379-25113-3-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120428_013530_768006_8151B40E)
In-Reply-To: <1335569379-25113-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1335569379-25113-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Change-Id: I10e42e0cc7dd91047f093ea2c5a55d65c004ada6
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Reviewed-on: http://git-mwg.jer.intel.com/gerrit/1939
Tested-by: Jenkins
Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-modparams.h |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-modparams.h b/drivers/net/wireless/iwlwifi/iwl-modparams.h
index ca15d9a..d9a86d6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-modparams.h
+++ b/drivers/net/wireless/iwlwifi/iwl-modparams.h
@@ -60,8 +60,8 @@
  * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
  *
  *****************************************************************************/
-#ifndef __iwl_shared_h__
-#define __iwl_shared_h__
+#ifndef __iwl_modparams_h__
+#define __iwl_modparams_h__
 
 #include <linux/types.h>
 #include <linux/spinlock.h>
@@ -123,4 +123,4 @@ struct iwl_mod_params {
 	bool disable_5ghz;
 };
 
-#endif /* #__iwl_shared_h__ */
+#endif /* #__iwl_modparams_h__ */
-- 
1.7.0.4

