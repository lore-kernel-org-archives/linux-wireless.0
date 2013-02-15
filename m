Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60061 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933003Ab3BOPqj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Feb 2013 10:46:39 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1U6NUk-0003mG-2k
	for linux-wireless@vger.kernel.org; Fri, 15 Feb 2013 16:46:38 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 0/5] cfg80211: better station change handling
Date: Fri, 15 Feb 2013 16:46:29 +0100
Message-Id: <1360943194-14810-1-git-send-email-johannes@sipsolutions.net> (sfid-20130215_164643_028140_C8C65636)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I've now tested TDLS as well, and it just needed a few changes.

johannes

