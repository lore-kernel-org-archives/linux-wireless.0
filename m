Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:32935 "EHLO
	mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751169AbcBKGrP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Feb 2016 01:47:15 -0500
Received: by mail-pf0-f194.google.com with SMTP id c10so2103132pfc.0
        for <linux-wireless@vger.kernel.org>; Wed, 10 Feb 2016 22:47:14 -0800 (PST)
From: Ujjal Roy <royujjal@gmail.com>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: Cathy Luo <cluo@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	WiFi Mailing List <linux-wireless@vger.kernel.org>
Subject: [PATCH 1/3] mwifiex: Fixed incorrect indentation issue
Date: Thu, 11 Feb 2016 12:17:07 +0530
Message-Id: <1455173229-6383-1-git-send-email-royujjal@gmail.com> (sfid-20160211_074725_535456_73EF4E8A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes the incorrect indentation of the case label.

Signed-off-by: Ujjal Roy <royujjal@gmail.com>
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

