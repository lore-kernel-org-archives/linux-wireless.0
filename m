Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailrelay006.isp.belgacom.be ([195.238.6.172]:60258 "EHLO
	mailrelay006.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756613AbaGNQcW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Jul 2014 12:32:22 -0400
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: davem@davemloft.net, joe@perches.com,
	Fabian Frederick <fabf@skynet.be>,
	Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 08/16] mac80211: remove unnecessary break after return
Date: Mon, 14 Jul 2014 18:30:58 +0200
Message-Id: <1405355467-7350-9-git-send-email-fabf@skynet.be> (sfid-20140714_183357_331078_B9B6DAD8)
In-Reply-To: <1405355467-7350-1-git-send-email-fabf@skynet.be>
References: <1405355467-7350-1-git-send-email-fabf@skynet.be>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 net/mac80211/mesh_hwmp.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
index 94758b9..214e63b 100644
--- a/net/mac80211/mesh_hwmp.c
+++ b/net/mac80211/mesh_hwmp.c
@@ -157,7 +157,6 @@ static int mesh_path_sel_frame_tx(enum mpath_frame_type action, u8 flags,
 	default:
 		kfree_skb(skb);
 		return -ENOTSUPP;
-		break;
 	}
 	*pos++ = ie_len;
 	*pos++ = flags;
-- 
1.8.4.5

