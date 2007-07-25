Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:33070 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759895AbXGYBXm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jul 2007 21:23:42 -0400
Message-ID: <46A6A619.300@garzik.org>
Date: Tue, 24 Jul 2007 21:23:37 -0400
From: Jeff Garzik <jeff@garzik.org>
MIME-Version: 1.0
To: Stephen.Clark@seclark.us
CC: David Miller <davem@davemloft.net>, jketreno@linux.intel.com,
	axjslack@bluebottle.com, linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net
Subject: Re: [ipw3945-devel] Request for help...
References: <46A69998.7020108@seclark.us>	<20070724.173529.48529759.davem@davemloft.net>	<46A69CA1.5020706@seclark.us> <20070724.174641.105428420.davem@davemloft.net> <46A6A1F7.202@seclark.us>
In-Reply-To: <46A6A1F7.202@seclark.us>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Stephen Clark wrote:
> I understand what you are saying on one hand, but you are also saying 
> that Intel
> is by themselves and no one in the community is going to help, if Intel 
> can't figure
> out how to do it the right way.

David referenced "the tireless attempts of Jeff and others to education 
them on how to improve the situation"


> What I am saying why can't someone in the community be a liason
> between what Intel is doing and wireless-dev? Why does it have to be 
> someone from
> Intel?

Ideally it is the hardware vendor that maintains their own Linux drivers 
in the upstream kernel.  That is the ideal.  It scales best and focuses 
knowledge and resources in everyone's best interests.

To answer your question, it does not HAVE to be somebody at Intel.  On 
occasion, when a hardware vendor was exceedingly difficult to work with, 
someone in the community will step up and fill that gap.

The problem with such a liaison is that they must maintain a fork of the 
vendor driver themselves, which is time consuming and annoying, because 
you wind up buffering the code and problem complaints from the community 
as well as trying to reconcile that with new vendor driver engineering.

That process, as we saw with skge and tg3 drivers, usually ends up with 
the community maintaining a driver independent of the hardware vendor, 
using the hardware vendor's driver purely as a reference manual, once 
things are out-of-sync enough.  That's not generally a situation the 
hardware vendor likes, since they lose a lot of control -- though in 
tg3's case, the driver quality and upstream incentives were such that 
the vendor switched from their own driver to tg3.  And now the tg3 
vendor is back in control, actively submitting patches, and overall 
being an excellent example of open source engineering done right.

In general, most incentives rest on Intel to get stuff upstream.  That's 
where the process is most efficient, and all involved (Linux users, 
Kernel hackers, and Intel) benefit.

Part of my tireless work is _not_ throwing my hands up in frustration 
and doing it all myself :) but instead trying to counsel on where the 
process is getting stuck.

	Jeff


