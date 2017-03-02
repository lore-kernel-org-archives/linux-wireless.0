Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:47716 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754185AbdCBJBi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 2 Mar 2017 04:01:38 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211_hwsim: fix command documentation indentation
Date: Thu,  2 Mar 2017 09:39:56 +0100
Message-Id: <20170302083956.14041-1-johannes@sipsolutions.net> (sfid-20170302_100542_555933_5577F93F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/mac80211_hwsim.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.h b/drivers/net/wireless/mac80211_hwsim.h
index 39f22467ca2a..3f5eda591dba 100644
--- a/drivers/net/wireless/mac80211_hwsim.h
+++ b/drivers/net/wireless/mac80211_hwsim.h
@@ -57,12 +57,12 @@ enum hwsim_tx_control_flags {
  * @HWSIM_CMD_REGISTER: request to register and received all broadcasted
  *	frames by any mac80211_hwsim radio device.
  * @HWSIM_CMD_FRAME: send/receive a broadcasted frame from/to kernel/user
- * space, uses:
+ *	space, uses:
  *	%HWSIM_ATTR_ADDR_TRANSMITTER, %HWSIM_ATTR_ADDR_RECEIVER,
  *	%HWSIM_ATTR_FRAME, %HWSIM_ATTR_FLAGS, %HWSIM_ATTR_RX_RATE,
  *	%HWSIM_ATTR_SIGNAL, %HWSIM_ATTR_COOKIE, %HWSIM_ATTR_FREQ (optional)
  * @HWSIM_CMD_TX_INFO_FRAME: Transmission info report from user space to
- * kernel, uses:
+ *	kernel, uses:
  *	%HWSIM_ATTR_ADDR_TRANSMITTER, %HWSIM_ATTR_FLAGS,
  *	%HWSIM_ATTR_TX_INFO, %HWSIM_ATTR_SIGNAL, %HWSIM_ATTR_COOKIE
  * @HWSIM_CMD_NEW_RADIO: create a new radio with the given parameters,
-- 
2.11.0
