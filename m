Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:48645 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932856Ab2FVNOr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jun 2012 09:14:47 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1Si3hG-0002Zz-9r
	for linux-wireless@vger.kernel.org; Fri, 22 Jun 2012 15:14:46 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: mac80211 logging/tracing
Date: Fri, 22 Jun 2012 15:14:36 +0200
Message-Id: <1340370882-9258-1-git-send-email-johannes@sipsolutions.net> (sfid-20120622_151451_174017_59F5F67A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

So ... pr_debug() was kinda a disaster, now we have to
enable both at runtime and at compile time. Use pr_info
instead but keep the compile time enablement -- if the
dynamic debug framework ever gets a "log module" kind
of functionality that would be worthwhile here I guess.

Also add tracing for all messages :-)

johannes

