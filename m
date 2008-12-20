Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.30]:52039 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752017AbYLTSxa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 20 Dec 2008 13:53:30 -0500
Received: by yx-out-2324.google.com with SMTP id 8so529921yxm.1
        for <linux-wireless@vger.kernel.org>; Sat, 20 Dec 2008 10:53:29 -0800 (PST)
Message-ID: <cef1c9520812201053m670a892am5980bfdfc1a746c7@mail.gmail.com> (sfid-20081220_195335_011254_58A3A7BC)
Date: Sat, 20 Dec 2008 10:53:29 -0800
From: "Daniel Wu" <dyqith@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH] iwlwifi: Fix typo in iwl-commands.h for CCK rate bit range.
Cc: "Tomas Winkler" <tomasw@gmail.com>,
	"reinette chatre" <reinette.chatre@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

My first (minor) patch, hopefully this is correct.


Fix a typo in iwl-commands.h for CCK rates which needs 7 bits and not 4.

 Signed-off-by: Daniel Wu <dyqith@gmail.com>

---
 drivers/net/wireless/iwlwifi/iwl-commands.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h
b/drivers/net/wireless/iwlwifi/iwl-commands.h
index 56f9a24..6a2445d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -294,7 +294,7 @@ struct iwl3945_power_per_rate {
  *        0x3)  54 Mbps
  *
  * Legacy CCK rate format for bits 7:0 (bit 8 must be "0", bit 9 "1"):
- *  3-0:   10)  1 Mbps
+ *  6-0:   10)  1 Mbps
  *         20)  2 Mbps
  *         55)  5.5 Mbps
  *        110)  11 Mbps
-- 
1.5.4.3
