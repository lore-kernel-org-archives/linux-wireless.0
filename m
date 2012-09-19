Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44237 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755968Ab2ISKH5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Sep 2012 06:07:57 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1TEHCF-0007cB-ER
	for linux-wireless@vger.kernel.org; Wed, 19 Sep 2012 12:07:55 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 0/3] mac80211: avoid useless delBA frames
Date: Wed, 19 Sep 2012 12:08:30 +0200
Message-Id: <1348049313-7650-1-git-send-email-johannes@sipsolutions.net> (sfid-20120919_120800_557148_51638D1E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There are a few situations where it's completely pointless
to send delBA action frames, so let's remove them.

johannes

