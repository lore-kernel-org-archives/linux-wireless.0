Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:52292 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756192AbbAFSaY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Jan 2015 13:30:24 -0500
Date: Tue, 06 Jan 2015 13:30:22 -0500 (EST)
Message-Id: <20150106.133022.1374471134166201756.davem@davemloft.net> (sfid-20150106_193037_122056_8D40EAE4)
To: johannes@sipsolutions.net
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: pull-request: mac80211 2015-01-06
From: David Miller <davem@davemloft.net>
In-Reply-To: <1420546548.1966.26.camel@sipsolutions.net>
References: <1420546548.1966.26.camel@sipsolutions.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes@sipsolutions.net>
Date: Tue, 06 Jan 2015 13:15:48 +0100

> Here's just a single fix - a revert of a patch that broke the
> p54 and cw2100 drivers (arguably due to bad assumptions there.)
> Since this affects kernels since 3.17, I decided to revert for
> now and we'll revisit this optimisation properly for -next.

Pulled, thanks Johannes.

> Also -- happy New Year, and sorry about the genl issue :(

No problem.

> I'm still a bit confused about whether you wanted the pull request with
> the text in the email or in the tag, or branch, or something - I
> interpreted what you said to Kalle differently to what you said to me.
> I've duplicated it for now :)

If you put it in the tag, that's fine, I'll just add my signoff to
it.
