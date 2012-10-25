Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52661 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750737Ab2JYWqH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Oct 2012 18:46:07 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1TRWBi-0004zN-2k
	for linux-wireless@vger.kernel.org; Fri, 26 Oct 2012 00:46:06 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 0/3] mac80211: audit for access to skb data
Date: Fri, 26 Oct 2012 00:46:37 +0200
Message-Id: <1351205200-18094-1-git-send-email-johannes@sipsolutions.net> (sfid-20121026_004611_616574_5C6C9420)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

While looking at Javier's patch and some other things I found
a number of places that don't make sure the skb data is there
when it's accessed, fix them.

johannes

