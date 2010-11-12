Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from saarni.dnainternet.net ([83.102.40.136]:52798 "EHLO
	saarni.dnainternet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751297Ab0KLGyB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Nov 2010 01:54:01 -0500
Subject: [2.6.37 PATCH] cfg80211: fix WIPHY_FLAG_IBSS_RSN bit
To: "John W. Linville" <linville@tuxdriver.com>
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Date: Fri, 12 Nov 2010 08:53:56 +0200
Message-ID: <20101112065356.3307.26298.stgit@fate.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

WIPHY_FLAG_IBSS_RSN is BIT(7) as is WIPHY_FLAG_CONTROL_PORT_PROTOCOL. Change
to BIT(8).

Cc: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 include/net/cfg80211.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 2a7936d..97b8b7c 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1355,7 +1355,7 @@ enum wiphy_flags {
 	WIPHY_FLAG_4ADDR_AP			= BIT(5),
 	WIPHY_FLAG_4ADDR_STATION		= BIT(6),
 	WIPHY_FLAG_CONTROL_PORT_PROTOCOL	= BIT(7),
-	WIPHY_FLAG_IBSS_RSN			= BIT(7),
+	WIPHY_FLAG_IBSS_RSN			= BIT(8),
 };
 
 struct mac_address {

