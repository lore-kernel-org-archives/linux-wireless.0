Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.26]:60567 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750801Ab0BQSPd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Feb 2010 13:15:33 -0500
Received: by qw-out-2122.google.com with SMTP id 3so65668qwe.37
        for <linux-wireless@vger.kernel.org>; Wed, 17 Feb 2010 10:15:32 -0800 (PST)
MIME-Version: 1.0
Date: Wed, 17 Feb 2010 19:15:31 +0100
Message-ID: <c2673ca61002171015j375922c0y4c7f61c3d3322bab@mail.gmail.com>
Subject: [PATCH] v2: rtl8187: micro cleanup
From: okias <d.okias@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, herton@mandriva.com.br,
	htl10@users.sourceforge.net, Larry.Finger@lwfinger.net
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From 3f02b3ec0c3e6d7fa0599de12af0b76150854b94 Mon Sep 17 00:00:00 2001
From: David Heidelberger <d.okias@gmail.com>
Date: Wed, 17 Feb 2010 19:13:46 +0100
Subject: [PATCH] rtl8187: micro cleanup

---
 drivers/net/wireless/rtl818x/rtl8187_dev.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rtl818x/rtl8187_dev.c
b/drivers/net/wireless/rtl818x/rtl8187_dev.c
index 7ba3052..2fe0c84 100644
--- a/drivers/net/wireless/rtl818x/rtl8187_dev.c
+++ b/drivers/net/wireless/rtl818x/rtl8187_dev.c
@@ -1175,8 +1175,6 @@ static void rtl8187_bss_info_changed(struct
ieee80211_hw *dev,

 		if (priv->is_rtl8187b)
 			reg = RTL818X_MSR_ENEDCA;
-		else
-			reg = 0;

 		if (is_valid_ether_addr(info->bssid)) {
 			reg |= RTL818X_MSR_INFRA;
-- 
1.7.0



-- 
Jabber/XMPP: okias@isgeek.info
SIP VoIP: sip:17474537254@proxy01.sipphone.com
