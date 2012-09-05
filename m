Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44792 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751318Ab2IELwV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Sep 2012 07:52:21 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1T9E9b-0000OH-0j
	for linux-wireless@vger.kernel.org; Wed, 05 Sep 2012 13:52:19 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [RFC 0/2] mac80211 power constraint handling improvements
Date: Wed,  5 Sep 2012 13:52:54 +0200
Message-Id: <1346845976-15831-1-git-send-email-johannes@sipsolutions.net> (sfid-20120905_135224_173788_1628C57D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

So a user found a bug that restricted TX power to 2 dBm,
I found it was due to the AP advertising a high TX power
and a high power constraint to match... This isn't tested
yet, but I wanted to get your input.

johannes

