Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f42.google.com ([209.85.160.42]:46279 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751488AbZKCIro (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Nov 2009 03:47:44 -0500
Date: Tue, 3 Nov 2009 00:47:44 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Marcel Holtmann <marcel@holtmann.org>,
	David Miller <davem@davemloft.net>,
	torvalds@linux-foundation.org, linville@tuxdriver.com,
	linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: Please consider reverting
	7d930bc33653d5592dc386a76a38f39c2e962344
Message-ID: <20091103084744.GH3212@core.coreip.homeip.net>
References: <20091103053156.GA3212@core.coreip.homeip.net> <20091102.224957.32364226.davem@davemloft.net> <20091103065238.GE3212@core.coreip.homeip.net> <1257232587.3420.55.camel@localhost.localdomain> <1257234299.28469.25.camel@johannes.local> <20091103082201.GG3212@core.coreip.homeip.net> <1257237061.28469.43.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1257237061.28469.43.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 03, 2009 at 09:31:01AM +0100, Johannes Berg wrote:
> On Tue, 2009-11-03 at 00:22 -0800, Dmitry Torokhov wrote:
> 
> > I do not understand what the fuss is about. We are pretty far in release
> > process (rc6 is about to be cut I'd expect) and we have an issue that
> > for all practical purposes kills the box on resume. Yes, I want action
> > to be swift in this case and (unless author or maintainer - who were
> > CCed on the email - have otehr solutiuon) the offending commit to be
> > reverted. If it was rc1 or rc2 or 3 I'd feel differently.
> 
> Oh, I don't disagree that swift action is good.
> 
> I just think that it's a matter of courtesy that should be independent
> from the release cycle to ask the author/maintainer by default, not as a
> second thought ("unless [...] have other solution"). You can always CC
> Linus and ask him to revert if you don't get a response.
> 
> What's wrong with that? It doesn't actually delay the action, but it
> makes the discussion much more friendly and cooperative instead of
> giving the author and maintainer the feeling that their opinion only
> matters as a second thought.
> 

I think you are reading too much into who was addressed directly and who
was "only" CCed... OK, next time (which I hope won't happen :) ) I'll
just address everyone directly. Will that work?

-- 
Dmitry
