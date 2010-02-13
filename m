Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:57350 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755174Ab0BMAK7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Feb 2010 19:10:59 -0500
Subject: Re: Coordinating development for Bluetooth 3.0 between 802.11 and
 BT trees
From: Marcel Holtmann <marcel@holtmann.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	linux-bluetooth <linux-bluetooth@vger.kernel.org>,
	Dan Tian <Dan.Tian@atheros.com>,
	Kevin Hayes <kevin@atheros.com>
In-Reply-To: <20100212183309.GB4983@tuxdriver.com>
References: <43e72e891002111210l55d6a802pc5a1384e3535c845@mail.gmail.com>
	 <20100212183309.GB4983@tuxdriver.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 13 Feb 2010 01:09:45 +0100
Message-ID: <1266019785.21559.28.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

> > Wanted to get your feedback on what you think would be the best
> > approach to take for focus on development for Bluetooth 3.0 support.
> > Hoping there is a better solution than using linux-next.
> 
> I'm sure Marcel and Johannes are way ahead of us on this. :-)
> 
> I think you covered the basics, but you did leave-out the possibility
> of using net-next-2.6 for bleeding-edge development of bluetooth 3.
> Since both Marcel and I feed Dave's tree and Dave endeavours to
> keep the history of that tree stable then this would seem like your
> best bet.

if we reach the point where any kind of coordination is needed between
your and my tree, I would just merge into wireless-next-2.6 tree instead
of net-next-2.6. That should solve most issues around this anyway. And
in case it doesn't we will always need manual interaction on one side.
So I wouldn't try to overthink this right now.

The only tricky part I see is wireless-testing since bluetooth-testing
is not immutable right now. And I don't have any intention to make it
that way.

Regards

Marcel


