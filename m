Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate01.web.de ([217.72.192.221]:54052 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751729AbZAIP7b (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Jan 2009 10:59:31 -0500
From: Christian Lamparter <chunkeey@web.de>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH 0/3] p54: p54spi driver
Date: Fri, 9 Jan 2009 16:59:29 +0100
Cc: wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
References: <200901010201.44229.chunkeey@web.de> <200901091451.01499.chunkeey@web.de> <20090109144102.GA3371@tuxdriver.com>
In-Reply-To: <20090109144102.GA3371@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200901091659.29296.chunkeey@web.de> (sfid-20090109_165936_589927_5AA1162F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 09 January 2009 15:41:03 John W. Linville wrote:
> On Fri, Jan 09, 2009 at 02:51:01PM +0100, Christian Lamparter wrote:
> > On Thursday 01 January 2009 02:01:43 Christian Lamparter wrote:
> > > This patch series introduce the back-end driver p54spi for stlc4550/stlc4560 chips.
> > > 
> > > So far no one complained about the patches or had any other issues...
> > > => therefore it must be 100% working!
> > > 
> > > [Please mind the logic gap ;-) , But I hope someone will respond
> > > when the whole driver can be easily built with compat-wireless.]
> > > 
> > > Regards,
> > > 	Chr
> > John?
>  
> Yes?
> 
> > I found a "few" bugs in the series, I'll do a re spin later...
> > 
> > In the meantime, do you still have this patch somewhere in your inbox?
> > http://www.spinics.net/lists/linux-wireless/msg24853.html
> 
> I have it.  Are you saying I should drop it?
Erm?
you can drop the three patches for p54spi (and longbow support) for now.

the "p54: fix oops caused by bad eeproms" patch on the other hand should 
be merged (in fact a month ago)?! Should I add it into the next patch series again?

Regards,
	Chr
