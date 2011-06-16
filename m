Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:50351 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753627Ab1FPKbC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Jun 2011 06:31:02 -0400
Date: Thu, 16 Jun 2011 15:51:45 +0530
From: Yogesh Ashok Powar <yogeshp@marvell.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Andreas Hartmann <andihartmann@01019freenet.de>
Subject: [PATCH 0/2] mac80211: Fixing races for hw crypto skipping tailroom
Message-ID: <20110616102138.GA24447@hertz.marvell.com> (sfid-20110616_123106_891321_34C0B94E)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Yogesh Ashok Powar (2):
  Revert "Revert "mac80211: Skip tailroom reservation for full
    HW-crypto devices""
  mac80211: Fixing Races for skipping tailroom reservation

 net/mac80211/ieee80211_i.h |    7 ++++++
 net/mac80211/key.c         |   46 ++++++++++++++++++++++++++++++++++++++++++-
 net/mac80211/main.c        |    2 +
 net/mac80211/tx.c          |   13 ++++++-----
 4 files changed, 60 insertions(+), 8 deletions(-)

-- 
1.7.5.4

