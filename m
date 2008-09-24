Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:33559 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750875AbYIXHkn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Sep 2008 03:40:43 -0400
Subject: Re: [RFC][PATCH] TX status reporting with help of an ack queue
From: Mattias Nissler <mattias.nissler@gmx.de>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Ivo van Doorn <ivdoorn@gmail.com>,
	Mikko =?ISO-8859-1?Q?Virkkil=E4?= <mikko.virkkila@bluegiga.com>,
	rt2400-devel@lists.sourceforge.net,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <20080924005931.GB3780@tuxdriver.com>
References: <200809151911.32834.IvDoorn@gmail.com>
	 <1221501417.4511.49.camel@localhost>
	 <1221501786.3700.68.camel@johannes.berg>
	 <1221505251.4511.77.camel@localhost>
	 <1221506496.3700.81.camel@johannes.berg>
	 <1221507551.4511.89.camel@localhost>
	 <1221507988.3700.84.camel@johannes.berg>
	 <1221510009.4511.99.camel@localhost>
	 <1221510785.3700.87.camel@johannes.berg>
	 <1221512487.4511.105.camel@localhost> <20080924005931.GB3780@tuxdriver.com>
Content-Type: text/plain
Date: Wed, 24 Sep 2008 09:40:40 +0200
Message-Id: <1222242040.4183.1.camel@localhost> (sfid-20080924_094048_053235_0BDFAA59)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2008-09-23 at 20:59 -0400, John W. Linville wrote:
> On Mon, Sep 15, 2008 at 11:01:27PM +0200, Mattias Nissler wrote:
> 
> > Btw. lately I've been thinking about a new RC algo that simply
> > calculates the throughput achievable by a specific rate (based on the
> > estimated frame transmission failure ratio and transmission times) and
> > then selects the one that provides the best throughput. It's still a
> > very vague idea, but I think it might be interesting to try.
> 
> This sounds like a reasonable approach.  Isn't this more-or-less what
> Minstrel does?

I just checked Minstrel out. Seems quite like what I had in mind :-) Are
there any efforts to port minstrel to mac80211?

Mattias

