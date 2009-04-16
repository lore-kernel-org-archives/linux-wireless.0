Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:58780 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751671AbZDPLVI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Apr 2009 07:21:08 -0400
Message-Id: <20090416111723.904720021@sipsolutions.net> (sfid-20090416_132125_254048_AF093AFD)
Date: Thu, 16 Apr 2009 13:17:23 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 0/4] mac80211 powersave work
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is pretty much unchanged from my previous v2 RFCs,
except that I added a default of 500ms for the dynamic
powersave timer.

The fourth patch is new, it adds beacon filtering to
mac80211 -- for the reasons explained in that patch.

For 2.6.31, we should make MAC80211_DEFAULT_PS default
off instead. John, how do you want to handle that?

johannes

