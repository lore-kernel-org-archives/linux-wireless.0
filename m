Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:48073 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932407Ab1AKQjt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Jan 2011 11:39:49 -0500
Received: by qyj19 with SMTP id 19so3094925qyj.19
        for <linux-wireless@vger.kernel.org>; Tue, 11 Jan 2011 08:39:48 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <87ei8jfnq2.fsf@purkki.adurom.net>
References: <AANLkTimj11OJRbjO2GBn=C36D7UDUURvguERS5XYoJ7W@mail.gmail.com>
	<201101101703.45802.helmut.schaa@googlemail.com>
	<87ipxvfqg1.fsf@purkki.adurom.net>
	<201101111557.46845.helmut.schaa@googlemail.com>
	<87ei8jfnq2.fsf@purkki.adurom.net>
Date: Tue, 11 Jan 2011 17:39:48 +0100
Message-ID: <AANLkTi=n49bXON7i9ec_UGLwMpr2+963CGOudkMphnMt@mail.gmail.com>
Subject: Re: 5GHz 802.11n USB Adapter
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: Kalle Valo <kvalo@adurom.com>
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
	Jason Andryuk <jandryuk@gmail.com>,
	linux-wireless@vger.kernel.org,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	Johannes Stezenbach <js@sig21.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

>> Fine with me but AFAIK there are quite some users out there that use
>> rt2800usb in AP mode.
>
> Yeah, but they are using a broken implementation and will have random
> problems because of missing broadcast and multicast packets, for
> example ARP is a likely problem area. We discussed about this last
> year, I think.
>
>> In the end Ivo or Gertjan should have a chance to comment ;)
>
> Naturally :)
>
>> And furthermore Johannes Stezenbach is interested in getting rt2800usb
>> to do the mc- and bc buffering correctly. Not sure if he already had a chance
>> to investigate more.
>
> That would be the best option, but in the mean time we should disable
> AP mode.

Ok, but please don't restrict only to rt2800usb then. Basically _all_ rt2x00 USB
drivers are not functioning. Also I assume it means that also Mesh
mode, Secondary,
and Ad-hoc should also be disabled?

Ivo
