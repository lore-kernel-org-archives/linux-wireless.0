Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:10864 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754253AbZIAPWu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Sep 2009 11:22:50 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 01 Sep 2009 08:22:53 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 4/7] wireless: update reg debug kconfig entry
Date: Tue, 1 Sep 2009 08:22:43 -0700
Message-ID: <1251818566-9264-5-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1251818566-9264-1-git-send-email-lrodriguez@atheros.com>
References: <1251818566-9264-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Refer to the wireless wiki for more information.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 net/wireless/Kconfig |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/net/wireless/Kconfig b/net/wireless/Kconfig
index 9fd570b..08f6733 100644
--- a/net/wireless/Kconfig
+++ b/net/wireless/Kconfig
@@ -49,6 +49,10 @@ config CFG80211_REG_DEBUG
 	default n
 	---help---
 	  You can enable this if you want to debug regulatory changes.
+	  For more information on cfg80211 regulatory refer to the wireless
+	  wiki:
+
+	  http://wireless.kernel.org/en/developers/Regulatory
 
 	  If unsure, say N.
 
-- 
1.6.3.3

