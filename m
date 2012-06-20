Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:49323 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755846Ab2FTJFX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jun 2012 05:05:23 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1ShGqo-0002FN-MZ
	for linux-wireless@vger.kernel.org; Wed, 20 Jun 2012 11:05:22 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 0/5] fix netns in nl80211
Date: Wed, 20 Jun 2012 11:05:14 +0200
Message-Id: <1340183119-15340-1-git-send-email-johannes@sipsolutions.net> (sfid-20120620_110548_048598_58B30FDE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I've applied these patches to my mac80211-next tree
for my next pull request, they fix issues with the
network namespace support and I also refactor some
code already to make it more extensible later.

johannes

