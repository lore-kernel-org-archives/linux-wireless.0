Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:34001 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901AbcBXTTd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Feb 2016 14:19:33 -0500
Received: by mail-pa0-f44.google.com with SMTP id fy10so17578419pac.1
        for <linux-wireless@vger.kernel.org>; Wed, 24 Feb 2016 11:19:33 -0800 (PST)
From: UJJAL ROY <royujjal@gmail.com>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: Cathy Luo <cluo@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	WiFi Mailing List <linux-wireless@vger.kernel.org>
Subject: [PATCH 1/3] mwifiex: Fixed incorrect indentation issue
Date: Thu, 25 Feb 2016 00:49:23 +0530
Message-Id: <1456341563-375-1-git-send-email-royujjal@gmail.com> (sfid-20160224_201937_626445_5F80AAB4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes the incorrect indentation of the case label.

Signed-off-by: UJJAL ROY <royujjal@gmail.com>
---
 drivers/net/wireless/marvell/mwifiex/cfg80211.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/cfg80211.c b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
index e7adef7..cb0cf03 100644
--- a/drivers/net/wireless/marvell/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
@@ -676,7 +676,7 @@ mwifiex_cfg80211_set_wiphy_params(struct wiphy *wiphy, u32 changed)
 		}
 		break;

-		case MWIFIEX_BSS_ROLE_STA:
+	case MWIFIEX_BSS_ROLE_STA:
 		if (priv->media_connected) {
 			mwifiex_dbg(adapter, ERROR,
 				    "cannot change wiphy params when connected");
--
1.9.1

