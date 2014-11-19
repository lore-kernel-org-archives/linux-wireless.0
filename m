Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:39959 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755113AbaKSRfK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Nov 2014 12:35:10 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_CBC_SHA256:128)
	(Exim 4.84)
	(envelope-from <johannes@sipsolutions.net>)
	id 1Xr99p-0005SV-0s
	for linux-wireless@vger.kernel.org; Wed, 19 Nov 2014 18:35:09 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 0/4] randomised MAC address for scanning
Date: Wed, 19 Nov 2014 18:35:01 +0100
Message-Id: <1416418505-7359-1-git-send-email-johannes@sipsolutions.net> (sfid-20141119_183514_770711_0F96B0D5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series introduces randomised MAC addresses for scanning. It
obviously needs driver support, so three feature flags (for scan,
scheduled scan and wowlan-net-detect) are needed.

Currently it's only for unassociated, but maybe some devices can
also support it for background scans.

I've implemented it for hwsim (both software scan in mac80211 and
"hardware" scan), and an implementation for our driver (iwlmvm)
is underway as well.

johannes

