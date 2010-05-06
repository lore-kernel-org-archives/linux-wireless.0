Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:46326 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757821Ab0EFMGj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 May 2010 08:06:39 -0400
Received: by mail-bw0-f219.google.com with SMTP id 19so448375bwz.21
        for <linux-wireless@vger.kernel.org>; Thu, 06 May 2010 05:06:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <p2ha32f33a41005060422xe89addc7s1e4de3f36ebd3278@mail.gmail.com>
References: <201005061301.22323.IvDoorn@gmail.com>
	 <s2o14add3d11005060412xf64df988x239517f049930d58@mail.gmail.com>
	 <p2ha32f33a41005060422xe89addc7s1e4de3f36ebd3278@mail.gmail.com>
Date: Thu, 6 May 2010 14:06:38 +0200
Message-ID: <z2ua32f33a41005060506haab3bkf008e23d6a42a48c@mail.gmail.com>
Subject: Re: [PATCH] rt2x00: Add 5GHz support for RF3052 devices
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: John Linville <linville@tuxdriver.com>
Cc: Gertjan van Wingerde <gwingerde@gmail.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John,

Please drop this patch. I just talked with Gertjan and I will be
sending an updated patch in a few minutes.

Ivo

On Thu, May 6, 2010 at 1:22 PM, Ivo Van Doorn <ivdoorn@gmail.com> wrote:
> On Thu, May 6, 2010 at 1:12 PM, Gertjan van Wingerde
> <gwingerde@gmail.com> wrote:
>> On Thu, May 6, 2010 at 1:01 PM, Ivo van Doorn <ivdoorn@gmail.com> wrote:
>>> According to the Ralink drivers, the RF3052 chipset
>>> supports the 5GHz band. Update channel initialization
>>> to add the corresponding channels for this chip.
>>>
>>> Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
>>
>> Actually, I believe that this is not correct (sorry I don't have the
>> Ralink driver at hand at the moment, nor the rt2x00 tree).
>
> Well the original Ralink driver does state this device is a 5GHz device.
>
>> AFAIK the RF3052 needs the same initialization as for RF3020, RF3021,
>> RF3022, etc extended with the correct values for
>> 5GHz band.
>
> RF3020 and RF3021 are 2.4GHz devices.
>
>> So, NAK for this patch.
>>
>> Also, please keep in mind that for proper RT3572 support more needs to
>> be done, also in the register, BPP, and RFCSR initializations.
>
> It could be that the initialization of RF3052 is incomplete, however that is not
> limited to the 5GHz feature, but for both bands. Note that the
> difference in initialization
> only exists for settings the antenna and channel which already detect
> if the initialization
> should be done on the 2.4 or 5 GHz band.
> So this argument shouldn't block this patch...
>
> Ivo
>
