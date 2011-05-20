Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.perches.com ([173.55.12.10]:1782 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932272Ab1ETQvX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 May 2011 12:51:23 -0400
Subject: Re: Plan for ath6kl cleanup
From: Joe Perches <joe@perches.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Greg KH <gregkh@suse.de>, linux-wireless@vger.kernel.org,
	Kalle Valo <kalle.valo@atheros.com>, linville@tuxdriver.com,
	devel@linuxdriverproject.org
In-Reply-To: <20110520142934.GA20250@infradead.org>
References: <4DD668F4.6090308@atheros.com> <20110520133600.GA10521@suse.de>
	 <20110520142934.GA20250@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 20 May 2011 09:51:21 -0700
Message-ID: <1305910281.4209.36.camel@Joe-Laptop> (sfid-20110520_185127_228870_31AF858A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-05-20 at 10:29 -0400, Christoph Hellwig wrote:
> On Fri, May 20, 2011 at 06:36:00AM -0700, Greg KH wrote:
> > On Fri, May 20, 2011 at 04:13:24PM +0300, Kalle Valo wrote:
> > > We have been thinking about how to get ath6kl out from staging and get
> > > it to a first class citizen under drivers/net/wireless. There's quite a
> > > lot of work to do get ath6kl cleaned up and the prospect of doing all
> > > that through the staging-next tree wasn't that exciting. We would be
> > > sending hundreds of patches and it would take a long time to cleanup the
> > > driver. And the disconnection from the wireless core development also
> > > sounded very daunting (cfg80211 API changes etc.).
> > 
> > This sounds like, "We don't like the kernel development model, it
> > requires us to break everything up into small patches and show our work
> > to everyone."
> 
> It's not the kernel development mode, it's something that you try to
> impose on staging users.  Creating a more less new driver from a pig
> pile of junk doesn't make sense minimized patches with micro-review.

I tried it once on ath6kl.
Ended up with ~300 patches and a very clean tree.

http://repo.or.cz/w/linux-2.6/trivial-mods.git/shortlog/refs/heads/20110108_ath6kl

The coordination with atheros and greg was balky.


