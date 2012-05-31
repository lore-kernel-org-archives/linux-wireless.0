Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:40966 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752059Ab2EaHkn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 May 2012 03:40:43 -0400
Message-ID: <1338450022.4531.3.camel@jlt3.sipsolutions.net> (sfid-20120531_094047_691788_D7CA58C4)
Subject: Re: Master mode support in iwlagn?
From: Johannes Berg <johannes@sipsolutions.net>
To: Dan Williams <dcbw@redhat.com>
Cc: Erwin Van de Velde <erwin.vandevelde@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Thu, 31 May 2012 09:40:22 +0200
In-Reply-To: <1338417129.8887.32.camel@dcbw.foobar.com>
References: <5252852.vpKViOerhF@sylvesterjr.cmi.ua.ac.be>
	 (sfid-20120530_140937_028561_351996E4) <1338381071.4511.13.camel@jlt3.sipsolutions.net>
	 <1338417129.8887.32.camel@dcbw.foobar.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-05-30 at 17:32 -0500, Dan Williams wrote:
> On Wed, 2012-05-30 at 14:31 +0200, Johannes Berg wrote:
> > On Wed, 2012-05-30 at 14:09 +0200, Erwin Van de Velde wrote:
> > > Dear all,
> > > 
> > > Are there any plans to add Master mode support to iwlagn? 
> > 
> > Depending on the device, it is (partially) supported as part of P2P/GO
> > mode, but other than that there are no plans.
> 
> What's the list of devices that will support Master mode?  I recall that
> 3945 and 4965 never will.  And I assume anything 6xxx-based will get it.
> But I was somewhat fuzzy on where the 5xxx series stand.

That's not completely correct. Today, we have released firmware with
support for it for 100, 105, 135, 2000, 2030, 6205, 6030, 1030 and 6x50
devices. 6x00 doesn't have it, and I don't think it will.

I'm pretty sure any 5xxx series (there are a few different ones for
Wimax etc.) will not get it.

johannes

