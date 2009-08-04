Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:58263 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933572AbZHDX2W (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Aug 2009 19:28:22 -0400
Received: by bwz19 with SMTP id 19so3380127bwz.37
        for <linux-wireless@vger.kernel.org>; Tue, 04 Aug 2009 16:28:22 -0700 (PDT)
Message-ID: <4A78C414.7060708@gmail.com>
Date: Wed, 05 Aug 2009 01:28:20 +0200
From: =?UTF-8?B?R8OhYm9yIFN0ZWZhbmlr?= <netrolller.3d@gmail.com>
MIME-Version: 1.0
To: John Linville <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>
CC: Larry Finger <Larry.Finger@lwfinger.net>,
	Broadcom Wireless <bcm43xx-dev@lists.berlios.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: [PATCH] b43: Fix fallout from the IEEE80211_IF_TYPE to NL80211_IFTYPE
 change.
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Update a comment that still says IEEE80211_IF_TYPE instead of NL80211_IFTYPE.

Signed-off-by: Gábor Stefanik <netrolller.3d@gmail.com>
---
This patch replaces "b43: Typo fixes and minor cleanup",
the other half of which has been integrated into the LP rev01 init patch.

 drivers/net/wireless/b43/b43.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/b43/b43.h b/drivers/net/wireless/b43/b43.h
index 41ca727..52fd6d6 100644
--- a/drivers/net/wireless/b43/b43.h
+++ b/drivers/net/wireless/b43/b43.h
@@ -627,7 +627,7 @@ struct b43_wl {
 	u8 mac_addr[ETH_ALEN];
 	/* Current BSSID */
 	u8 bssid[ETH_ALEN];
-	/* Interface type. (IEEE80211_IF_TYPE_XXX) */
+	/* Interface type. (NL80211_IFTYPE_XXX) */
 	int if_type;
 	/* Is the card operating in AP, STA or IBSS mode? */
 	bool operating;
-- 
1.6.2.4



