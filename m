Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wp188.webpack.hosteurope.de ([80.237.132.195]:41650 "EHLO
	wp188.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754298Ab2BORzX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Feb 2012 12:55:23 -0500
From: Danny Kukawka <danny.kukawka@bisect.de>
To: linux-wireless@vger.kernel.org
Cc: Danny Kukawka <dkukawka@suse.de>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] iwlwifi: iwl-agn.h included twice
Date: Wed, 15 Feb 2012 18:55:16 +0100
Message-Id: <1329328516-4792-1-git-send-email-danny.kukawka@bisect.de> (sfid-20120215_185648_065412_00199C9B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

drivers/net/wireless/iwlwifi/iwl-core.c included 'iwl-agn.h' twice,
remove the duplicate.

Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>
---
 drivers/net/wireless/iwlwifi/iwl-core.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 7bcfa78..5a7720f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -38,7 +38,6 @@
 #include "iwl-core.h"
 #include "iwl-io.h"
 #include "iwl-power.h"
-#include "iwl-agn.h"
 #include "iwl-shared.h"
 #include "iwl-agn.h"
 #include "iwl-trans.h"
-- 
1.7.8.3

