Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from madara.hpl.hp.com ([192.6.19.124]:62085 "EHLO madara.hpl.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750853AbXCWQQA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Mar 2007 12:16:00 -0400
Date: Fri, 23 Mar 2007 09:13:39 -0700
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>, stable@kernel.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] fix information leak in wireless extensions on 64-bit platforms
Message-ID: <20070323161339.GA4713@bougret.hpl.hp.com>
Reply-To: jt@hpl.hp.com
References: <1174640787.3588.65.camel@johannes.berg> <1174657362.3366.6.camel@johannes.berg> <20070323154828.GA4671@bougret.hpl.hp.com> <1174665384.4470.0.camel@johannes.berg>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1174665384.4470.0.camel@johannes.berg>
From: Jean Tourrilhes <jt@hpl.hp.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Mar 23, 2007 at 04:56:24PM +0100, Johannes Berg wrote:
> On Fri, 2007-03-23 at 08:48 -0700, Jean Tourrilhes wrote:
> 
> > 	Yes, sorry for the delay, I wanted to make sure I had all the
> > parts fully fleshed out.
> 
> :)
> 
> Could you maybe send yours to stable too? Both of them I guess. Or do
> you want us (John I guess) to do that?
> 
> johannes

	It seems that the lifetime of each stable branch is measured
in weeks (apart from 2.6.16), and being an old timer, gaining a few
weeks does not seem to me to be worth the trouble. It's not like the
bug is entirely new.
	I'm personally more concerned about distro. If getting it into
stable would make it go into a distro release, then I would see more
value. It seems that it's too late for the next release of Debian or
Fedora, and I don't know if any distro is going to be based on this
stable branch.
	The last thing is that I could not test those stuff myself,
and the testing done for me was limited. I would be more confident if
you were to give it a good beating before we push that into stable,
because you know what to test.
	Those are only my opinions. John is the man, so I let him
decide. John, if you feel like pushing it, please do it.

	Have fun...

	Jean
