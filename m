Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:52527 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754611AbYGEXvN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 5 Jul 2008 19:51:13 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.69)
	(envelope-from <johannes@sipsolutions.net>)
	id 1KFHX6-0003JJ-21
	for linux-wireless@vger.kernel.org; Sun, 06 Jul 2008 01:51:12 +0200
Message-Id: <20080705234735.210585000@sipsolutions.net> (sfid-20080706_015119_205579_09C5EF93)
Date: Sun, 06 Jul 2008 01:47:35 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [RFT 0/4] mac80211 improvements
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Here are a number of improvements for mac80211's virtual interface
handling (master netdev, cleanups) and driver API (beaconing).

I have tested these patches on b43 in AP, STA and IBSS modes
(communicating with my N810 or an AP) and have not seen any issues.

I would appreciate testing on other hardware (I can probably cover
iwl4965, rt61pci and zd1211 next week), but I don't expect much
trouble.

johannes

