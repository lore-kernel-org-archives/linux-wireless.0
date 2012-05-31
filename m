Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:43913 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753003Ab2EaJDu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 May 2012 05:03:50 -0400
Received: by wibhn6 with SMTP id hn6so692981wib.1
        for <linux-wireless@vger.kernel.org>; Thu, 31 May 2012 02:03:49 -0700 (PDT)
From: Erwin Van de Velde <erwin.vandevelde@gmail.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Dan Williams <dcbw@redhat.com>
Subject: Re: Master mode support in iwlagn?
Date: Thu, 31 May 2012 11:03:47 +0200
Message-ID: <3093264.LxkCudZSCQ@sylvesterjr.cmi.ua.ac.be> (sfid-20120531_110357_097140_7C9A6A11)
In-Reply-To: <1338450022.4531.3.camel@jlt3.sipsolutions.net>
References: <5252852.vpKViOerhF@sylvesterjr.cmi.ua.ac.be> <1338417129.8887.32.camel@dcbw.foobar.com> <1338450022.4531.3.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

What is the reasoning behind it? Why provide it for some wireless NICs and not 
for others? Seems quite odd for me and features like Internet sharing over 
wireless are not that exotic, are they?

Best regards,
Erwin


On Thursday 31 May 2012 09:40:22 Johannes Berg wrote:
> On Wed, 2012-05-30 at 17:32 -0500, Dan Williams wrote:
> > On Wed, 2012-05-30 at 14:31 +0200, Johannes Berg wrote:
> > > On Wed, 2012-05-30 at 14:09 +0200, Erwin Van de Velde wrote:
> > > > Dear all,
> > > > 
> > > > Are there any plans to add Master mode support to iwlagn?
> > > 
> > > Depending on the device, it is (partially) supported as part of P2P/GO
> > > mode, but other than that there are no plans.
> > 
> > What's the list of devices that will support Master mode?  I recall that
> > 3945 and 4965 never will.  And I assume anything 6xxx-based will get it.
> > But I was somewhat fuzzy on where the 5xxx series stand.
> 
> That's not completely correct. Today, we have released firmware with
> support for it for 100, 105, 135, 2000, 2030, 6205, 6030, 1030 and 6x50
> devices. 6x00 doesn't have it, and I don't think it will.
> 
> I'm pretty sure any 5xxx series (there are a few different ones for
> Wimax etc.) will not get it.
> 
> johannes
