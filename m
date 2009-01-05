Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.wellnetcz.com ([212.24.148.102]:54548 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750730AbZAEQDm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Jan 2009 11:03:42 -0500
From: Jiri Slaby <jirislaby@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	Jiri Slaby <jirislaby@gmail.com>,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 1/1] IWL: fix WARN typo
Date: Mon,  5 Jan 2009 17:03:24 +0100
Message-Id: <1231171404-22822-1-git-send-email-jirislaby@gmail.com> (sfid-20090105_170346_728743_CFC4B367)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

new kew -> a new key

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Tomas Winkler <tomas.winkler@intel.com>
Cc: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/iwlwifi/iwl-sta.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.c b/drivers/net/wireless/iwlwifi/iwl-sta.c
index 412f66b..b28564a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.c
@@ -638,7 +638,7 @@ static int iwl_set_wep_dynamic_key_info(struct iwl_priv *priv,
 	 * in uCode. */
 
 	WARN(priv->stations[sta_id].sta.key.key_offset == WEP_INVALID_OFFSET,
-		"no space for new kew");
+		"no space for a new key");
 
 	priv->stations[sta_id].sta.key.key_flags = key_flags;
 	priv->stations[sta_id].sta.sta.modify_mask = STA_MODIFY_KEY_MASK;
-- 
1.6.0.6

