Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:41672 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752505AbZG3KFa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jul 2009 06:05:30 -0400
Subject: Re: [wireless] rt2870sta BUGs on shutdown,
 2.6.30.2->git.today+git.wireless.today
From: Mike Galbraith <efault@gmx.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <1248947740.8925.12.camel@johannes.local>
References: <1248945770.7910.24.camel@marge.simson.net>
	 <1248946195.8925.9.camel@johannes.local>
	 <1248947099.8396.6.camel@marge.simson.net>
	 <1248947740.8925.12.camel@johannes.local>
Content-Type: text/plain
Date: Thu, 30 Jul 2009 12:05:26 +0200
Message-Id: <1248948326.8823.4.camel@marge.simson.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2009-07-30 at 11:55 +0200, Johannes Berg wrote:
> On Thu, 2009-07-30 at 11:44 +0200, Mike Galbraith wrote:
> > On Thu, 2009-07-30 at 11:29 +0200, Johannes Berg wrote:
> > > On Thu, 2009-07-30 at 11:22 +0200, Mike Galbraith wrote:
> > > 
> > > > drivers/staging/rt2870/../rt2860/sta_ioctl.c
> > > 
> > > Sorry, but that '/staging/' thing in there means we cannot support this.
> > > If you must, take your query to the staging list,
> > > devel@driverdev.osuosl.org (according to MAINTAINERS).
> > 
> > Forwarded, thanks.
> > 
> > ....hm.  Does "If you must" mean reports aren't welcome?
> 
> To be honest, I don't know. I'd rather see people use the rt2x00 code
> instead of spending time cleaning up that mess (the code you've pasted
> was pretty bad!). But you may or may not find somebody who cares about
> that, just rather unlikely on this list.

Understood (and yeah, the source is.. not pretty).  Sorry for the noise.

WRT rt2x00 with this adapter, I tried it, was a nogo.  If I find time,
I'll reconfigure/report.

	-Mike (outta here;)

