Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:57224 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751872AbbJEPB7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Oct 2015 11:01:59 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: Eyal Shapira <eyal@wizery.com>,
	Eyal Shapira <eyalx.shapira@intel.com>,
	Luca Coelho <luciano.coelho@intel.com>
Date: Mon,  5 Oct 2015 17:36:50 +0300
Message-Id: <1444055820-27506-19-git-send-email-luca@coelho.fi> (sfid-20151005_170205_062609_0697B5D1)
In-Reply-To: <1444050759.27220.15.camel@coelho.fi>
References: <1444050759.27220.15.camel@coelho.fi>
Subject: [PATCH 19/29] iwlwifi: mvm: rs: remove overflowing debug message
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eyal Shapira <eyal@wizery.com>

This message isn't very useful and creates clutter.
Remove it.

Signed-off-by: Eyal Shapira <eyalx.shapira@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/rs.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/rs.c b/drivers/net/wireless/iwlwifi/mvm/rs.c
index 98f4d78..49cf311 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/rs.c
@@ -2584,7 +2584,6 @@ static struct rs_rate *rs_get_optimal_rate(struct iwl_mvm *mvm,
 		}
 	}
 
-	rs_dump_rate(mvm, rate, "OPTIMAL RATE");
 	return rate;
 }
 
-- 
2.5.3

