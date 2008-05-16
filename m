Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:53147 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756442AbYEPXD5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 May 2008 19:03:57 -0400
Message-Id: <20080516225712.794319000@sipsolutions.net> (sfid-20080517_010406_688360_A94C84DB)
Date: Sat, 17 May 2008 00:57:12 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
	Ron Rindjunksi <ron.rindjunski@intel.com>
Subject: [PATCH 0/2] mac80211: use multiqueue netdev
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch (well, there are two, but the first one is just some
sanity checking) converts mac80211 to use a multiqueue netdev.

The next step will be to re-do fragmentation taking into account
proper A-MPDU handling etc. but I would love to have Ron look over
that too since he's much more familiar with the A-MPDU stuff.

johannes

