Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:46548 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758232Ab3BSLME (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Feb 2013 06:12:04 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1U7l7D-0005Kz-NY
	for linux-wireless@vger.kernel.org; Tue, 19 Feb 2013 12:12:03 +0100
Message-ID: <1361272321.8553.5.camel@jlt4.sipsolutions.net> (sfid-20130219_121210_431288_9FA11F68)
Subject: reminder: mac80211-next tree management
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Tue, 19 Feb 2013 12:12:01 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Now that 3.8 is released, we can obviously only pick up important fixes
for 3.9, and everything else for 3.10. I'm still going to apply
everything to mac80211-next for now and then cleanly rebase once we get
to -rc1 and the wireless/net trees open.

This means you'll see a rebase in a week or two.

johannes

