Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:51545 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753837Ab1AKPpm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Jan 2011 10:45:42 -0500
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: Jason Andryuk <jandryuk@gmail.com>, linux-wireless@vger.kernel.org,
	Ivo Van Doorn <ivdoorn@gmail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	Johannes Stezenbach <js@sig21.net>
Subject: Re: 5GHz 802.11n USB Adapter
References: <AANLkTimj11OJRbjO2GBn=C36D7UDUURvguERS5XYoJ7W@mail.gmail.com>
	<201101101703.45802.helmut.schaa@googlemail.com>
	<87ipxvfqg1.fsf@purkki.adurom.net>
	<201101111557.46845.helmut.schaa@googlemail.com>
From: Kalle Valo <kvalo@adurom.com>
Date: Tue, 11 Jan 2011 17:45:41 +0200
In-Reply-To: <201101111557.46845.helmut.schaa@googlemail.com> (Helmut Schaa's message of "Tue\, 11 Jan 2011 15\:57\:46 +0100")
Message-ID: <87ei8jfnq2.fsf@purkki.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Helmut Schaa <helmut.schaa@googlemail.com> writes:

> Am Dienstag, 11. Januar 2011 schrieb Kalle Valo:
>> Helmut Schaa <helmut.schaa@googlemail.com> writes:
>> 
>> Ok, thanks. I'll try to come up with a patch which disables AP mode
>> for rt2800usb.
>
> Fine with me but AFAIK there are quite some users out there that use
> rt2800usb in AP mode.

Yeah, but they are using a broken implementation and will have random
problems because of missing broadcast and multicast packets, for
example ARP is a likely problem area. We discussed about this last
year, I think.

> In the end Ivo or Gertjan should have a chance to comment ;)

Naturally :)

> And furthermore Johannes Stezenbach is interested in getting rt2800usb
> to do the mc- and bc buffering correctly. Not sure if he already had a chance
> to investigate more.

That would be the best option, but in the mean time we should disable
AP mode.

During the years I have suffered so much from broken power save
implementations in different access points. I really do not want us to
do the same mistake.

-- 
Kalle Valo
