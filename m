Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailrelay004.isp.belgacom.be ([195.238.6.170]:37955 "EHLO
	mailrelay004.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752839AbaGTO0h (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Jul 2014 10:26:37 -0400
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: davem@davemloft.net, joe@perches.com,
	Fabian Frederick <fabf@skynet.be>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 11/30] prism54: remove unnecessary break after return
Date: Sun, 20 Jul 2014 16:25:12 +0200
Message-Id: <1405866332-24652-2-git-send-email-fabf@skynet.be> (sfid-20140720_162649_069658_52FAB1AB)
In-Reply-To: <1405866332-24652-1-git-send-email-fabf@skynet.be>
References: <1405866332-24652-1-git-send-email-fabf@skynet.be>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/net/wireless/prism54/oid_mgt.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/prism54/oid_mgt.c b/drivers/net/wireless/prism54/oid_mgt.c
index 47b34bf..3a8d2db 100644
--- a/drivers/net/wireless/prism54/oid_mgt.c
+++ b/drivers/net/wireless/prism54/oid_mgt.c
@@ -793,7 +793,6 @@ mgt_response_to_str(enum oid_num_t n, union oid_res_t *r, char *str)
 	switch (isl_oid[n].flags & OID_FLAG_TYPE) {
 	case OID_TYPE_U32:
 		return snprintf(str, PRIV_STR_SIZE, "%u\n", r->u);
-		break;
 	case OID_TYPE_BUFFER:{
 			struct obj_buffer *buff = r->ptr;
 			return snprintf(str, PRIV_STR_SIZE,
-- 
1.9.1

