Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42066 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751462Ab2KTVos (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Nov 2012 16:44:48 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1Tavcd-0003IE-AV
	for linux-wireless@vger.kernel.org; Tue, 20 Nov 2012 22:44:47 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 00/10] initial VHT support
Date: Tue, 20 Nov 2012 22:45:06 +0100
Message-Id: <1353447916-17304-1-git-send-email-johannes@sipsolutions.net> (sfid-20121120_224451_615250_64DF204A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ok, so here's a repost of the VHT support. I've had to work on
the compatibility code (since I needed it in hostapd as well),
so that's new. Other than that, not many changes over the last
version.

I now tested that the channel settings go through to the driver
(i.e. hwsim) for both monitor mode and AP mode. Managed mode
still needs mac80211 work to parse the VHT operation IE and set
the channel context accordingly, I plan to work on that soon.

This also still needs regulatory work (TODO in the code) but as
we don't have any drivers we don't have to worry about it yet.

I'm planning to merge this soon so everybody can work with the
new APIs and more people can contribute the missing pieces.

johannes

