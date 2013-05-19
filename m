Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:18634 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750752Ab3ESQPh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 May 2013 12:15:37 -0400
Date: Sun, 19 May 2013 11:15:35 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: mcgrof@kernel.org
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] backports: defconfig for rtlwifi family
Message-ID: <5198faa7.6Rdk71fUsIaf677u%Larry.Finger@lwfinger.net> (sfid-20130519_181540_626570_A09FF5B8)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>

Index: backports-3.10-rc1-1/defconfigs/rtlwifi
===================================================================
--- /dev/null
+++ backports-3.10-rc1-1/defconfigs/rtlwifi
@@ -0,0 +1,20 @@
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
+
