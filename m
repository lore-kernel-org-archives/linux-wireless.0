Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:35968 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754243AbZGATf3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jul 2009 15:35:29 -0400
Message-Id: <20090701192641.072258140@sipsolutions.net>
Date: Wed, 01 Jul 2009 21:26:41 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 00/20 v4] wireless patch dump
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since not all of my patches as previously sent out
still applied due to net-2.6 merge via 2.6.31-rc1,
here's a dump of all my patches.

It includes the connect() API, lots of wext removal
from mac80211, and does not break orinoco, iwm or
rndis. :)

johannes

