Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qa0-f46.google.com ([209.85.216.46]:57274 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754308Ab2G3PSr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jul 2012 11:18:47 -0400
Received: by qadb17 with SMTP id b17so975835qad.19
        for <linux-wireless@vger.kernel.org>; Mon, 30 Jul 2012 08:18:46 -0700 (PDT)
Message-ID: <5016A5D3.10301@lwfinger.net> (sfid-20120730_171937_216808_C0BD1B51)
Date: Mon, 30 Jul 2012 10:18:43 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Marco <netuse@lavabit.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: RTL8187 in master mode with hostapd
References: <20120727171137.4a1d1ce7@homerow> <501405FA.3070504@lwfinger.net> <20120728211613.45ca10fa@homerow>
In-Reply-To: <20120728211613.45ca10fa@homerow>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/28/2012 02:16 PM, Marco wrote:
> On 2012-07-28 Larry Finger
> <Larry.Finger@lwfinger.net> wrote:
>
> Hi Larry,
>
>> In the case of the RTL8187L, which is the chip in your Alfa device, it means
>> *never*.
>
> Thanks for this straightforward answer. In this case it makes sense
> to change the point AP/Master mode on the driver description page
>
> http://linuxwireless.org/en/users/Drivers/rtl8187
>
> from “not working yet” to “not supported”.
>
>> That chip only has a single hardware transmit queue and the work of
>> getting the high-priority traffic, such as beacons, transmitted at the correct
>> time would be much more than it would be worth.
>
> I wasn't aware of that when I bought the device.
>
> It might be off-topic here, but what chip (or device) would you
> recommend instead, for use in an AP? It has to be connected via USB,
> support master mode and, only if possible, run without the need of
> proprietary firmware.
>
>
> Thanks for taking the time to deal with my issue.

As far as I know, there are no USB devices that meet all of your requirements. 
If you relax the one about external firmware, then any of the USB devices that 
run rt2800usb (Ralink) should support master mode. I'm not at home now and do 
not have mine with me, thus I cannot give you a make/model. An older dual-band 
model is the Dell 1450U. These are available new on E-bay for $10. Perhaps 
someone else on this list can suggest other specific models. I am quite certain 
that Atheros also has such devices.

Larry

