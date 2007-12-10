Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:45595 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753403AbXLJRWE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2007 12:22:04 -0500
In-Reply-To: <libertas-12345@shinybook.infradead.org>
To: John Linville <linville@tuxdriver.com>
Cc: Dan Williams <dcbw@redhat.com>, libertas-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org
From: David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH 04/48] libertas: select WIRELESS_EXT
Message-Id: <E1J1kp8-0006kR-AO@shinybook.infradead.org> (sfid-20071210_172207_519849_E615B433)
Date: Mon, 10 Dec 2007 10:45:38 -0500
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Dan Williams <dcbw@redhat.com>
Date: Tue, 4 Dec 2007 12:17:54 -0500

Signed-off-by: Dan Williams <dcbw@redhat.com>
Signed-off-by: David Woodhouse <dwmw2@infradead.org>
---
 drivers/net/wireless/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/Kconfig b/drivers/net/wireless/Kconfig
index 2b733c5..5583719 100644
--- a/drivers/net/wireless/Kconfig
+++ b/drivers/net/wireless/Kconfig
@@ -264,6 +264,7 @@ config IPW2200_DEBUG
 config LIBERTAS
 	tristate "Marvell 8xxx Libertas WLAN driver support"
 	depends on WLAN_80211
+	select WIRELESS_EXT
 	select IEEE80211
 	select FW_LOADER
 	---help---
-- 
1.5.3.4

