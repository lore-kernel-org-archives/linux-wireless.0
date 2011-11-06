Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:40834 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752149Ab1KFNPL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Nov 2011 08:15:11 -0500
Message-Id: <20111106131332.746774119@sipsolutions.net> (sfid-20111106_142607_252645_C1E92698)
Date: Sun, 06 Nov 2011 14:13:32 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 0/2] use wifi TX socket option
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This makes nl80211 advertise and mac80211 support
the Wifi TX status socket option thing.

It depends on "net: add wireless TX status socket option"
that Dave said we can pick up through the wireless tree.

johannes

