Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35815 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751339Ab2JAHU2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Oct 2012 03:20:28 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1TIaIk-0005Bp-Ll
	for linux-wireless@vger.kernel.org; Mon, 01 Oct 2012 09:20:26 +0200
Message-ID: <1349076058.10330.3.camel@jlt4.sipsolutions.net> (sfid-20121001_092032_921877_04A51122)
Subject: mac80211 trees during the merge window
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Mon, 01 Oct 2012 09:20:58 +0200
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

In order to not lose patches or have too many to catch up to, I'm going
to keep applying patches to the mac80211{,-next} trees. That does mean,
however, that I'm going to have to _rebase_ once the merge window closes
and John respins his trees. It also means that in the unlikely event
that I applied your patch but I have major issues with it during the
rebase, I might ask you to resend it then, but I don't actually expect
that to happen.

I'll send pull requests only after all of that happens, obviously.

johannes

