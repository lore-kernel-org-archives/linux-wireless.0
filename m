Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60146 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752159Ab2CHODN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Mar 2012 09:03:13 -0500
Message-Id: <20120308140202.751490800@sipsolutions.net> (sfid-20120308_150316_909330_716A6FD8)
Date: Thu, 08 Mar 2012 15:02:02 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 0/6] mac80211 MLME cleanups & a fix
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Here are a few cleanups, and a fix, for the mac80211
MLME code. The fix helps getting the control bitrates
correct during association, but otherwise shouldn't
really do much so I decided to not send it to stable.

johannes

