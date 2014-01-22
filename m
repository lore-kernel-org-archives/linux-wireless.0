Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:40314 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754672AbaAVKfB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jan 2014 05:35:01 -0500
Received: by sipsolutions.net with esmtpa (Exim 4.82)
	(envelope-from <johannes@sipsolutions.net>)
	id 1W5v9A-00033q-FT
	for linux-wireless@vger.kernel.org; Wed, 22 Jan 2014 11:35:00 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 0/7] mac80211/cfg80211 constification, cleanups
Date: Wed, 22 Jan 2014 11:34:51 +0100
Message-Id: <1390386898-14316-1-git-send-email-johannes@sipsolutions.net> (sfid-20140122_113510_681620_15DC4FD7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is just random constification, the first goes through all
the drivers as well, everything else is just in mac80211.

