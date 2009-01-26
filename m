Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:34402 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751957AbZAZSw2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Jan 2009 13:52:28 -0500
Message-Id: <20090126184740.036240879@sipsolutions.net> (sfid-20090126_195230_835849_C9DB9A02)
Date: Mon, 26 Jan 2009 19:47:40 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: mcgrof@gmail.com, Sujith.Manoharan@atheros.com, tomasw@gmail.com
Subject: [RFC/RFT 0/7] mac80211 aggregation cleanups/fixes
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Here are a few fixes/cleanups for aggregation, so far compile-tested
only. The first few should be good, but I would appreciate comments
and more testing. I'll test them tomorrow with Intel and hopefully
Atheros hw.

johannes

