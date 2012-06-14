Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:1848 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753972Ab2FNMQp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jun 2012 08:16:45 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH] brcm80211: add mailing list address for brcm80211
 drivers
Date: Thu, 14 Jun 2012 14:16:27 +0200
Message-ID: <1339676187-6945-1-git-send-email-arend@broadcom.com> (sfid-20120614_141647_839746_EF02D773)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Added the mailing list address brcm80211-dev-list@broadcom.com
which can be used to report issues and in bug reports.

Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 3075a2a..fe6dd3d 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1595,6 +1595,7 @@ M:	Arend van Spriel <arend@broadcom.com>
 M:	Franky (Zhenhui) Lin <frankyl@broadcom.com>
 M:	Kan Yan	<kanyan@broadcom.com>
 L:	linux-wireless@vger.kernel.org
+L:	brcm80211-dev-list@broadcom.com
 S:	Supported
 F:	drivers/net/wireless/brcm80211/
 
-- 
1.7.9.5


