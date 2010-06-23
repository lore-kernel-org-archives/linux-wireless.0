Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:56343 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753176Ab0FWOpP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Jun 2010 10:45:15 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: dkiran@marvell.com, Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 3/3] libertas: mark lbs_ret_802_11d_domain_info static
Date: Wed, 23 Jun 2010 10:37:26 -0400
Message-Id: <1277303846-17257-3-git-send-email-linville@tuxdriver.com>
In-Reply-To: <1277281556.3642.6.camel@jlt3.sipsolutions.net>
References: <1277281556.3642.6.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Probably little risk of namespace polution, but good practice... :-)

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/libertas/cmdresp.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/libertas/cmdresp.c b/drivers/net/wireless/libertas/cmdresp.c
index b4bc103..a0d9482 100644
--- a/drivers/net/wireless/libertas/cmdresp.c
+++ b/drivers/net/wireless/libertas/cmdresp.c
@@ -103,7 +103,7 @@ static int lbs_ret_reg_access(struct lbs_private *priv,
  *  @param resp    pointer to command response buffer
  *  @return        0; -1
  */
-int lbs_ret_802_11d_domain_info(struct cmd_ds_command *resp)
+static int lbs_ret_802_11d_domain_info(struct cmd_ds_command *resp)
 {
 	struct cmd_ds_802_11d_domain_info *domaininfo =
 			&resp->params.domaininforesp;
-- 
1.7.0.1

