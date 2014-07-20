Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailrelay004.isp.belgacom.be ([195.238.6.170]:37955 "EHLO
	mailrelay004.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753157AbaGTO0p (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Jul 2014 10:26:45 -0400
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: davem@davemloft.net, joe@perches.com,
	Fabian Frederick <fabf@skynet.be>,
	Christian Lamparter <chunkeey@googlemail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 15/30] carl9170: remove unnecessary break after return
Date: Sun, 20 Jul 2014 16:25:16 +0200
Message-Id: <1405866332-24652-6-git-send-email-fabf@skynet.be> (sfid-20140720_162828_939049_F2E6BDF2)
In-Reply-To: <1405866332-24652-1-git-send-email-fabf@skynet.be>
References: <1405866332-24652-1-git-send-email-fabf@skynet.be>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/net/wireless/ath/carl9170/phy.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/ath/carl9170/phy.c b/drivers/net/wireless/ath/carl9170/phy.c
index ab4ee7d..b80b213 100644
--- a/drivers/net/wireless/ath/carl9170/phy.c
+++ b/drivers/net/wireless/ath/carl9170/phy.c
@@ -1139,7 +1139,6 @@ static int carl9170_set_freq_cal_data(struct ar9170 *ar,
 
 	default:
 		return -EINVAL;
-		break;
 	}
 
 	for (; i >= 0; i--) {
-- 
1.9.1

