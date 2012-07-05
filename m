Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45647 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754683Ab2GEIZC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Jul 2012 04:25:02 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 2/9] iwlwifi: bump trace message limit
Date: Thu,  5 Jul 2012 10:24:48 +0200
Message-Id: <1341476695-6889-3-git-send-email-johannes@sipsolutions.net> (sfid-20120705_102519_823912_B0B532C4)
In-Reply-To: <1341476695-6889-1-git-send-email-johannes@sipsolutions.net>
References: <1341476695-6889-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

There's one message that goes just over the
limit of 100 characters, so bump the limit to
110 to get rid of the warning from that.

Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-devtrace.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-devtrace.h b/drivers/net/wireless/iwlwifi/iwl-devtrace.h
index 6536479..ad2dba8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-devtrace.h
+++ b/drivers/net/wireless/iwlwifi/iwl-devtrace.h
@@ -176,7 +176,7 @@ TRACE_EVENT(iwlwifi_dev_ucode_wrap_event,
 #undef TRACE_SYSTEM
 #define TRACE_SYSTEM iwlwifi_msg
 
-#define MAX_MSG_LEN	100
+#define MAX_MSG_LEN	110
 
 DECLARE_EVENT_CLASS(iwlwifi_msg_event,
 	TP_PROTO(struct va_format *vaf),
-- 
1.7.10

