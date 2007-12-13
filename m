Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:56938 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762791AbXLMG7c (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Dec 2007 01:59:32 -0500
Subject: [PATCH 69/48] libertas: fix case of FWT_ACCESS_LIST_ROUTE and FWT_ACCESS_LIST_NEIGHBOR commands
From: David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <libertas-12345@shinybook.infradead.org>
To: John Linville <linville@tuxdriver.com>
Cc: Dan Williams <dcbw@redhat.com>, libertas-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org
Message-Id: <E1J2i2r-0005sZ-BD@shinybook.infradead.org> (sfid-20071213_070632_721547_B2F794E9)
Date: Thu, 13 Dec 2007 01:59:45 -0500
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Dan Williams <dcbw@redhat.com>
Date: Tue, 11 Dec 2007 15:29:10 -0500

Signed-off-by: Dan Williams <dcbw@redhat.com>
Signed-off-by: David Woodhouse <dwmw2@infradead.org>
---
 drivers/net/wireless/libertas/host.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/libertas/host.h b/drivers/net/wireless/libertas/host.h
index b23af19..cc5f9bf 100644
--- a/drivers/net/wireless/libertas/host.h
+++ b/drivers/net/wireless/libertas/host.h
@@ -247,8 +247,8 @@ enum cmd_fwt_access_opts {
 	CMD_ACT_FWT_ACCESS_DEL,
 	CMD_ACT_FWT_ACCESS_LOOKUP,
 	CMD_ACT_FWT_ACCESS_LIST,
-	CMD_ACT_FWT_ACCESS_LIST_route,
-	CMD_ACT_FWT_ACCESS_LIST_neighbor,
+	CMD_ACT_FWT_ACCESS_LIST_ROUTE,
+	CMD_ACT_FWT_ACCESS_LIST_NEIGHBOR,
 	CMD_ACT_FWT_ACCESS_RESET,
 	CMD_ACT_FWT_ACCESS_CLEANUP,
 	CMD_ACT_FWT_ACCESS_TIME,
-- 
1.5.3.4

