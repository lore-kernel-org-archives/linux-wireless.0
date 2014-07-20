Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailrelay004.isp.belgacom.be ([195.238.6.170]:37955 "EHLO
	mailrelay004.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752955AbaGTO0m (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Jul 2014 10:26:42 -0400
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: davem@davemloft.net, joe@perches.com,
	Fabian Frederick <fabf@skynet.be>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 13/30] airo: remove unnecessary break after return
Date: Sun, 20 Jul 2014 16:25:14 +0200
Message-Id: <1405866332-24652-4-git-send-email-fabf@skynet.be> (sfid-20140720_163243_893811_34064F33)
In-Reply-To: <1405866332-24652-1-git-send-email-fabf@skynet.be>
References: <1405866332-24652-1-git-send-email-fabf@skynet.be>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/net/wireless/airo.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/airo.c b/drivers/net/wireless/airo.c
index 64747d4..c26359d 100644
--- a/drivers/net/wireless/airo.c
+++ b/drivers/net/wireless/airo.c
@@ -7817,7 +7817,6 @@ static int readrids(struct net_device *dev, aironet_ioctl *comp) {
 	case AIRORRID:      ridcode = comp->ridnum;     break;
 	default:
 		return -EINVAL;
-		break;
 	}
 
 	if ((iobuf = kmalloc(RIDSIZE, GFP_KERNEL)) == NULL)
-- 
1.9.1

