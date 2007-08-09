Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52465 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764649AbXHIAaq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Aug 2007 20:30:46 -0400
Date: Wed, 8 Aug 2007 17:28:43 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Michael Buesch <mb@bu3sch.de>
Cc: Aurelien Jarno <aurelien@aurel32.net>,
	John Linville <linville@tuxdriver.com>,
	Felix Fietkau <nbd@openwrt.org>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ssb: Make extif driver compilation depend on extif  config
Message-Id: <20070808172843.f98cb2de.akpm@linux-foundation.org>
In-Reply-To: <200708090220.32981.mb@bu3sch.de>
References: <200708071744.40287.mb@bu3sch.de>
	<200708090202.20267.mb@bu3sch.de>
	<20070808171046.e6a3f506.akpm@linux-foundation.org>
	<200708090220.32981.mb@bu3sch.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 9 Aug 2007 02:20:32 +0200
Michael Buesch <mb@bu3sch.de> wrote:

> On Thursday 09 August 2007, Andrew Morton wrote:
> > Still confused.
> > 
> > I pull
> > git+ssh://master.kernel.org/pub/scm/linux/kernel/git/linville/wireless-dev.git#mm-master
> > into -mm.  Could be that John puts other things into other trees which do
> > not appear in #mm-master, I don't know.
> > 
> > Given that you are the developer and maintainer of ssb it is appropriate
> > (especially at this stage) that you run a tree.  Just a plain old quilt
> > tree like
> > http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/gregkh-01-driver/
> > would be fine.
> > 
> > If that tree is relative to some tree which John is running then that's OK,
> > as long as someone tells me where to get that tree from.
> > 
> > Or just merge all of SSB via John's tree.  I don't think it matters that
> > it's not strictly a wireless thing.  
> 
> I can live with doing it through John.
> And as bcm43xx depends on ssb we are doomed to go through
> John's tree.
> So if you always pull John's tree, you'll be up to date with
> wireless + ssb.
> 
> So if you drop everything b44, bcm43xx and ssb related
> and pull John's tree, it will compile again.

But I pull John's tree daily, and I don't receive all that ssb stuff.  I
assume his is not including it in the #mm-master branch.

> So, my question: How is the mainline merge going to happen?
> Do you handle that, or do I have to generate some split-out
> patches for ssb (I have a script for that).

If the master version of ssb is in one of John's branches then he can ask
Linus to merge that branch into mainline.

