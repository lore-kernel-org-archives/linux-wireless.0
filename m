Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fe0.bluebottle.com ([206.188.25.21]:34819 "EHLO
	fe0.bluebottle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754784Ab0IMIlz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Sep 2010 04:41:55 -0400
Date: Mon, 13 Sep 2010 10:09:17 +0200
From: Bastian Bittorf <bittorf@bluebottle.com>
To: mailinglist <openwrt-devel@lists.openwrt.org>
Cc: mailinglist <linux-wireless@vger.kernel.org>
Subject: mac80211 / ath9k / multicast-rate / ibss / adhoc / mesh
Message-ID: <20100913080916.GA19477@alix.olsr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

At the moment it is IMHO not possible to enforce
a multicast-rateset or even a simple fixed multicast-rate
with mac80211. So it is nearly impossible to build
a working mesh-network (olsr/batman) with mac80211 based
wifi-drivers. (because all protocols use packetloss
as index for link-cost/etx, but it has to be measured
the same way in the hole network, not with changing
rates...)

http://www.spinics.net/lists/linux-wireless/msg49049.html

When can we expect some work on "mrate" for mac80211?
Should i open a bounty somewhere?

bye, Bastian / weimarnetz.de
