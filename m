Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:47345 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755124Ab3LFJKZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Dec 2013 04:10:25 -0500
Message-ID: <52A1923F.40806@broadcom.com> (sfid-20131206_101101_469111_A75DE568)
Date: Fri, 6 Dec 2013 10:00:47 +0100
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Julian Calaby <julian.calaby@gmail.com>
CC: <linux-sunxi@googlegroups.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [linux-sunxi] Firmware for Bluetooth (and wifi)
References: <52A040CE.5040706@schinagl.nl> <CAFXj5xjJ0DTa0Qo1avLboQF-e3TFv3aEr_jjkuZjinwuTzXykQ@mail.gmail.com> <52A09B5B.70800@schinagl.nl> <CAGRGNgWBgWqoPUdHSm2OXGb8r-ca5NX2z4_v0eG6oOMgJRd3HQ@mail.gmail.com>
In-Reply-To: <CAGRGNgWBgWqoPUdHSm2OXGb8r-ca5NX2z4_v0eG6oOMgJRd3HQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/05/2013 10:46 PM, Julian Calaby wrote:
> Hi Arend,
>
> I watch the linux-sunxi list where we're trying to support a certain
> family of ARM chips and the boards they're on with open source,
> community maintained kernels. They're at the cheaper end of the
> spectrum so they usually end up with chipsets which are bought for
> their price point and Android compatibility, not their ease of use by
> people doing "generic" Linux.
>
> On Fri, Dec 6, 2013 at 2:27 AM, Olliver Schinagl
> <oliver+list@schinagl.nl> wrote:
>> On 05-12-13 14:25, Neal Peacock wrote:
>>>
>>>
>>> On Dec 5, 2013 4:02 AM, "Olliver Schinagl" <oliver+list@schinagl.nl
>>> <mailto:oliver%2Blist@schinagl.nl>> wrote:
>>>   >
>>>   > Hey Benn,
>>>   >
>>>   > it appears as if the bluetooth module requires specific firmware to
>>> operate, it's likly the FM module requires it too?
>>>   >
>>>   > Can you confirm this or wether the firmware for the wifi module also
>>> contains the BT and FM firmwares?
>>>   >
>>> Which WiFi chip is this for?
>>
>> Wifi is mostly handled by extracting it from the broadcom drivers I belive
>> via a script, but BT we are in the dark for.
>
> So, the AMPAK AP6210 Wifi+BT combo device contains one of:
> 1. BCM43362 / BCM20710
> 2. BCM4330 / BCM40183
> 3. BCM4329 / BCM40181
>
> Depending on who you talk to. I can only find one reference for
> options #1 and #3, so I suspect it's the BCM4330 based chipset,
> however I don't have one of these I can crack open so I'm not sure.

All these options are SDIO, right?

> Firstly, are there any plans to support the BCM43362 chipset with the
> brcmfmac driver in the near future?

We had someone from the community asking about that earlier and it 
looked trivial to add it. I will get back on this.

> Secondly, is there an upstream driver for the bluetooth parts of these
> chipsets, and if so, do we need firmware and where can we get it from?
> If there isn't, are there any plans to add support for them?

The BT part is done by another group within broadcom so I have no idea 
about their plans. I suspect they can be supported by generic btsdio 
driver, but I may be totally mistaken.

Gr. AvS
