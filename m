Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:43475 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751742AbYIHPhO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Sep 2008 11:37:14 -0400
Message-Id: <20080908153336.891710000@sipsolutions.net> (sfid-20080908_173723_942748_9A87878D)
Date: Mon, 08 Sep 2008 17:33:36 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, tomasw@gmail.com
Subject: [PATCH 0/4] mac80211 disassociation fixes
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This contains the disassociation fixes from Tomas
(with rewritten changelogs to make the problems more
apparent) and an additional patch I made to stop the
queues to avoid the problem with spuriously reporting
that the AP is on an unauthorized port.

johannes

