Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate03.web.de ([217.72.192.234]:35366 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030882AbXDQTXd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Apr 2007 15:23:33 -0400
From: Chr <chunkeey@web.de>
To: Stefan Puch <stefan.puch@mail.uni-oldenburg.de>
Subject: Re: prism54: WPA/RSN support for fullmac cards
Date: Tue, 17 Apr 2007 21:23:30 +0200
References: <462336B1.4090006@mail.uni-oldenburg.de> <1176732546.27418.9.camel@localhost.localdomain> <4625130F.4090104@mail.uni-oldenburg.de>
In-Reply-To: <4625130F.4090104@mail.uni-oldenburg.de>
Cc: linux-net@vger.kernel.org, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200704172123.30956.chunkeey@web.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday, 17. April 2007 20:33, you wrote:
> http://www.spinics.net/lists/netdev/msg16224.html
> > 
> > That patch had some issues that I think were brought up in replies.  It
> > needs some cleanup.  If you see the "triggering due to management
> > timeout" thing, that's the card not replying to commands from the driver
> > quickly enough, meaning the firmware crashed or hung, and so the driver
> > resets the card.
> > 
> > Basically, somebody needs to go through the patch from Chunkeey and
> > extract the useful parts.  It wasn't the most easily readable patch and
> > there were some questionable decisions in there, but I don't think he
> > replied with rationale for some of the changes.
> > 
> > Dan
> 
> I thought that at least chunkeey got a working connection.... obviously not.
> 
Of course it works! But not with every AP... only with "hostapd".
(I don't have anything else to try).



But please, before you waste your time with _some_ fullmac anomalies,

get the last wireless-dev.git tree. 
There is a SOFTMAC driver for all prism54 chips now! 

You only need a firmware: 
http://daemonizer.de/prism54/prism54-fw/fw-softmac/lmac_2.7.0.0.arm
(rename it to "isl3886" and put it in the right place).

> Is there anything else I can do if I'm no Kernel Programmer (perhaps provide
> more infos, do some other beta testings)?
> 
> When I looked on the prism54.org homepage or their svn-repository it seems that
> the driver is not developed any longer.
> What is about Christian Lamparter (chunkee) or Luis R. Rodriguez (mcgrof) are
> they still working on it?
> 
> Regards Stefan
