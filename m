Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:46306 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758099Ab2JXKMu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Oct 2012 06:12:50 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1TQxxA-0000z3-O5
	for linux-wireless@vger.kernel.org; Wed, 24 Oct 2012 12:12:48 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 0/4] multi-channel/interface TX power handling
Date: Wed, 24 Oct 2012 12:13:19 +0200
Message-Id: <1351073603-11616-1-git-send-email-johannes@sipsolutions.net> (sfid-20121024_121257_970301_0698BEB6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This was the remaining work I had to do in mac80211, but it
got a little larger because cfg80211 wasn't doing per-vif
TX power ...

I disallowed setting TX power per hardware now, we could in
theory do something like set all interfaces in that case, but
it seemed like a lot of work for very little gain. If someone
needs it, we can do it later :-)

johannes

