Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47310 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932165Ab0JDTTk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Oct 2010 15:19:40 -0400
Message-Id: <20101004191402.183055479@sipsolutions.net>
Date: Mon, 04 Oct 2010 21:14:02 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: [PATCH 0/4] nl80211 cleanups
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patchset adds some new hooks to generic
netlink and then goes on to use them to really
optimise a lot of locking code in nl80211.

It not only shrinks the code in nl80211 by     
almost 5K .text, but also greatly reduces the
likelihood of future errors.

I'd prefer to merge this through John's wireless
tree, so it'd be nice to get ACKs.            

johannes

