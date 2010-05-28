Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60657 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753555Ab0E1S5e (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 May 2010 14:57:34 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.71)
	(envelope-from <johannes@sipsolutions.net>)
	id 1OI4kP-00047O-83
	for linux-wireless@vger.kernel.org; Fri, 28 May 2010 20:57:33 +0200
Message-Id: <20100528185302.639535282@sipsolutions.net>
Date: Fri, 28 May 2010 20:53:02 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [RFC 0/7] mac80211: preparations for blocking ampdu_action
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

These are some preparatory and cleanup patches
for a blocking ampdu_action callback that will
allow simplified locking in drivers and avoid
the race condition I had pointed out and posted
a workaround for around earlier.

Obviously, the interesting patch that actually
does that is still missing, but I wanted to
have people review these patches first anyway
since they can stand on their own and smaller
patch batches are always good :)

johannes

