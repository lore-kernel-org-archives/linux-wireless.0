Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:44783 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752533AbZDBSIP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Apr 2009 14:08:15 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH v4 0/3] Beacon regulatory hint events
Date: Thu,  2 Apr 2009 14:08:06 -0400
Message-Id: <1238695689-15323-1-git-send-email-lrodriguez@atheros.com> (sfid-20090402_200820_562110_9E7DB561)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Few fixes and finally the last series for the beacon regulatory hint
events.

Luis R. Rodriguez (3):
  cfg80211: respect API on orig_flags on channel for beacon hint
  cfg80211: add netlink channel put helper
  cfg80211: send regulatory beacon hint events to userspace

 include/linux/nl80211.h |   34 +++++++++++++++++-
 net/wireless/nl80211.c  |   93 ++++++++++++++++++++++++++++++++++++++++-------
 net/wireless/nl80211.h  |    4 ++
 net/wireless/reg.c      |   34 +++++++++--------
 4 files changed, 135 insertions(+), 30 deletions(-)

