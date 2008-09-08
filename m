Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:54510 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754048AbYIHPqA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Sep 2008 11:46:00 -0400
Message-Id: <20080908154421.216772000@sipsolutions.net> (sfid-20080908_174606_739824_DD7A31F6)
Date: Mon, 08 Sep 2008 17:44:21 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 0/8] mac80211 mlme cleanups
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mostly cleanups and moving code into two new files,
scan.c and ht.c. mlme.c and main.c each lose a few
hundred lines making them more maintainable.

johannes

