Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:41744 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751560Ab1GOWtF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Jul 2011 18:49:05 -0400
Message-ID: <4E20C3DC.3020200@gnu.org> (sfid-20110716_005149_371117_00B679B5)
Date: Fri, 15 Jul 2011 18:49:00 -0400
From: Pavel Roskin <proski@gnu.org>
MIME-Version: 1.0
To: Pavel Roskin <proski@gnu.org>
CC: Christian Lamparter <chunkeey@googlemail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: Binary for carl9170
References: <CACAiNS3-3K06Cro+VWypyWGetUW-v0qeJ29noXi7WNtUaCWzTw@mail.gmail.com> <201107151509.23258.chunkeey@googlemail.com> <4E2072BF.6000306@gnu.org> <201107152039.07294.chunkeey@googlemail.com> <20110715151642.0j86tyrj4k0g4sg4-cebfxv@webmail.spamcop.net>
In-Reply-To: <20110715151642.0j86tyrj4k0g4sg4-cebfxv@webmail.spamcop.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/15/2011 03:16 PM, Pavel Roskin wrote:
> Quoting Christian Lamparter <chunkeey@googlemail.com>:
>
>> So, since you already have a working version, why simply put it on the
>> wiki?
>
> Yes, I have a working version now (compiled with all defaults) and I'll
> try to upload it myself.

Oh well, I can upload it to wiki, but not to your page at 
http://www.kernel.org/pub/linux/kernel/people/chr/carl9170/fw/

That page is linked to on
http://linuxwireless.org/en/users/Drivers/carl9170.fw

I don't want to setup an alternative competing repository for carl9170 
firmwares.

The wiki allows attachments, so I uploaded the firmware as an 
attachment.  First I put is on the main carl9170 page, but it turned out 
that MoinMoin doesn't appear to have any way to specify the attachment 
name in the link.  Since I called the attachment "carl9170-1.fw-1.9.4", 
it would only download under that name, rather than as "carl9170-1.fw". 
  I don't want to call the attachment "carl9170-1.fw" since nobody, 
including me, would be able to replace it with another version ever.

So I created a separate wiki page for the 1.9.4 version of the firmware 
and attached the firmware to it as "carl9170-1.fw".  That's an 
equivalent of having directories with files having the same name.

The carl9170 page recommends 1.9.2 for all kernels up to 3.0.  The 1.9.4 
is recommended for compat-wireless.  If that's not your recommendation, 
please feel free to update the wiki.

I was able to verify that carl9170 from the Fedora kernel 
2.6.38.8-35.fc15.x86_64 works with firmware 1.9.4, even though it 
complains about unsupported features:

[  117.159395] usb 1-7: driver   API: 1.9.0 2010-10-29 [1-1]
[  117.164830] usb 1-7: firmware API: 1.9.4 2011-06-30
[  117.169740] usb 1-7: Unprotected firmware image.
[  117.174375] usb 1-7: driver does not support all firmware features.

Perhaps we could recommend 1.9.4 for more kernels?

Also, it would be nice to have the 1.9.4 firmware on 
http://www.kernel.org/pub/linux/kernel/people/chr/carl9170/fw/

-- 
Regards,
Pavel Roskin
