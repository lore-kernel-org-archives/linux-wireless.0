Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56364 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753311Ab2KQIr7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Nov 2012 03:47:59 -0500
Message-ID: <1353142108.9543.4.camel@jlt4.sipsolutions.net> (sfid-20121117_094804_313584_27347BD8)
Subject: Re: VHT support, take 2
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
Cc: Arend van Spriel <arend@broadcom.com>,
	Mahesh Palivela <maheshp@posedge.com>,
	linux-wireless@vger.kernel.org
Date: Sat, 17 Nov 2012 09:48:28 +0100
In-Reply-To: <20121117001046.GP3354@lenteja.do-not-panic.com>
References: <1352492254-29399-1-git-send-email-johannes@sipsolutions.net>
	 <1352492493.28302.7.camel@jlt4.sipsolutions.net>
	 <50A4DB80.2020209@posedge.com>
	 <1353072509.9490.7.camel@jlt4.sipsolutions.net>
	 <50A65443.2000101@broadcom.com>
	 <20121117001046.GP3354@lenteja.do-not-panic.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-11-16 at 16:10 -0800, Luis R. Rodriguez wrote:

> > >Yeah, actually I'm not sure it's that easy. We'll also need per
> > >bandwidth TX power restrictions, raise the 40 MHz bandwidth restriction
> > >to 160 MHz (or get rid of it entirely), etc. That seems to require a new
> > >regulatory database format?
> > 
> > Luis discussed the regulatory framework during the wireless summit
> > in Barcelona last week. My (possibly limited) recollection was that
> > the current regulatory code can accommodate VHT limits as well. I
> > assume that also includes the regulatory database format.
> 
> The only thing mentioned which I had not considered is the per bandwidth
> TX power restrictions. Where did these come from ?

As usual, they come from the regulations :-)

