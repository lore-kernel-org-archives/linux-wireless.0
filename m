Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:37304 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753531AbYJFVkA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Oct 2008 17:40:00 -0400
Date: Mon, 6 Oct 2008 17:39:09 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Dan Williams <dcbw@redhat.com>, Greg KH <greg@kroah.com>,
	Kalle Valo <kalle.valo@iki.fi>, proski@gnu.org,
	linux-wireless@vger.kernel.org
Subject: Re: at76_usb driver status
Message-ID: <20081006213909.GN3448@tuxdriver.com> (sfid-20081006_234007_480745_1957549B)
References: <20081002210742.GA27221@kroah.com> <87y713y48r.fsf@nokia.com> <20081005061603.GB28533@kroah.com> <1223306593.31040.33.camel@dhcp-100-3-195.bos.redhat.com> <20081006183520.GA17647@kroah.com> <1223323940.31717.3.camel@dhcp-100-3-195.bos.redhat.com> <20081006203118.GG3448@tuxdriver.com> <1223325748.3778.30.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1223325748.3778.30.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 06, 2008 at 10:42:28PM +0200, Johannes Berg wrote:
> On Mon, 2008-10-06 at 16:31 -0400, John W. Linville wrote:
> > On Mon, Oct 06, 2008 at 04:12:20PM -0400, Dan Williams wrote:
> > > On Mon, 2008-10-06 at 11:35 -0700, Greg KH wrote:
> > 
> > > > I'll gladly drop it from drivers/staging when the "real" version hits
> > > > mainline, until then, it should stay in staging, as that is the whole
> > > > point of it.
> > > 
> > > It does nobody any good if (a) the drivers are _never_ going to go
> > > upstream, and (b) if the drivers aren't going to get any attention in
> > > their current form because of (a).
> > > 
> > > I don't care if the driver allows peoples hardware to work; I want a
> > > driver that makes peoples hardware work _well_.  Out of tree drivers
> > > that are never going upstream will not work well.
> > 
> > I think/thought the main point of -staging was to give drivers
> > visibility in hopes of people working to fix them.
> 
> Shouldn't then the mac80211-based at76_usb be in -staging instead? That
> one might not work completely, but at least it's fixable without a
> rewrite.

Yes, probably so.  That is what I had planned to send to Greg, but I
was thinking that the version currently in wireless-testing probably
won't compile against -staging (which is based on 2.6.27).

John
-- 
John W. Linville		Linux should be at the core
linville@tuxdriver.com			of your literate lifestyle.
