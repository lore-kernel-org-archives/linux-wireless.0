Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f51.google.com ([74.125.82.51]:51835 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932555AbaJ2Lva (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2014 07:51:30 -0400
Received: by mail-wg0-f51.google.com with SMTP id l18so3100397wgh.10
        for <linux-wireless@vger.kernel.org>; Wed, 29 Oct 2014 04:51:29 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Luciano Coelho <luciano.coelho@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 19/25] iwlwifi: mvm: remove unnecessary includes in tt.c
Date: Wed, 29 Oct 2014 13:50:40 +0200
Message-Id: <1414583446-11032-19-git-send-email-egrumbach@gmail.com> (sfid-20141029_125153_004422_196A5936)
In-Reply-To: <CANUX_P0TURG9GNMRUOTGFfh=qzSNKkDh9Gm7Asq5jXr=0gQgLg@mail.gmail.com>
References: <CANUX_P0TURG9GNMRUOTGFfh=qzSNKkDh9Gm7Asq5jXr=0gQgLg@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

We used to need to include some headers in order to read the registers
and do all the calculations by ourselves, but this is not done anymore
(i.e. we let the firmware do this for us), so we don't need to include
those headers anymore.

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/tt.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/tt.c b/drivers/net/wireless/iwlwifi/mvm/tt.c
index acca44a..d4f2c29 100644
--- a/drivers/net/wireless/iwlwifi/mvm/tt.c
+++ b/drivers/net/wireless/iwlwifi/mvm/tt.c
@@ -64,10 +64,6 @@
  *****************************************************************************/
 
 #include "mvm.h"
-#include "iwl-config.h"
-#include "iwl-io.h"
-#include "iwl-csr.h"
-#include "iwl-prph.h"
 
 #define IWL_MVM_TEMP_NOTIF_WAIT_TIMEOUT	HZ
 
-- 
1.9.1

