Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43375 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756698Ab3C1Pqm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Mar 2013 11:46:42 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1ULF2G-0004WK-JM
	for linux-wireless@vger.kernel.org; Thu, 28 Mar 2013 16:46:40 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 0/3] mac80211: some queue management fixes
Date: Thu, 28 Mar 2013 16:46:33 +0100
Message-Id: <1364485596-30425-1-git-send-email-johannes@sipsolutions.net> (sfid-20130328_164648_885369_AA2F3975)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I let these run through some testing, and it seems fine. The actual
error conditions are hard to test though -- particularly for the last
patch, most likely nobody ever saw that.

johannes

