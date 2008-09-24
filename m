Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:37583 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751535AbYIXA6o (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Sep 2008 20:58:44 -0400
Date: Tue, 23 Sep 2008 20:59:31 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Mattias Nissler <mattias.nissler@gmx.de>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Ivo van Doorn <ivdoorn@gmail.com>,
	Mikko =?iso-8859-1?Q?Virkkil=E4?= <mikko.virkkila@bluegiga.com>,
	rt2400-devel@lists.sourceforge.net,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [RFC][PATCH] TX status reporting with help of an ack queue
Message-ID: <20080924005931.GB3780@tuxdriver.com> (sfid-20080924_025854_960733_3F95C9B8)
References: <200809151911.32834.IvDoorn@gmail.com> <1221501417.4511.49.camel@localhost> <1221501786.3700.68.camel@johannes.berg> <1221505251.4511.77.camel@localhost> <1221506496.3700.81.camel@johannes.berg> <1221507551.4511.89.camel@localhost> <1221507988.3700.84.camel@johannes.berg> <1221510009.4511.99.camel@localhost> <1221510785.3700.87.camel@johannes.berg> <1221512487.4511.105.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1221512487.4511.105.camel@localhost>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 15, 2008 at 11:01:27PM +0200, Mattias Nissler wrote:

> Btw. lately I've been thinking about a new RC algo that simply
> calculates the throughput achievable by a specific rate (based on the
> estimated frame transmission failure ratio and transmission times) and
> then selects the one that provides the best throughput. It's still a
> very vague idea, but I think it might be interesting to try.

This sounds like a reasonable approach.  Isn't this more-or-less what
Minstrel does?

John
-- 
John W. Linville		Linux should be at the core
linville@tuxdriver.com			of your literate lifestyle.
