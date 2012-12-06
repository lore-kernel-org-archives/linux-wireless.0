Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53253 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946082Ab2LFQwm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Dec 2012 11:52:42 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1Tgegj-0001bW-4K
	for linux-wireless@vger.kernel.org; Thu, 06 Dec 2012 17:52:41 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [RFC 0/2] VHT regulatory
Date: Thu,  6 Dec 2012 17:53:02 +0100
Message-Id: <1354812784-15845-1-git-send-email-johannes@sipsolutions.net> (sfid-20121206_175311_266080_353FB395)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This allows wide bandwidth on the world roaming domain
(with a proposed change to the db.txt file parsing) and
enables (wide) bandwidth checking against the current
regulatory domain.

It's not entirely clear to me which regdom we should be
checking but I'm obviously not changing that logic, I'm
just not sure if wiphy->regd vs. cfg80211_regdomain is
handled correctly or what that even means ...

Also, if a driver has restrictions on VHT channel use,
say it doesn't allow arbitrary 80+80 MHz combinations,
I'm not sure how to handle that.

Thoughts? :-)

johannes

