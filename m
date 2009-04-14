Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:36870 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752014AbZDNCgK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Apr 2009 22:36:10 -0400
Date: Mon, 13 Apr 2009 19:33:45 -0700
From: Greg KH <greg@kroah.com>
To: Forest Bond <forest@alittletooquiet.net>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, Dan Williams <dcbw@redhat.com>
Subject: Re: VT6656 driver source now GPL
Message-ID: <20090414023345.GA17901@kroah.com> (sfid-20090414_043613_672291_BAEA6DE7)
References: <20090319164256.GA25237@storm.local.network> <43e72e890903190945m4d8920f5y69f5847b688b0aa1@mail.gmail.com> <20090320131014.GG25237@storm.local.network> <20090414000835.GA31504@storm.local.network> <49E3D7AA.1050207@lwfinger.net> <20090414005523.GC31504@storm.local.network> <49E3E135.4040305@lwfinger.net> <20090414021119.GC17559@kroah.com> <20090414022058.GA25746@storm.local.network>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20090414022058.GA25746@storm.local.network>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Apr 13, 2009 at 10:20:59PM -0400, Forest Bond wrote:
> Hi,
> 
> On Mon, Apr 13, 2009 at 07:11:19PM -0700, Greg KH wrote:
> > On Mon, Apr 13, 2009 at 08:04:53PM -0500, Larry Finger wrote:
> > > Forest Bond wrote:
> > > > 
> > > > Great, this is enough to get started, at least.  I assume that the quality bar
> > > > is low for code in drivers/staging.  Low quality work is a trademark of mine, so
> > > > I should be able to tackle this. ;)
> > > > 
> > > > Is there any reason I ought to think that it would be easier to get this
> > > > accepted in linux-staging than drivers/staging?  I'll admit that I feel better
> > > > about the layout of drivers/staging than I do about the quilt stuff in
> > > > linux-staging.
> > > 
> > > GregKH has said that he will take it from here. I think that means that he will
> > > add it to drivers/staging and get it to build.
> > 
> > Yes I will.  Can someone send me a patch?
> 
> I will get you one patch for each driver adding the driver source under
> drivers/staging on linux-2.6.  If that doesn't sound right, let me know.

That would be fine.

thanks,

greg k-h
