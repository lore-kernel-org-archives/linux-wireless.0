Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lmv.inov.pt ([146.193.64.2]:58614 "EHLO lmv.inov.pt"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751434Ab3GJONA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Jul 2013 10:13:00 -0400
Message-ID: <51DD6BCB.9000704@inov.pt> (sfid-20130710_161304_690503_4D18D08D)
Date: Wed, 10 Jul 2013 15:12:27 +0100
From: =?UTF-8?B?Sm9zw6kgTWlndWVsIEdvbsOnYWx2ZXM=?=
	<jose.goncalves@inov.pt>
MIME-Version: 1.0
To: Luciano Coelho <coelho@ti.com>
CC: Arik Nemtsov <arik@wizery.com>, linux-wireless@vger.kernel.org
Subject: Re: wl127x: Unable to associate with a WPA2-PSK AP
References: <51DB0ACC.7050800@inov.pt>  <CA+XVXfcakDiN1pPqGDQAN=VR8p_C1LUWGt_nX-rGXDLsBkk+Dw@mail.gmail.com>  <51DB4195.8090103@inov.pt>  <CA+XVXffKKVMeD5GXkzDsnvR7=Ocb8QP0Y7eeD-ZZTzsxJL7PqA@mail.gmail.com>  <1373360959.21065.183.camel@cumari.coelho.fi> <51DBD904.6020007@inov.pt>  <1373362817.21065.191.camel@cumari.coelho.fi> <51DBF389.5060209@inov.pt>  <CA+XVXfeB3jpXaaV4vgbHUVRdPeH9tPVRWvRhZsYHmg33HNzmmw@mail.gmail.com>  <51DC0E7C.9080306@inov.pt> <1373446089.8385.7.camel@cumari.coelho.fi>
In-Reply-To: <1373446089.8385.7.camel@cumari.coelho.fi>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10-07-2013 09:48, Luciano Coelho wrote:
> On Tue, 2013-07-09 at 14:22 +0100, José Miguel Gonçalves wrote:
>> On 09-07-2013 13:42, Arik Nemtsov wrote:
>>> On Tue, Jul 9, 2013 at 2:27 PM, José Miguel Gonçalves
>>> <jose.goncalves@inov.pt> wrote:
>>>
>>>> Any more ideas on how to debug this? Is there any specific debug_level mask
>>>> that can apply to the driver to help it?
>>> You can try the mask 0x63c20 (it's pretty verbose, so I would put it
>>> in pastebin).
>>>
>>> Perhaps this is a genuine problem with the antenna of the card?
>> Nope. The AP is 1 meter away form my board (even without antenna in the
>> card it should associate).
> Too strong a signal can also cause problems, because of distortion.
>
>
>>> Can
>>> you verify the RSSI of the AP is ok using iw?
>> The iw output:
>>
>> http://pastebin.com/XmEzqjHs
> This looks okay, but the RSSI value cannot be trusted blindly.  There
> are other factors that can influence the signal quality, such as the
> SNR.
>
>
>> The dmesg output with debug mask set to 0x63c20:
>>
>> http://pastebin.com/zGE0Gfp8
>>
>> Note that with debug activated I did not see the driver's "Beacon loss
>> detected" messages.
> There could be some timing issue here.  Is it always like that? Do you
> *always* see the "Beacon loss" messages without debugging and *never*
> with debugging?
>

Yep, is always like that!

José Gonçalves
