Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:57263 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751501Ab1KHSVS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Nov 2011 13:21:18 -0500
Subject: Re: [PATCH v6 1/2] wireless:  Support ht-capabilities over-rides.
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <4EB9720B.8080704@candelatech.com>
References: <1320707676-17255-1-git-send-email-greearb@candelatech.com>
	 (sfid-20111108_001449_233997_95FF19FA) <1320740099.4304.5.camel@jlt3.sipsolutions.net>
	 <4EB96A5C.8040606@candelatech.com>
	 <1320775251.24797.31.camel@jlt3.sipsolutions.net>
	 <4EB9720B.8080704@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 08 Nov 2011 19:21:14 +0100
Message-ID: <1320776474.24797.32.camel@jlt3.sipsolutions.net> (sfid-20111108_192121_613081_4DA2F8D5)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-11-08 at 10:16 -0800, Ben Greear wrote:

> > Fair enough. I think what I'm really after is having a way to know wtf
> > we're using when you requested something. That would probably be more
> > useful overall.

ok.

> The current ht_cap settings for each station are in debugfs, so hopefully it
> would not be that difficult to add it to a netlink response.  Perhaps
> it's already there..I haven't looked yet.
> 
> > FWIW, I did talk to some people at the kernel summit about the -EINVAL
> > thing and maybe there's an idea to send back the invalid attribute at
> > least, but doesn't really matter here. I'm OK with just allowing it all
> > since it's not going to be used a lot anyway.
> 
> Ok, I'll add some printks.

I really don't think you should add printks here for this.

> > OTOH, if you request a connect(), you don't even know the band and
> > technically a driver could have different capabilities on different
> > bands.
> 
> Lets see if any other drivers try to support these features.  Anyone
> doing that work will likely see some ways to make use of common code
> and things can be shuffled then.  As written, the patches are not overly
> invasive, so I think we can move stuff around later without too much
> trouble.

Ok, fair enough.

johannes

