Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:55798 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750743Ab0AQAtH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 Jan 2010 19:49:07 -0500
Message-Id: <20100117004754.624627000@sipsolutions.net>
Date: Sun, 17 Jan 2010 01:47:54 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 0/5] mac80211 re-transmission repair
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I sent this series a long time ago as RFC and have
been running it ever since ... never totally confirmed
it works correctly but at this point it's probably
good enough for wider deployment.

Basically it revamps some tx handling so we can do
encryption and other stuff separate from each other
for re-transmissions with frames that a device has
rejected because the destination station was asleep.

johannes
