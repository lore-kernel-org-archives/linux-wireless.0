Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from madara.hpl.hp.com ([192.6.19.124]:52946 "EHLO madara.hpl.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753876AbXKTRnq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Nov 2007 12:43:46 -0500
Date: Tue, 20 Nov 2007 09:43:30 -0800
To: David Miller <davem@davemloft.net>
Cc: johannes@sipsolutions.net, shaddy_baddah@hotmail.com,
	linux-wireless@vger.kernel.org, dsd@gentoo.org
Subject: Re: zd1211rw (2.6.22 sparc64): unaligned access (do_rx)
Message-ID: <20071120174330.GB1480@bougret.hpl.hp.com> (sfid-20071120_174350_491220_A9140CD2)
Reply-To: jt@hpl.hp.com
References: <1195484582.8642.18.camel@johannes.berg> <20071119.142046.188284555.davem@davemloft.net> <20071119223554.GA21844@bougret.hpl.hp.com> <20071119.234201.19874188.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20071119.234201.19874188.davem@davemloft.net>
From: Jean Tourrilhes <jt@hpl.hp.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 19, 2007 at 11:42:01PM -0800, David Miller wrote:
> From: Jean Tourrilhes <jt@hpl.hp.com>
> Date: Mon, 19 Nov 2007 14:35:54 -0800
> 
> > I don't have a 64 bit box.
> 
> Let me know when you have joined us in the 21st century.

	Well, if you are so rich, please send me a new computer. I'm
not paid to do any of this stuff.

> > Bug reports are *very* difficult to get because
> 
> I guess writing a dummy wireless driver with just some printk()'s and
> some test userland programs to make sure the data goes to and
> from the handlers with the proper layout is thinking way too far
> outside the box for you.

	There is no point for that. The difficulty is finding out that
there is a problem. To find out that there is a problem, it's
sufficient to run a standard driver, no need for a dummy
driver. People already have little incentive to run real wireless
drivers on 64 bit boxes, I don't see who they would run dummy drivers.

> Nothing using iw_point in these request objects can possibly work in
> compat situations, for example.  I think it works by accident on
> little-endian.

	As I was saying, we made a lot of progress in the last few
months. And it works.

	Jean

