Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh01.mail.saunalahti.fi ([62.142.5.107]:42576 "EHLO
	emh01.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751213AbaAJQZn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Jan 2014 11:25:43 -0500
From: Luciano Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH IW] util: parse NL80211_CMD_CHANNEL_SWITCH
Date: Fri, 10 Jan 2014 18:25:37 +0200
Message-Id: <1389371137-30282-1-git-send-email-luca@coelho.fi> (sfid-20140110_172546_697804_29522EF2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

Add the NL80211_CMD_CHANNEL_SWITCH definition to the nl80211 commands
array so that it prints out something useful in the phy info.

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
---
 util.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/util.c b/util.c
index 4542749..3233743 100644
--- a/util.c
+++ b/util.c
@@ -248,6 +248,7 @@ static const char *commands[NL80211_CMD_MAX + 1] = {
 	[NL80211_CMD_FT_EVENT] = "ft_event",
 	[NL80211_CMD_CRIT_PROTOCOL_START] = "crit_protocol_start",
 	[NL80211_CMD_CRIT_PROTOCOL_STOP] = "crit_protocol_stop",
+	[NL80211_CMD_CHANNEL_SWITCH] = "channel_switch",
 };
 
 static char cmdbuf[100];
-- 
1.8.5.2

