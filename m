Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51631 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753519Ab1EDNjv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 May 2011 09:39:51 -0400
Message-Id: <20110504133727.971543681@sipsolutions.net> (sfid-20110504_153954_374674_305E0E95)
Date: Wed, 04 May 2011 15:37:27 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Eliad Peller <eliad@wizery.com>, linux-wireless@vger.kernel.org
Subject: [PATCH 0/2] basic wowlan support
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These two patches add basic WoWLAN support to
cfg80211 and mac80211.

I'm submitting these now so Eliad can continue
to build TI's functionality on it, I myself will
continue working on Intel's functionality (which
will require more mac80211/cfg80211 changes)

johannes

