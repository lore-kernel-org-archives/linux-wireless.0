Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtpsrv03.uni-oldenburg.de ([134.106.87.11]:42709 "EHLO
	smtpsrv03.uni-oldenburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1031135AbXDQSt3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Apr 2007 14:49:29 -0400
Message-ID: <4625130F.4090104@mail.uni-oldenburg.de>
Date: Tue, 17 Apr 2007 20:33:51 +0200
From: Stefan Puch <stefan.puch@mail.uni-oldenburg.de>
MIME-Version: 1.0
To: linux-net@vger.kernel.org
CC: linux-wireless@vger.kernel.org
Subject: Re: prism54: WPA/RSN support for fullmac cards
References: <462336B1.4090006@mail.uni-oldenburg.de>	 <20070416135513.GA6484@tuxdriver.com> <1176732546.27418.9.camel@localhost.localdomain>
In-Reply-To: <1176732546.27418.9.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

http://www.spinics.net/lists/netdev/msg16224.html
> 
> That patch had some issues that I think were brought up in replies.  It
> needs some cleanup.  If you see the "triggering due to management
> timeout" thing, that's the card not replying to commands from the driver
> quickly enough, meaning the firmware crashed or hung, and so the driver
> resets the card.
> 
> Basically, somebody needs to go through the patch from Chunkeey and
> extract the useful parts.  It wasn't the most easily readable patch and
> there were some questionable decisions in there, but I don't think he
> replied with rationale for some of the changes.
> 
> Dan

I thought that at least chunkeey got a working connection.... obviously not.

Is there anything else I can do if I'm no Kernel Programmer (perhaps provide
more infos, do some other beta testings)?

When I looked on the prism54.org homepage or their svn-repository it seems that
the driver is not developed any longer.
What is about Christian Lamparter (chunkee) or Luis R. Rodriguez (mcgrof) are
they still working on it?

Regards Stefan
