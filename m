Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:50409 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754149AbYEJWWV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 May 2008 18:22:21 -0400
Received: from [91.5.117.77] (helo=[10.0.0.127])
	by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.69)
	(envelope-from <johannes@sipsolutions.net>)
	id 1JuxSO-0000zb-1P
	for linux-wireless@vger.kernel.org; Sun, 11 May 2008 00:22:20 +0200
Message-Id: <20080510221845.340428000@sipsolutions.net> (sfid-20080511_002321_819230_B554AF46)
Date: Sun, 11 May 2008 00:18:45 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [RFT/C 0/7] various mac80211 updates/bugfixes
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

this patch series contains a number of bugfixes to mac80211
(which should be merged but I want to go to bed now so I'm
sending it all as RFC) as well as some other changes, notably
to put all transmit information/status into skb->cb.

I would appreciate any testing of these patches, they work
fine with my b43 but I cannot test most other hardware.

johannes

