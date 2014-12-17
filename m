Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:36795 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750946AbaLQQUZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Dec 2014 11:20:25 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 8.1 \(1993\))
Subject: Re: changes to Linux wireless maintenance
From: Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20141217155951.GA3144@tuxdriver.com>
Date: Wed, 17 Dec 2014 17:16:56 +0100
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	BlueZ development <linux-bluetooth@vger.kernel.org>,
	"linux-nfc@ml01.01.org NFC" <linux-nfc@ml01.01.org>,
	"David S. Miller" <davem@davemloft.net>,
	Kalle Valo <kvalo@codeaurora.org>, lwn@lwn.net
Message-Id: <A58A225C-55A5-4549-BF80-95DC158FDD6E@holtmann.org> (sfid-20141217_172032_512033_700A4543)
References: <20141217155951.GA3144@tuxdriver.com>
To: "John W. Linville" <linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

> Almost 9 years ago, Jeff Garzik wrote a message on LKML detailing
> the sad state of wireless LANs in the Linux world.  The point of his
> message was "So... there it is.  We suck.  There's hope.  No Luke
> Skywalker in sight.":
> 
> 	https://lkml.org/lkml/2006/1/5/671
> 
> Shortly thereafter, I became the maintainer for wireless LANs in the
> Linux kernel:
> 
> 	https://lkml.org/lkml/2006/1/18/377
> 
> Since then, we have had a number of wireless summit meetings all around
> the world.  Items were discussed, patches were merged, and friendships
> were made.  Over time, we garnered support from a large range of
> wireless networking vendors.  Eventually even other technologies
> were sending their patches through my trees, and I was consistently
> ranked amongst the top 10 "gate keepers" for getting changes into the
> Linux kernel.  In fact, a couple of years ago I even gave a talk on
> how Linux wireless got better.	It has been quite a ride!
> 
> 	https://events.linuxfoundation.org/images/stories/pdf/lfcs2012_linville.pdf
> 
> Nevertheless, I think it is time for some changes.  I have been
> the wireless maintainer for a long time, and I personally would
> like to develop in a different direction.  Plus, I think that Linux
> will benefit from having some fresh blood involved in more of the
> maintenance duties.  I will be stepping aside to let that happen.
> 
> The mac80211, bluetooth, and nfc trees have fed through me for some
> time.  I am now asking these trees to send pull request directly to
> David Miller.  Since these trees are managed through git, my hope is
> that they will not place any significant burden on Dave.

it has been a pleasure merging Bluetooth (and lately IEEE 802.15.4 and 6LoWPAN) patches through the Wireless tree. Thank you so much for all your hard work in making it easy for the sub-subsystem maintainers. Hope you find some new fun stuff to work on.

Regards

Marcel

