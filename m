Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:20451 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752605AbcDUPIz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Apr 2016 11:08:55 -0400
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Wei-Ning Huang <wnhuang@chromium.org>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH 1/3] mwifiex: fix coding style
Date: Thu, 21 Apr 2016 08:07:54 -0700
Message-ID: <1461251276-14891-1-git-send-email-akarwar@marvell.com> (sfid-20160421_170911_853576_33AC0F9B)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Redundant space in case statement is removed.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/cfg80211.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/cfg80211.c b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
index 6db202f..369ea06 100644
--- a/drivers/net/wireless/marvell/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
@@ -3388,7 +3388,7 @@ static int mwifiex_cfg80211_resume(struct wiphy *wiphy)
 		break;
 	case CONTROL_FRAME_MATCHED:
 		break;
-	case	MANAGEMENT_FRAME_MATCHED:
+	case MANAGEMENT_FRAME_MATCHED:
 		break;
 	case GTK_REKEY_FAILURE:
 		if (wiphy->wowlan_config->gtk_rekey_failure)
-- 
1.8.1.4

