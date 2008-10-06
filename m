Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:41023 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752649AbYJFW6Q (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Oct 2008 18:58:16 -0400
Date: Mon, 6 Oct 2008 15:54:07 -0700
From: Greg KH <greg@kroah.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Dan Williams <dcbw@redhat.com>, Kalle Valo <kalle.valo@iki.fi>,
	proski@gnu.org, linux-wireless@vger.kernel.org
Subject: Re: at76_usb driver status
Message-ID: <20081006225406.GA14853@kroah.com> (sfid-20081007_005821_596054_CA9F5120)
References: <20081002210742.GA27221@kroah.com> <87y713y48r.fsf@nokia.com> <20081005061603.GB28533@kroah.com> <1223306593.31040.33.camel@dhcp-100-3-195.bos.redhat.com> <20081006183520.GA17647@kroah.com> <1223323940.31717.3.camel@dhcp-100-3-195.bos.redhat.com> <20081006203118.GG3448@tuxdriver.com> <1223325748.3778.30.camel@johannes.berg> <20081006213909.GN3448@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20081006213909.GN3448@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 06, 2008 at 05:39:09PM -0400, John W. Linville wrote:
> On Mon, Oct 06, 2008 at 10:42:28PM +0200, Johannes Berg wrote:
> > On Mon, 2008-10-06 at 16:31 -0400, John W. Linville wrote:
> > > On Mon, Oct 06, 2008 at 04:12:20PM -0400, Dan Williams wrote:
> > > > On Mon, 2008-10-06 at 11:35 -0700, Greg KH wrote:
> > > 
> > > > > I'll gladly drop it from drivers/staging when the "real" version hits
> > > > > mainline, until then, it should stay in staging, as that is the whole
> > > > > point of it.
> > > > 
> > > > It does nobody any good if (a) the drivers are _never_ going to go
> > > > upstream, and (b) if the drivers aren't going to get any attention in
> > > > their current form because of (a).
> > > > 
> > > > I don't care if the driver allows peoples hardware to work; I want a
> > > > driver that makes peoples hardware work _well_.  Out of tree drivers
> > > > that are never going upstream will not work well.
> > > 
> > > I think/thought the main point of -staging was to give drivers
> > > visibility in hopes of people working to fix them.
> > 
> > Shouldn't then the mac80211-based at76_usb be in -staging instead? That
> > one might not work completely, but at least it's fixable without a
> > rewrite.
> 
> Yes, probably so.  That is what I had planned to send to Greg, but I
> was thinking that the version currently in wireless-testing probably
> won't compile against -staging (which is based on 2.6.27).

No, sorry, I've moved my -staging tree into my "main" kernel development
tree which is based on 2.6.27-rc8 right now.

So if you have a version that you would rather see instead of the "old"
one in drivers/staging/ please feel free to send it to me.

thanks,

greg k-h
