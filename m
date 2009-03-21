Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:60382 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753884AbZCUDxM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Mar 2009 23:53:12 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, Quentin@armitage.org.uk,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 0/5] cfg80211: few reg fixes and removes OLD_REG
Date: Fri, 20 Mar 2009 23:53:03 -0400
Message-Id: <1237607588-6316-1-git-send-email-lrodriguez@atheros.com> (sfid-20090321_045316_436771_A4A5D92C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

First two are bug fixes candidates for stable, the rest removes OLD_REG.

Luis R. Rodriguez (5):
  cfg80211: force last_request to be set for OLD_REG if regdom is EU
  cfg80211: fix incorrect assumption on last_request for 11d
  cfg80211: make regdom module parameter available oustide of OLD_REG
  cfg80211: remove code about country IE support with OLD_REG
  cfg80211: remove CONFIG_WIRELESS_OLD_REGULATORY

 Documentation/feature-removal-schedule.txt |   34 +++--
 net/wireless/Kconfig                       |   33 -----
 net/wireless/nl80211.c                     |    6 -
 net/wireless/reg.c                         |  187 ++++------------------------
 4 files changed, 46 insertions(+), 214 deletions(-)

