Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sirokuusama.dnainternet.net ([83.102.40.133]:34524 "EHLO
	sirokuusama.dnainternet.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751799Ab0LUUob (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Dec 2010 15:44:31 -0500
Subject: [PATCH 4/7] rndis_wlan: constify rndis_config_ops
To: "John W. Linville" <linville@tuxdriver.com>
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 21 Dec 2010 22:44:27 +0200
Message-ID: <20101221204427.12250.94921.stgit@fate.lan>
In-Reply-To: <20101221204405.12250.35410.stgit@fate.lan>
References: <20101221204405.12250.35410.stgit@fate.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 drivers/net/wireless/rndis_wlan.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rndis_wlan.c b/drivers/net/wireless/rndis_wlan.c
index 42e19e8..d0992fc 100644
--- a/drivers/net/wireless/rndis_wlan.c
+++ b/drivers/net/wireless/rndis_wlan.c
@@ -570,7 +570,7 @@ static int rndis_del_pmksa(struct wiphy *wiphy, struct net_device *netdev,
 
 static int rndis_flush_pmksa(struct wiphy *wiphy, struct net_device *netdev);
 
-static struct cfg80211_ops rndis_config_ops = {
+static const struct cfg80211_ops rndis_config_ops = {
 	.change_virtual_intf = rndis_change_virtual_intf,
 	.scan = rndis_scan,
 	.set_wiphy_params = rndis_set_wiphy_params,

