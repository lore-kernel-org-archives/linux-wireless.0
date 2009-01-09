Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:60065 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755481AbZAIUAn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Jan 2009 15:00:43 -0500
Date: Fri, 9 Jan 2009 14:53:21 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Christian Lamparter <chunkeey@web.de>
Cc: wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH 0/3] p54: p54spi driver
Message-ID: <20090109195321.GD3371@tuxdriver.com> (sfid-20090109_210051_729161_103B5DDA)
References: <200901010201.44229.chunkeey@web.de> <200901091451.01499.chunkeey@web.de> <20090109144102.GA3371@tuxdriver.com> <200901091659.29296.chunkeey@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200901091659.29296.chunkeey@web.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jan 09, 2009 at 04:59:29PM +0100, Christian Lamparter wrote:
> On Friday 09 January 2009 15:41:03 John W. Linville wrote:
> > On Fri, Jan 09, 2009 at 02:51:01PM +0100, Christian Lamparter wrote:
> > > On Thursday 01 January 2009 02:01:43 Christian Lamparter wrote:
> > > > This patch series introduce the back-end driver p54spi for stlc4550/stlc4560 chips.
> > > > 
> > > > So far no one complained about the patches or had any other issues...
> > > > => therefore it must be 100% working!
> > > > 
> > > > [Please mind the logic gap ;-) , But I hope someone will respond
> > > > when the whole driver can be easily built with compat-wireless.]
> > > > 
> > > > Regards,
> > > > 	Chr
> > > John?
> >  
> > Yes?
> > 
> > > I found a "few" bugs in the series, I'll do a re spin later...
> > > 
> > > In the meantime, do you still have this patch somewhere in your inbox?
> > > http://www.spinics.net/lists/linux-wireless/msg24853.html
> > 
> > I have it.  Are you saying I should drop it?
> Erm?
> you can drop the three patches for p54spi (and longbow support) for now.

Done.

> the "p54: fix oops caused by bad eeproms" patch on the other hand should 
> be merged (in fact a month ago)?! Should I add it into the next patch series again?

I don't see it in my stash, so please resend it. :-)

Thanks,

John
-- 
John W. Linville		Linux should be at the core
linville@tuxdriver.com			of your literate lifestyle.
