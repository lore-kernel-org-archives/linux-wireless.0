Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailrelay001.isp.belgacom.be ([195.238.6.51]:38526 "EHLO
	mailrelay001.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750705AbaJGUUb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Oct 2014 16:20:31 -0400
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>,
	"John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"David S. Miller" <davem@davemloft.net>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 1/1 net-next] net: rfkill: kernel-doc warning fixes
Date: Tue,  7 Oct 2014 22:20:23 +0200
Message-Id: <1412713224-5017-1-git-send-email-fabf@skynet.be> (sfid-20141007_222050_191454_1C7FAA24)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

s/state/blocked

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 net/rfkill/core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/rfkill/core.c b/net/rfkill/core.c
index b3b16c0..fa7cd79 100644
--- a/net/rfkill/core.c
+++ b/net/rfkill/core.c
@@ -329,7 +329,7 @@ static atomic_t rfkill_input_disabled = ATOMIC_INIT(0);
 /**
  * __rfkill_switch_all - Toggle state of all switches of given type
  * @type: type of interfaces to be affected
- * @state: the new state
+ * @blocked: the new state
  *
  * This function sets the state of all switches of given type,
  * unless a specific switch is claimed by userspace (in which case,
@@ -353,7 +353,7 @@ static void __rfkill_switch_all(const enum rfkill_type type, bool blocked)
 /**
  * rfkill_switch_all - Toggle state of all switches of given type
  * @type: type of interfaces to be affected
- * @state: the new state
+ * @blocked: the new state
  *
  * Acquires rfkill_global_mutex and calls __rfkill_switch_all(@type, @state).
  * Please refer to __rfkill_switch_all() for details.
-- 
1.9.3

