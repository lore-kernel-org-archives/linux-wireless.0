Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:59433 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750767Ab3BOMLJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Feb 2013 07:11:09 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1U6K89-0000lS-DV
	for linux-wireless@vger.kernel.org; Fri, 15 Feb 2013 13:11:05 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [RFC/RFT v2 0/4] cfg80211: better station change handling
Date: Fri, 15 Feb 2013 13:10:57 +0100
Message-Id: <1360930261-30265-1-git-send-email-johannes@sipsolutions.net> (sfid-20130215_131119_076683_4BAE0736)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In addition to the previous version, now TDLS stations are checked
according to their state (setup or active). This should clarify
the possible actions in setup/active state.

The code is also in my mac80211-next/wip branch, I've only tested
station and AP mode. I don't think IBSS changed, but I'm less sure
about TDLS and mesh, so I'd appreciate someone else testing that.

johannes

