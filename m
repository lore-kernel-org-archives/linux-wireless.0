Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:54494 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752113AbXCWQhl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Mar 2007 12:37:41 -0400
Date: Fri, 23 Mar 2007 09:35:36 -0700
From: Greg KH <greg@kroah.com>
To: Jean Tourrilhes <jt@hpl.hp.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>, stable@kernel.org
Subject: Re: [stable] [PATCH] fix information leak in wireless extensions on 64-bit platforms
Message-ID: <20070323163536.GA27015@kroah.com>
References: <1174640787.3588.65.camel@johannes.berg> <1174657362.3366.6.camel@johannes.berg> <20070323154828.GA4671@bougret.hpl.hp.com> <1174665384.4470.0.camel@johannes.berg> <20070323161339.GA4713@bougret.hpl.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20070323161339.GA4713@bougret.hpl.hp.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Mar 23, 2007 at 09:13:39AM -0700, Jean Tourrilhes wrote:
> On Fri, Mar 23, 2007 at 04:56:24PM +0100, Johannes Berg wrote:
> > On Fri, 2007-03-23 at 08:48 -0700, Jean Tourrilhes wrote:
> > 
> > > 	Yes, sorry for the delay, I wanted to make sure I had all the
> > > parts fully fleshed out.
> > 
> > :)
> > 
> > Could you maybe send yours to stable too? Both of them I guess. Or do
> > you want us (John I guess) to do that?
> > 
> > johannes
> 
> 	It seems that the lifetime of each stable branch is measured
> in weeks (apart from 2.6.16), and being an old timer, gaining a few
> weeks does not seem to me to be worth the trouble. It's not like the
> bug is entirely new.
> 	I'm personally more concerned about distro. If getting it into
> stable would make it go into a distro release, then I would see more
> value. It seems that it's too late for the next release of Debian or
> Fedora, and I don't know if any distro is going to be based on this
> stable branch.

Lots of distros watch the stable branches to see what they need to pick
up for their kernel releases.

So please don't just ignore them, lots of people depend on them, even
outside of the distros.

thanks,

greg k-h
