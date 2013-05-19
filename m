Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f172.google.com ([209.85.214.172]:53423 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751347Ab3ESQoP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 May 2013 12:44:15 -0400
Received: by mail-ob0-f172.google.com with SMTP id tb18so6355798obb.31
        for <linux-wireless@vger.kernel.org>; Sun, 19 May 2013 09:44:14 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: mcgrof@kernel.org
Cc: linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH 2/2] backports: defconfig for rtlwifi family
Date: Sun, 19 May 2013 11:43:56 -0500
Message-Id: <1368981836-6247-2-git-send-email-Larry.Finger@lwfinger.net> (sfid-20130519_184419_068568_3D5CCDF9)
In-Reply-To: <1368981836-6247-1-git-send-email-Larry.Finger@lwfinger.net>
References: <1368981836-6247-1-git-send-email-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

V2 in proper format for git repo

Larry

 backport/defconfigs/rtlwifi | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)
 create mode 100644 backport/defconfigs/rtlwifi

diff --git a/backport/defconfigs/rtlwifi b/backport/defconfigs/rtlwifi
new file mode 100644
index 0000000..c86d000
--- /dev/null
+++ b/backport/defconfigs/rtlwifi
@@ -0,0 +1,19 @@
+CPTCFG_CFG80211=m
+CPTCFG_CFG80211_DEFAULT_PS=y
+CPTCFG_CFG80211_DEBUGFS=y
+CPTCFG_MAC80211=m
+# CPTCFG_MAC80211_RC_PID is not set
+# CPTCFG_MAC80211_RC_MINSTREL is not set
+# CPTCFG_MAC80211_RC_DEFAULT_MINSTREL is not set
+CPTCFG_MAC80211_DEBUGFS=y
+CPTCFG_MAC80211_MESSAGE_TRACING=y
+CPTCFG_WLAN=y
+CPTCFG_RTLWIFI=m
+CPTCFG_RTLWIFI_DEBUG=y
+CPTCFG_RTL8192CE=m
+CPTCFG_RTL8192SE=m
+CPTCFG_RTL8192DE=m
+CPTCFG_RTL8723AE=m
+CPTCFG_RTL8188EE=m
+CPTCFG_RTL8192CU=m
+CPTCFG_RTL8192C_COMMON=m
-- 
1.8.1.4

