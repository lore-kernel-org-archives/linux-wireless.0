Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from que31.charter.net ([209.225.8.23]:47153 "EHLO que31.charter.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753601Ab2B0Shb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Feb 2012 13:37:31 -0500
From: Greg Dietsche <Gregory.Dietsche@cuw.edu>
To: sgruszka@redhat.com
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	Greg Dietsche <Gregory.Dietsche@cuw.edu>
Subject: [PATCH 4/4] iwlegacy: remove unused enum il4965_calib_enabled_state
Date: Mon, 27 Feb 2012 12:25:33 -0600
Message-Id: <1330367133-26465-5-git-send-email-Gregory.Dietsche@cuw.edu> (sfid-20120227_193823_460641_E0DB31DC)
In-Reply-To: <1330367133-26465-1-git-send-email-Gregory.Dietsche@cuw.edu>
References: <1330367133-26465-1-git-send-email-Gregory.Dietsche@cuw.edu>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove the enum il4965_calib_enabled_state because it is not used.

Signed-off-by: Greg Dietsche <Gregory.Dietsche@cuw.edu>
---
 drivers/net/wireless/iwlegacy/common.h |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/common.h b/drivers/net/wireless/iwlegacy/common.h
index d0de922..5f50177 100644
--- a/drivers/net/wireless/iwlegacy/common.h
+++ b/drivers/net/wireless/iwlegacy/common.h
@@ -956,11 +956,6 @@ enum il4965_chain_noise_state {
 	IL_CHAIN_NOISE_DONE,
 };
 
-enum il4965_calib_enabled_state {
-	IL_CALIB_DISABLED = 0,	/* must be 0 */
-	IL_CALIB_ENABLED = 1,
-};
-
 enum ucode_type {
 	UCODE_NONE = 0,
 	UCODE_INIT,
-- 
1.7.6.4

