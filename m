Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:47461 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750761AbZEBEjc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 May 2009 00:39:32 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 0/2] cfg80211: add debugfs
Date: Sat,  2 May 2009 00:39:28 -0400
Message-Id: <1241239170-11443-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

While re-spinning the HT bandwidth patches I decided its
best if the new entries were non-mac80211 specific so while
at it just moved the wiphy specific stuff to a cfg80211 debugfs.

Luis R. Rodriguez (2):
  mac80211/cfg80211: move wiphy specific debugfs entries to cfg80211
  cfg80211: add debugfs HT40 allow map

 net/mac80211/debugfs.c     |   16 -----
 net/mac80211/ieee80211_i.h |    4 -
 net/wireless/Kconfig       |    8 +++
 net/wireless/Makefile      |    1 +
 net/wireless/core.c        |    5 ++
 net/wireless/core.h        |   12 ++++
 net/wireless/debugfs.c     |  131 ++++++++++++++++++++++++++++++++++++++++++++
 net/wireless/debugfs.h     |   14 +++++
 8 files changed, 171 insertions(+), 20 deletions(-)
 create mode 100644 net/wireless/debugfs.c
 create mode 100644 net/wireless/debugfs.h

