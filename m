Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52356 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752017Ab2FSOvB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jun 2012 10:51:01 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1Sgzlj-00015A-Pp
	for linux-wireless@vger.kernel.org; Tue, 19 Jun 2012 16:50:59 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [RFC 0/17] add P2P Device support
Date: Tue, 19 Jun 2012 16:50:39 +0200
Message-Id: <1340117456-10154-1-git-send-email-johannes@sipsolutions.net> (sfid-20120619_165120_048461_9B077046)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In order to support different P2P Device addresses, I've
been working on patches to support a P2P Device abstraction.

A big part of it is changing nl80211 to be able to identify
wireless_dev structs by their new wdev_id rather than only
by interface index.

Then there's code to actually make some APIs netdev independent
and finally to actually create a P2P Device abstraction in both
cfg80211 and mac80211.

I also threw in a small netns fix.

Please review :-)

johannes

