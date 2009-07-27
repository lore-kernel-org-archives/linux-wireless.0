Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:60483 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754642AbZG0XwO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jul 2009 19:52:14 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 27 Jul 2009 16:52:15 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH] ath: depend on cfg80211
Date: Mon, 27 Jul 2009 16:52:06 -0700
Message-ID: <1248738730-4003-2-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1248738730-4003-1-git-send-email-lrodriguez@atheros.com>
References: <1248738730-4003-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The ath.ko module itself depends on cfg80211

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/Kconfig b/drivers/net/wireless/ath/Kconfig
index eb0337c..6bed009 100644
--- a/drivers/net/wireless/ath/Kconfig
+++ b/drivers/net/wireless/ath/Kconfig
@@ -1,6 +1,7 @@
 config ATH_COMMON
 	tristate "Atheros Wireless Cards"
 	depends on WLAN_80211
+	depends on CFG80211
 	depends on ATH5K || ATH9K || AR9170_USB
 
 source "drivers/net/wireless/ath/ath5k/Kconfig"
-- 
1.6.0.4

