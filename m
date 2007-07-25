Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:33226 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932084AbXGYBkI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jul 2007 21:40:08 -0400
Message-ID: <46A6A9F4.1040603@garzik.org>
Date: Tue, 24 Jul 2007 21:40:04 -0400
From: Jeff Garzik <jeff@garzik.org>
MIME-Version: 1.0
To: Stephen.Clark@seclark.us
CC: David Miller <davem@davemloft.net>, jketreno@linux.intel.com,
	axjslack@bluebottle.com, linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net
Subject: Re: [ipw3945-devel] Request for help...
References: <46A6A447.2080903@linux.intel.com>	<46A69359.4030201@garzik.org>	<46A69998.7020108@seclark.us> <20070724.173529.48529759.davem@davemloft.net> <46A69CA1.5020706@seclark.us>
In-Reply-To: <46A69CA1.5020706@seclark.us>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Stephen Clark wrote:
> So if someone in "the community" really wanted to help  Intel why don't 
> they take the
> code Intel posts to  the ipw3945 ml and put it into where ever it is 
> really supposed to go?
> Instead of whining how Intel doesn't do it right.


Unscalable.

People in the past sometimes asked Linus, "why didn't you go to $foo.com 
website and download the patches?  they work for me!"  Same reason: 
it's unscalable.

For each step in the maintainership pyramid of trust, the number of 
people at that level decreases from the previous step.  Patches trickle 
-up- from sub-maintainers to maintainers to Andrew and finally Linus.

Thus, it is unreasonable for a kernel maintainer to poll $N mailing 
lists, coalesce the opinion, grok the code, make sure the code is at a 
point where it is OK to push upstream, and then push.  That's a 
one-to-many operation.

In contrast, a WORKING example of kernel development is a many-to-one 
process.  Driver maintainers send patches to subsystem maintainers. 
Subsystem maintainers send patches to higher-level subsystem 
maintainers.  High-level subsystem maintainers send patches to Andrew 
and Linus.

That's scalable.

	Jeff


