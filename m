Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:36157 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751908AbYIJWQL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Sep 2008 18:16:11 -0400
Message-Id: <20080910220145.707263000@sipsolutions.net> (sfid-20080911_001619_033062_98BAB5F3)
Date: Thu, 11 Sep 2008 00:01:45 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 00/18] mac80211 cleanups and fixes
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Here's another series to clean up a bit including a few things that
I've been meaning to do for a long time:

 * mac80211: move ieee80211_set_freq to utils
 * mac80211: make bridge_packets a virtual interface option
 * mac80211: clean up some comments
 * mac80211: inform driver of basic rateset
 * mac80211: use nl80211 interface types

I'd been talking with Sujith about this one:

 * mac80211: share STA information with driver

and decided to just do it; as it stands it's not very useful
but I expect it to be used soon, if not we can remove the
EXPORT_SYMBOL again.

johannes

