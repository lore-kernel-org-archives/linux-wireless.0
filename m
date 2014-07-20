Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailrelay004.isp.belgacom.be ([195.238.6.170]:37955 "EHLO
	mailrelay004.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752849AbaGTO0k (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Jul 2014 10:26:40 -0400
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: davem@davemloft.net, joe@perches.com,
	Fabian Frederick <fabf@skynet.be>,
	Solomon Peachy <pizza@shaftnet.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 12/30] cw1200: remove unnecessary break after return
Date: Sun, 20 Jul 2014 16:25:13 +0200
Message-Id: <1405866332-24652-3-git-send-email-fabf@skynet.be> (sfid-20140720_163319_320152_139BD69F)
In-Reply-To: <1405866332-24652-1-git-send-email-fabf@skynet.be>
References: <1405866332-24652-1-git-send-email-fabf@skynet.be>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/net/wireless/cw1200/fwio.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/cw1200/fwio.c b/drivers/net/wireless/cw1200/fwio.c
index e23d67e..6f1b9aa 100644
--- a/drivers/net/wireless/cw1200/fwio.c
+++ b/drivers/net/wireless/cw1200/fwio.c
@@ -290,7 +290,6 @@ static int config_reg_write(struct cw1200_common *priv, u32 val)
 	case HIF_8601_SILICON:
 	default:
 		return cw1200_reg_write_32(priv, ST90TDS_CONFIG_REG_ID, val);
-		break;
 	}
 	return 0;
 }
-- 
1.9.1

