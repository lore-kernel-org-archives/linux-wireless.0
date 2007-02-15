Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:43659 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965736AbXBOO75 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Feb 2007 09:59:57 -0500
Message-Id: <20070215144241.847938000@sipsolutions.net>
Date: Thu, 15 Feb 2007 15:42:41 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: John Linville <linville@tuxdriver.com>, Jiri Benc <jbenc@suse.cz>
Subject: [PATCH 00/10] cfg80211 updates
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series updates/changes cfg80211 and associated things a
lot and finally introduces the wiphy stuff we've talked about
a long time ago. Also a number of bugfixes.

It's not perfect, it seems to for example that bcm43xx's debugfs
stuff doesn't work afterwards (but I haven't checked if it worked
before and I think it may be broken before too). Also, the wiphy
concept patch contains a few notes.

I'd like to ask that you merge it anyway, it's getting unwieldy
to maintain it as-is because there are quite large interdependencies
here. Besides, until the code is in the tree nobody apparently
bothers looking at it, only after they complain...

johannes

