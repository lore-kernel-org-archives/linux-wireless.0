Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:42046 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752332Ab0IVRR5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Sep 2010 13:17:57 -0400
Message-ID: <4C9A3A1C.4010704@candelatech.com>
Date: Wed, 22 Sep 2010 10:17:16 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: =?UTF-8?B?TWljaGFlbCBCw7xzY2g=?= <mb@bu3sch.de>,
	Christian Lamparter <chunkeey@googlemail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Daniel Berger <daniel@dat-berger.de>,
	linux-wireless@vger.kernel.org
Subject: Re: Manual Control about Sending ACKs
References: <20100922123953.67a4fc5e@danmob> <20100922130245.GC5515@tuxdriver.com> <201009221545.41377.chunkeey@googlemail.com> <1285163687.15806.9.camel@maggie> <AANLkTinr0omWQCaMj91P8=CFZLDLroxWdrV2c=9KjG4e@mail.gmail.com>
In-Reply-To: <AANLkTinr0omWQCaMj91P8=CFZLDLroxWdrV2c=9KjG4e@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/22/2010 10:12 AM, Luis R. Rodriguez wrote:
> On Wed, Sep 22, 2010 at 6:54 AM, Michael Büsch<mb@bu3sch.de>  wrote:
>> On Wed, 2010-09-22 at 15:45 +0200, Christian Lamparter wrote:
>>
>>>> I suspect you need to be looking at hacking firmware.
>>>> You might look at the open-source ar9170 firmware
>>>> or the b43-openfwwf project.
>>>
>>> probably not ar9170 either.
>>> The ACK - mechanism (response control) is mostly hardwired in
>>> the chip, there is not much to control here.
>>
>> The ack mechanism is implemented in firmware for the b43 chip and I
>> think it's understood pretty much completely how ACKing works in
>> the firmware. So you may want to take a look at b43-openfwwf.
>> The guys who created b43-openfwwf also experimented with this
>> kind of stuff, so you might want to contact them.
>
> You can also look at ath_hw_set_bssid_mask() for ath5k, ath9k, which

Just in case I'm missing something:  It doesn't appear that upstream ath5k has any
support for virtual interfaces?  I'm trying to get ath5k working
now, based on my .31 patches...

Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

