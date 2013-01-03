Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47917 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753220Ab3ACMEY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Jan 2013 07:04:24 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1TqjX4-0001c3-PG
	for linux-wireless@vger.kernel.org; Thu, 03 Jan 2013 13:04:23 +0100
Message-ID: <1357214683.9741.1.camel@jlt4.sipsolutions.net> (sfid-20130103_130428_141179_4B4E9934)
Subject: FYI: mac80211 trees rebased
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Thu, 03 Jan 2013 13:04:43 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John updated the wireless trees, but as I had been picking up patches
during the merge window I've had to rebase my trees, which I've done
now.

In addition, I had to merge mac80211 into mac80211-next to not cause a
lot of conflicts for later.

johannes

