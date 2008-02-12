Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.176]:58272 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751361AbYBLMSO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Feb 2008 07:18:14 -0500
Received: by wa-out-1112.google.com with SMTP id v27so2741723wah.23
        for <linux-wireless@vger.kernel.org>; Tue, 12 Feb 2008 04:18:13 -0800 (PST)
Message-ID: <60381eeb0802120418o4225424cp490a4ff8fb9d1827@mail.gmail.com> (sfid-20080212_121827_587372_B82789CE)
Date: Tue, 12 Feb 2008 14:18:12 +0200
From: "=?UTF-8?Q?Eddy_Petri=C8=99or?=" <eddy.petrisor@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: Re: madwifi is not fully open source
In-Reply-To: <200802121013.47142.hs4233@mail.mn-solutions.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <57314e840802111427i7e8d00capbe430727faff78a1@mail.gmail.com>
	 <1202770112.6824.35.camel@localhost.localdomain>
	 <57314e840802120045h6e6960d8jde5657da8aff0e3e@mail.gmail.com>
	 <200802121013.47142.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/02/2008, Holger Schurig <hs4233@mail.mn-solutions.de> wrote:
> If your device really doesn't have a firmware (some claim
> firmware is necessary to ensure real-time properties of the
> protocol) then you could also do:
>
> 4. write the driver for Windows in the usual, close source
>    form, "leak" or give docs to some Linux developers and
>    let they write the driver for the device. FCC can't object,
>    you didn't wrote the driver :-)

I don't see any reason (except finaincial) for a chip to have what is
currently, for many drivers, in firmware, already in a
ROM/EEPROM/Flash on the device.

Firmware upgrades can be made via some upgrade tool (please provide
such a tool for linux, too, even if closed source).

> Chances are actually quite high that the Linux people write a
> better driver than you :-)
>
>
> Did you know about Greg Kroah-Hahn's "driver for free" incentive?
> http://www.kroah.com/log/linux/free_drivers.html

I think the canonical place for wireless drivers is
http://linuxwireless.org/en/vendors/DriverDevelopment

-- 
Regards,
EddyP
=============================================
"Imagination is more important than knowledge" A.Einstein
