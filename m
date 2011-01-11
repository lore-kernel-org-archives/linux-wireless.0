Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:36690 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753799Ab1AKO7G (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Jan 2011 09:59:06 -0500
Received: by bwz15 with SMTP id 15so20164165bwz.19
        for <linux-wireless@vger.kernel.org>; Tue, 11 Jan 2011 06:59:05 -0800 (PST)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Kalle Valo <kvalo@adurom.com>
Subject: Re: 5GHz 802.11n USB Adapter
Date: Tue, 11 Jan 2011 15:57:46 +0100
Cc: Jason Andryuk <jandryuk@gmail.com>, linux-wireless@vger.kernel.org,
	Ivo Van Doorn <ivdoorn@gmail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	Johannes Stezenbach <js@sig21.net>
References: <AANLkTimj11OJRbjO2GBn=C36D7UDUURvguERS5XYoJ7W@mail.gmail.com> <201101101703.45802.helmut.schaa@googlemail.com> <87ipxvfqg1.fsf@purkki.adurom.net>
In-Reply-To: <87ipxvfqg1.fsf@purkki.adurom.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201101111557.46845.helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Dienstag, 11. Januar 2011 schrieb Kalle Valo:
> Helmut Schaa <helmut.schaa@googlemail.com> writes:
> 
> >> If some hardware models don't support broadcast/multicast buffering in
> >> that case the driver shouldn't allow AP mode, at least not in mainline
> >> kernels. We shouldn't break the standarnd knowingly.
> >> 
> >> From a quick grep it looks like rt2800usb enables AP mode. Is that the
> >> case or did I misunderstood something?
> >
> > You're right, rt2800usb enables AP mode despite the lack of proper
> > mc- and bc buffering.
> 
> Ok, thanks. I'll try to come up with a patch which disables AP mode
> for rt2800usb.

Fine with me but AFAIK there are quite some users out there that use rt2800usb
in AP mode. In the end Ivo or Gertjan should have a chance to comment ;)

And furthermore Johannes Stezenbach is interested in getting rt2800usb
to do the mc- and bc buffering correctly. Not sure if he already had a chance
to investigate more.

Helmut
