Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:47370 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753018Ab1EGCbM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 May 2011 22:31:12 -0400
Received: by vxi39 with SMTP id 39so4006195vxi.19
        for <linux-wireless@vger.kernel.org>; Fri, 06 May 2011 19:31:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4DC47C04.1080604@candelatech.com>
References: <4DBF1967.9010604@candelatech.com>
	<BANLkTimYks_+QRUNURtbRy+S941fL04HRQ@mail.gmail.com>
	<4DC042A5.9050806@candelatech.com>
	<BANLkTikuw4uSOL5zoMa9QzOsajnSyhEsGQ@mail.gmail.com>
	<4DC17DAE.9020808@candelatech.com>
	<4DC47C04.1080604@candelatech.com>
Date: Sat, 7 May 2011 10:31:09 +0800
Message-ID: <BANLkTiknUzyadwRLHbEZ4zLkVCmC5A7zKA@mail.gmail.com> (sfid-20110507_043115_760880_645B29B1)
Subject: Re: Looking for 3x3 Atheros NICs using ath9k driver.
From: Adrian Chadd <adrian@freebsd.org>
To: Ben Greear <greearb@candelatech.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	ath9k-devel <ath9k-devel@lists.ath9k.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 7 May 2011 06:53, Ben Greear <greearb@candelatech.com> wrote:

[top post]

Ok, there's likely some PCI init bugs going on here; would someone
with more background in this please take a look?



Adrian

>>> This and the previous AR93xx "0xabcd" device id post is starting to
>>> sound a lot like something's not waking up the PCI bus and/or chip
>>> "right" in order to get the PCI vendor id init'ed from the EEPROM..
>>
>> Well, I put in one NIC, it works fine, I put in the other, and it doesn't.
>>
>> Same system, reproducible on other systems from same manufacturer
>> (Lanner, LEC 2010E).
>>
>> Haven't tried it on a totally different motherboard. I'll send you this
>> broken NIC if you want...I'm too tight on time to hack on it now...
>
> So, you were right.  I put this NIC in another system (VIA C3) and it comes
> up
> as AR9160 and loads ath9k driver just fine.
>
> 00:0c.0 Network controller: Atheros Communications Inc. AR9160 802.11abgn
> Wireless PCI Adapter (rev 01)
>        Subsystem: Device 0777:4082
>        Flags: bus master, 66MHz, medium devsel, latency 168, IRQ 18
>        Memory at f6000000 (32-bit, non-prefetchable) [size=64K]
>        Capabilities: [44] Power Management version 2
>        Kernel driver in use: ath9k
>        Kernel modules: ath9k
>
> Thanks,
> Ben
>
>>
>> Ben
>>
>>
>
>
> --
> Ben Greear <greearb@candelatech.com>
> Candela Technologies Inc  http://www.candelatech.com
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
