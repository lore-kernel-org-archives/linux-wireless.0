Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:45624 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751112Ab1EDQYQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 May 2011 12:24:16 -0400
Message-ID: <4DC17DAE.9020808@candelatech.com> (sfid-20110504_182420_728896_096C7375)
Date: Wed, 04 May 2011 09:24:14 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Adrian Chadd <adrian@freebsd.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Looking for 3x3 Atheros NICs using ath9k driver.
References: <4DBF1967.9010604@candelatech.com>	<BANLkTimYks_+QRUNURtbRy+S941fL04HRQ@mail.gmail.com>	<4DC042A5.9050806@candelatech.com> <BANLkTikuw4uSOL5zoMa9QzOsajnSyhEsGQ@mail.gmail.com>
In-Reply-To: <BANLkTikuw4uSOL5zoMa9QzOsajnSyhEsGQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/04/2011 09:16 AM, Adrian Chadd wrote:
> On 4 May 2011 02:00, Ben Greear<greearb@candelatech.com>  wrote:
>
>> Here's the lspci for the SR71-A that doesn't work with ath9k:
>>
>> 03:00.0 Ethernet controller: Atheros Communications Inc. AR5008 Wireless
>> Network Adapter (rev 01)
>>         Subsystem: Atheros Communications Inc. Device ee1c
>
> ... ee1c? Err, that isn't right. Not by a very, very long shot.
>
> What board are you putting this into?
>
>> From FreeBSD on a RSPRO (ar71xx mips):
>
> ath0@pci0:0:17:0:       class=0x028000 card=0x40820777 chip=0x0027168c
> rev=0x01 hdr=0x00
>      vendor     = 'Atheros Communications Inc.'
>      class      = network
>
> That definitely, positively is the same AC1A revision that you have.
> It even does 11n(ag) too. Honest. I've seen it. :-)
>
> This and the previous AR93xx "0xabcd" device id post is starting to
> sound a lot like something's not waking up the PCI bus and/or chip
> "right" in order to get the PCI vendor id init'ed from the EEPROM..

Well, I put in one NIC, it works fine, I put in the other, and it doesn't.

Same system, reproducible on other systems from same manufacturer (Lanner, LEC 2010E).

Haven't tried it on a totally different motherboard.  I'll send you this
broken NIC if you want...I'm too tight on time to hack on it now...

Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

