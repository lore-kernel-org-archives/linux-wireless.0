Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:48253 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752934AbYIVWNx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Sep 2008 18:13:53 -0400
Date: Mon, 22 Sep 2008 18:13:21 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Chr <chunkeey@web.de>
Cc: Dan Williams <dcbw@redhat.com>,
	Philippe Waroquiers <philippe.waroquiers@skynet.be>,
	linux-wireless@vger.kernel.org, kyle@redhat.com
Subject: Re: prism54 stopped working after upgrade from kernel
	2.6.25.14-69.fc8 to 2.6.26.3-14.fc8
Message-ID: <20080922221321.GF3660@tuxdriver.com> (sfid-20080923_001357_226176_2CA1547B)
References: <CB9B2237C21D46F3B852E45F75E91C52@soleil> <200809222332.00500.chunkeey@web.de> <1221947069.11865.11.camel@localhost.localdomain> <200809222359.40354.chunkeey@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200809222359.40354.chunkeey@web.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 22, 2008 at 11:59:40PM +0200, Chr wrote:
> On Saturday 20 September 2008 23:44:29 Dan Williams wrote:
> > On Mon, 2008-09-22 at 23:32 +0200, Chr wrote:
> > > > > http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=co
> > > > >mmit ;h=aaa1553512b9105699113ea7e2ea726f3d9d4de2
> > > >
> > > > Is that commit not in stable 2.6.26 yet or something?
> > >
> > > Hmm, no? AFAIK The mac80211 multiqueue changes went in somewhere in the
> > > 2.6.27-rc cycle. so 2.6.26.stable doesn't need any extra patches, right?
> >
> > Ah yeah right; I guess I don't understand the link you posted then.  I'd
> > thought it was something like "you need this patch which Fedora doesn't
> > have in their kernel".
> Hmm? I though fedora backported multiqueue back into their 2.6.26?
> 
> Atleast, the original (but with a buggy p54) multiqueue patch seems to be in 
> the linux-wirless-2.6-pending.diff/patch file... but this fix is nowhere to 
> be found inside fedora's kernel source?
> 
> So, Dan? can you add that patch to the next fedora's 2.6.26 kernel release? 

I pinged Kyle McMartin about it -- he has been doing the wireless
kernel updates in Fedora for a little while now.

John
-- 
John W. Linville		Linux should be at the core
linville@tuxdriver.com			of your literate lifestyle.
