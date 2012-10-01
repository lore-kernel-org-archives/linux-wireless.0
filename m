Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36987 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751447Ab2JAOCn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Oct 2012 10:02:43 -0400
Message-ID: <1349100195.10330.37.camel@jlt4.sipsolutions.net> (sfid-20121001_160303_357077_76A4AB8F)
Subject: Re: mac80211 trees during the merge window
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <kvalo@adurom.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 01 Oct 2012 16:03:15 +0200
In-Reply-To: <87y5jq1epc.fsf@purkki.adurom.net>
References: <1349076058.10330.3.camel@jlt4.sipsolutions.net>
	 <87y5jq1epc.fsf@purkki.adurom.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-10-01 at 16:53 +0300, Kalle Valo wrote:
> Johannes Berg <johannes@sipsolutions.net> writes:
> 
> > In order to not lose patches or have too many to catch up to, I'm going
> > to keep applying patches to the mac80211{,-next} trees. That does mean,
> > however, that I'm going to have to _rebase_ once the merge window closes
> > and John respins his trees.
> 
> Good idea. But why do you need to rebase?
> 
> I think it's ok just send a merge request even if the base commit is not
> Linville's HEAD, but few weeks older. And once John has merged your pull
> request you just merge back John's tree (which apparently looks like a
> rebase, at least it did for me) and both trees have same HEAD again. I
> recall doing this with ath6kl.git and it didn't have any problems, and
> it's so much nicer for the users of your tree.

Yes, good point, that should work as well. If anything goes wrong with
that though (like merge conflicts), I'd rather rebase I think.

johannes

