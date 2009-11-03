Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43492 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750796AbZKCPkH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Nov 2009 10:40:07 -0500
Date: Tue, 3 Nov 2009 07:38:13 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Marcel Holtmann <marcel@holtmann.org>
cc: Johannes Berg <johannes@sipsolutions.net>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	David Miller <davem@davemloft.net>, linville@tuxdriver.com,
	linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: Please consider reverting
 7d930bc33653d5592dc386a76a38f39c2e962344
In-Reply-To: <1257262187.3420.73.camel@localhost.localdomain>
Message-ID: <alpine.LFD.2.01.0911030732150.31845@localhost.localdomain>
References: <20091103053156.GA3212@core.coreip.homeip.net>  <20091102.224957.32364226.davem@davemloft.net>  <20091103065238.GE3212@core.coreip.homeip.net>  <1257232587.3420.55.camel@localhost.localdomain>  <1257234299.28469.25.camel@johannes.local>
 <20091103082201.GG3212@core.coreip.homeip.net>  <1257237061.28469.43.camel@johannes.local>  <20091103084744.GH3212@core.coreip.homeip.net>  <1257238623.28469.47.camel@johannes.local> <1257262187.3420.73.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On Wed, 4 Nov 2009, Marcel Holtmann wrote:
> 
> I have to agree here. It happens why too often lately. And this needs to
> stop. Otherwise why bother with subsystem maintainers? Just send
> everything to Linus directly and have him to review every line of code.

You're full of sh*t.

Bugs are bugs. They should be reverted, and the people who introduced them 
should be SHAMED if the thing was introduced after the merge window.

I don't need to review any line of code at all - a revert is a revert. 
There's not a lot of review that needs, just a very obvious "that bug 
causes more problems than it fixed".

And yes, I'm upset, because in this case I saw one of the _earlier_ bisect 
results too, and I did actually spend time debugging it and sending 
Johannes the information, because he basically ignored the bisect result. 

That makes me upset. The fact that somebody has bisected the problem means 
that you should damn well thank them, not complain. And look at the -rc 
number, look at the commit - and you should realize that "please revert" 
is OBVIOUSLY the right thing to say to something that introduces problems 
after -rc5.

The fact is, maintainership does _not_ mean ownership. It means that you 
should be _responsible_ for the code, and you get credit for it, but if 
problems happen you do NOT "own" it. Not at all.

If you don't understand that, you shouldn't be a maintainer.

And if it's not obvious - I'm really upset that people are complaining 
about "please revert" for this case. YOU were wrong. 

		Linus
