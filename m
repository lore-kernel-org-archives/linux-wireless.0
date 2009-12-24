Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from blu0-omc2-s19.blu0.hotmail.com ([65.55.111.94]:35535 "EHLO
	blu0-omc2-s19.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750946AbZLXM3N convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Dec 2009 07:29:13 -0500
Message-ID: <BLU113-W510F730A634F5AC6F406DBE7F0@phx.gbl>
From: Mike Marchywka <marchywka@hotmail.com>
To: <julian.calaby@gmail.com>
CC: <larry.finger@lwfinger.net>, <netrolller.3d@gmail.com>,
	<linux-wireless@vger.kernel.org>
Subject: RE: I need a card that works reasonably easily with Debain- reccs?
Date: Thu, 24 Dec 2009 07:29:12 -0500
In-Reply-To: <646765f40912240348s64747772la4f80a945ab935d7@mail.gmail.com>
References: <BLU113-W7635FBD7855C5257B07E4BE820@phx.gbl>
 <69e28c910912210614v31edf6cej9abeddb17ab130d@mail.gmail.com>,<BLU113-W10113EE534A08128E43979BE820@phx.gbl>
 <4B2F9534.8020908@lwfinger.net>,<BLU113-W211E9D9EFD5458887F8CFFBE820@phx.gbl>,<646765f40912240348s64747772la4f80a945ab935d7@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>










----------------------------------------
> From: julian.calaby@gmail.com
> Date: Thu, 24 Dec 2009 22:48:17 +1100
> Subject: Re: I need a card that works reasonably easily with Debain- reccs?
> To: marchywka@hotmail.com
> CC: larry.finger@lwfinger.net; netrolller.3d@gmail.com; linux-wireless@vger.kernel.org
>
> On Tue, Dec 22, 2009 at 09:29, Mike Marchywka  wrote:
>>
>>
>>
>> This is the info for the card,
>> 04:06.0 Ethernet controller [0200]: Marvell Technology Group Ltd. 88w8335 [Libertas] 802.11b/g Wireless [11ab:1faa] (rev 03)
>
> Oh yes, the WG311 v3
>
> I have grappled with one of these cards in the past. There's been a
> couple of efforts (one on my part) to get a working open source driver
> off the ground, however none have (yet) borne fruit.
>
> Essentially, your only option is to either use a very specific kernel
> version and Marvell's official open source driver, or write your own
> from the bits and pieces of the others around.
>
> The Marvell driver can be found here: *note the version number*.
> http://git.infradead.org/users/dwmw2/marvell-db64660-2.6.12.6.git
>
> The (non-working) remains of one of the efforts can be found here:
> http://git.infradead.org/mrv8k-2.6.git
>
> If you're interested, I can dig up the other bits and pieces I have
> and send them to you. (None of these actually work, and the mrv8k
> driver is the most complete.)

Thanks but please don't go to any effort quite yet as this would be a learning
curve for me - I can handle UART's on a Z80 and embedded systems but this may take a bit :)
I would consider learning in background but it will take a while to create useful result.


>
> Also, the hardware may be similar enough to the Marvell TopDog
> hardware supported by the in-tree mwl8k driver that it can be used as
> a base.
>
> Personally, my solution to the issue of there being no drivers for
> this card was to try (and succeed) in making another wireless card I
> have work.

Right now I'm connecting through eth0 wired to a windoze machine with a wireless card.
Originally the linux machine was going to do this, as well as all the other cool stuff. 


>
>> but now that you have me going I would like to find a driver for this too,
>>
>> 04:07.0 Communication controller [0780]: Conexant Systems, Inc. HSF 56k Data/Fax Modem [14f1:2f20]
>
> You'll have to ask elsewhere for info on that, it doesn't seem to be a
> wireless card =)
>
> However, it does seem to be a PCI 56k Modem, which causes the big red
> warning lights to flash: it's likely to be a "winmodem" which means
> that it's a very *very* dumb card containing a trumped up DAC and ADC
> and the absolute minimum hardware to talk on a POTS line. In terms of
> drivers, this means that almost all the meat of a modem is implemented
> in software, so the driver needs to handle most of the conversion from
> data to be sent to the tones to send out on the POTS line *in
> software*. There are a couple of winmodem drivers floating around out
> there, but, as I understand it, there is no standard for these
> devices, so every brand (and possibly model) works differently.

Yeah, I've heard about the winmodems but I thought this was not one. 
It may in fact be easier to just use an old windoze machine to run junk like
this- cygwin ssh on these things should make them useful...



>
> Hopefully you have one of the better supported cards.


Any idea how hard it would be to write a bluetooth driver to use my blackerry storm
as a mouse? I could probably handle the BB code. LOL.

As far as that goes, for a tethered or even bluetooth device, are there modem drivers for
phones or if I want to use a cellular connection go usb modem? After all of this, I'm tempted
to try to get back my amateur radio license and see if I can connect through a VHF repeater 
somewhere LOL.



>
> Good Luck!
>
> Thanks,
>
> --
>
> Julian Calaby
>
> Email: julian.calaby@gmail.com
> .Plan: http://sites.google.com/site/juliancalaby/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at http://vger.kernel.org/majordomo-info.html
 		 	   		  
_________________________________________________________________
Hotmail: Free, trusted and rich email service.
http://clk.atdmt.com/GBL/go/171222984/direct/01/