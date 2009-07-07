Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:48047 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755782AbZGGCAF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jul 2009 22:00:05 -0400
Message-Id: <20090707015604.369008211@sipsolutions.net>
Date: Tue, 07 Jul 2009 03:56:04 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 0/9] cfg80211 fixes, cleanups, improvements
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This has a whole bunch of cfg80211 fixes, most
notably work to actually do locking in cfg80211
properly! Sorry, my head was too small to grasp
all of that in cfg80211 at once, so I deferred
locking for the connect() API to this series.

johannes

