Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sypressi.dnainternet.net ([83.102.40.135]:54219 "EHLO
	sypressi.dnainternet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751039AbZHMRjc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Aug 2009 13:39:32 -0400
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH] cfg80211: export cfg80211_wext_siwfreq
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Date: Thu, 13 Aug 2009 20:39:31 +0300
Message-ID: <20090813173931.5382.67689.stgit@fate.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

cfg80211_wext_siwfreq() should be exported with EXPORT_SYMBOL_GPL.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---

 net/wireless/wext-compat.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/net/wireless/wext-compat.c b/net/wireless/wext-compat.c
index c449174..c12029b 100644
--- a/net/wireless/wext-compat.c
+++ b/net/wireless/wext-compat.c
@@ -771,6 +771,7 @@ int cfg80211_wext_siwfreq(struct net_device *dev,
 		return err;
 	}
 }
+EXPORT_SYMBOL_GPL(cfg80211_wext_siwfreq);
 
 int cfg80211_wext_giwfreq(struct net_device *dev,
 			  struct iw_request_info *info,

