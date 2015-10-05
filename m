Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:57218 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751900AbbJEPB4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Oct 2015 11:01:56 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: Eyal Shapira <eyal@wizery.com>,
	Eyal Shapira <eyalx.shapira@intel.com>,
	Luca Coelho <luciano.coelho@intel.com>
Date: Mon,  5 Oct 2015 17:36:51 +0300
Message-Id: <1444055820-27506-20-git-send-email-luca@coelho.fi> (sfid-20151005_170200_743486_845B931F)
In-Reply-To: <1444050759.27220.15.camel@coelho.fi>
References: <1444050759.27220.15.camel@coelho.fi>
Subject: [PATCH 20/29] iwlwifi: mvm: rs: minor indentation fix
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eyal Shapira <eyal@wizery.com>

Indentation was off a bit. Fix it.

Signed-off-by: Eyal Shapira <eyalx.shapira@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/rs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/rs.c b/drivers/net/wireless/iwlwifi/mvm/rs.c
index 49cf311..2bf2a08 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/rs.c
@@ -604,8 +604,8 @@ static inline u8 rs_is_valid_ant(u8 valid_antenna, u8 ant_type)
 }
 
 static int rs_tl_turn_on_agg_for_tid(struct iwl_mvm *mvm,
-				      struct iwl_lq_sta *lq_data, u8 tid,
-				      struct ieee80211_sta *sta)
+				     struct iwl_lq_sta *lq_data, u8 tid,
+				     struct ieee80211_sta *sta)
 {
 	int ret = -EAGAIN;
 
-- 
2.5.3

