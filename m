Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44258 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755470Ab2GRSnT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Jul 2012 14:43:19 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1SrZDR-0000aY-Tw
	for linux-wireless@vger.kernel.org; Wed, 18 Jul 2012 20:43:18 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [RFC 0/6] some mac80211 aggregation work
Date: Wed, 18 Jul 2012 20:43:14 +0200
Message-Id: <1342637000-5270-1-git-send-email-johannes@sipsolutions.net> (sfid-20120718_204322_439711_5CA5130A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is untested, wanted to see what people think :-)

The basic reason for this is that we currently ask for
aggregation stop but there's no clear indication of what
should actually happen, if the frames should be dropped
or maybe not etc., so I'm changing that.

johannes

