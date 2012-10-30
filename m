Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f174.google.com ([209.85.215.174]:62085 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752402Ab2J3XqT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Oct 2012 19:46:19 -0400
Received: by mail-ea0-f174.google.com with SMTP id c13so334458eaa.19
        for <linux-wireless@vger.kernel.org>; Tue, 30 Oct 2012 16:46:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5090560D.1090708@candelatech.com>
References: <508EB783.9080000@candelatech.com> <CAGRGNgWGfL+_u4fHEfqZAcFHb1H4Z4jFkiE4qKLU6i9XEWzZ6w@mail.gmail.com>
 <5090560D.1090708@candelatech.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Wed, 31 Oct 2012 10:45:58 +1100
Message-ID: <CAGRGNgUQ40YW-dwy34nPD65XPWt1VWetyXDdd=L_NxKJ9-_Fiw@mail.gmail.com> (sfid-20121031_004623_338533_D21B32A5)
Subject: Re: Any thoughts on how to best shield u.fl connectors on NICs?
To: Ben Greear <greearb@candelatech.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Ben,

On Wed, Oct 31, 2012 at 9:34 AM, Ben Greear <greearb@candelatech.com> wrote:
> On 10/30/2012 03:22 PM, Julian Calaby wrote:
>>
>> Hi Ben,
>>
>> On Tue, Oct 30, 2012 at 4:06 AM, Ben Greear <greearb@candelatech.com>
>> wrote:
>>>
>>> It appears hard to get well-shielded u.fl (IPEX) to SMA pigtails, and all
>>> of
>>> the
>>> modern ath9k NICs I've seen use u.fl connectors on the NIC.
>>>
>>> I have found a vendor that will do double-shielded 1.32mm cable, and I
>>> have
>>> some of those
>>> on order, but the way u.fl connectors are made it seems there is always a
>>> bit of un-shielded
>>> cable where the connector is crimped onto the cable.
>>>
>>> I am curious if anyone has any suggestions or experience with connecting
>>> u.fl NICs to
>>> SMA cables in a highly shielded manner...
>>
>>
>> I have an awful feeling that it's simply not going to happen - I would
>> guess from what you've described that the u.fl connector is designed
>> to be cheap, small and easy and not really designed for "real" work
>> like what you're doing with it. I'm guessing that the signal leakage
>> through the connector is probably not a problem for the manufacturers
>> as they're always shielded inside a computer case - i.e. it complies
>> with the FCC rules.
>
>
> I think it must be able to leak quite a bit before the FCC cares...
> Standard
> single-shielded pigtails are quite noisy, nevermind the connectors...
>
> But anyway...I was thinking something like this (but with different
> gender u.fl side) and some sort of physical attachment option to keep
> it on the NIC might be interesting:
>
> http://www.pimfg.com/Product-Detail/000-SMA-UFL

I was expecting you to end up ripping the u.fl connectors off the NICs
and replacing them with something better shielded.

> For all I know, the NIC itself may leak worse than the u.fl pigtail
> connector,
> however...

That's a good point, all the NICs I've looked at closely (e.g. the
rt2500usb cards on my desk at the moment) have an antenna or u.fl
connector with some passive components around it and usually the
antenna trace runs exposed on the board for a couple of millimetres
before it disappears under the shielding around the RF chip. I'll
check my collection at home tonight, but I'm pretty sure that all the
PCI cards have a couple of cm of exposed antenna trace between the SMA
connector and the RF shield.

Thanks,

--
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
