Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:54545 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751332Ab2JANxU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Oct 2012 09:53:20 -0400
From: Kalle Valo <kvalo@adurom.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: mac80211 trees during the merge window
References: <1349076058.10330.3.camel@jlt4.sipsolutions.net>
Date: Mon, 01 Oct 2012 16:53:19 +0300
In-Reply-To: <1349076058.10330.3.camel@jlt4.sipsolutions.net> (Johannes Berg's
	message of "Mon, 01 Oct 2012 09:20:58 +0200")
Message-ID: <87y5jq1epc.fsf@purkki.adurom.net> (sfid-20121001_155324_547385_98C0F229)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> In order to not lose patches or have too many to catch up to, I'm going
> to keep applying patches to the mac80211{,-next} trees. That does mean,
> however, that I'm going to have to _rebase_ once the merge window closes
> and John respins his trees.

Good idea. But why do you need to rebase?

I think it's ok just send a merge request even if the base commit is not
Linville's HEAD, but few weeks older. And once John has merged your pull
request you just merge back John's tree (which apparently looks like a
rebase, at least it did for me) and both trees have same HEAD again. I
recall doing this with ath6kl.git and it didn't have any problems, and
it's so much nicer for the users of your tree.

-- 
Kalle Valo
