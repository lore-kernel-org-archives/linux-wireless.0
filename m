Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bar.sig21.net ([80.81.252.164]:39409 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932209Ab1AKQfR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Jan 2011 11:35:17 -0500
Date: Tue, 11 Jan 2011 17:34:37 +0100
From: Johannes Stezenbach <js@sig21.net>
To: Kalle Valo <kvalo@adurom.com>
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
	Jason Andryuk <jandryuk@gmail.com>,
	linux-wireless@vger.kernel.org, Ivo Van Doorn <ivdoorn@gmail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>
Subject: Re: 5GHz 802.11n USB Adapter
Message-ID: <20110111163437.GA14223@sig21.net>
References: <AANLkTimj11OJRbjO2GBn=C36D7UDUURvguERS5XYoJ7W@mail.gmail.com>
 <201101101703.45802.helmut.schaa@googlemail.com>
 <87ipxvfqg1.fsf@purkki.adurom.net>
 <201101111557.46845.helmut.schaa@googlemail.com>
 <87ei8jfnq2.fsf@purkki.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <87ei8jfnq2.fsf@purkki.adurom.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 11, 2011 at 05:45:41PM +0200, Kalle Valo wrote:
> Helmut Schaa <helmut.schaa@googlemail.com> writes:
> 
> > And furthermore Johannes Stezenbach is interested in getting rt2800usb
> > to do the mc- and bc buffering correctly. Not sure if he already had a chance
> > to investigate more.
> 
> That would be the best option, but in the mean time we should disable
> AP mode.
> 
> During the years I have suffered so much from broken power save
> implementations in different access points. I really do not want us to
> do the same mistake.

That's fine by me.  At this time it is not clear if and when we
will have working support for mc- and bc buffering in rt2800usb.
I have one idea to try but no idea yet how well it will work.

Johannes
