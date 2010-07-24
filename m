Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:43262 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756462Ab0GXV0N (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 Jul 2010 17:26:13 -0400
Received: by wwj40 with SMTP id 40so5778487wwj.1
        for <linux-wireless@vger.kernel.org>; Sat, 24 Jul 2010 14:26:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4C474851.4000809@lwfinger.net>
References: <87vd88n1i8.fsf@gmail.com>
	<4C474851.4000809@lwfinger.net>
Date: Sat, 24 Jul 2010 22:26:11 +0100
Message-ID: <AANLkTinZG-kHrS-s_94Bq4JNXuyf6kWzqsVRAVjdGQ3c@mail.gmail.com>
Subject: Re: Master mode in rtl8187
From: Hin-Tak Leung <hintak.leung@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Ben Gamari <bgamari.foss@gmail.com>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 7/21/10, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> On 07/21/2010 01:17 PM, Ben Gamari wrote:
>> Hey all,
>>
>> I recently purchased a Netgear WG111v2 (based on rtl8187b) and after
>> seeing scattered reports[1] that master mode may be supported by the
>> rtl8187 driver. Unfortunately, hostapd throws up when it attempts to put
>> the card into master mode. Is master mode supported by this driver? I've
>> tried both 2.6.34 as well as the latest wireless-testing tree and
>> neither seem to work.
>
> My WG111V2 has an RTL8187L chip in it, not an RTL8187B. No, master mode is
> NOT
> supported by this driver. Adding that feature has been on my list of things
> to
> do, but the priority is very low. I really have little desire to convert my
> $600
> laptop into a $40 access point.
>
>> I noticed there was a patch[2] sent out a few years back, but it seems
>> no one followed up. While I don't have much experience working with
>> wireless hardware I've done kernel driver work before, so with some
>> guidance I might be able to finish up that patch. Any input would be
>> greatly appreciated. Thanks!
>
>> [1]
>> http://osdir.com/ml/linux.kernel.wireless.general/2007-07/msg00289.html
>> [2]
>> http://osdir.com/ml/linux.kernel.wireless.general/2007-06/msg00455.html
>
> That patch is useless. The rtl8187 driver and mac80211 have changed so much
> that
> it cannot be made to apply, and would not be likely to work.
>
> One other thing to consider. The RTL8187L has only a single transmit queue.
> Will
> the device be able to transmit beacons with an appropriate timing accuracy?
>
> To modify the driver, you will need to study some other driver that does
> work in
> master mode.

There were some discussion a while back that some generic master mode
support for all mac80211-based drivers might eventually happen.  Is
that still the case?

Hin-Tak
