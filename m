Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:54075 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756121Ab2J3Wez (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Oct 2012 18:34:55 -0400
Message-ID: <5090560D.1090708@candelatech.com> (sfid-20121030_233459_447081_699482BF)
Date: Tue, 30 Oct 2012 15:34:53 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Julian Calaby <julian.calaby@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Any thoughts on how to best shield u.fl connectors on NICs?
References: <508EB783.9080000@candelatech.com> <CAGRGNgWGfL+_u4fHEfqZAcFHb1H4Z4jFkiE4qKLU6i9XEWzZ6w@mail.gmail.com>
In-Reply-To: <CAGRGNgWGfL+_u4fHEfqZAcFHb1H4Z4jFkiE4qKLU6i9XEWzZ6w@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/30/2012 03:22 PM, Julian Calaby wrote:
> Hi Ben,
>
> On Tue, Oct 30, 2012 at 4:06 AM, Ben Greear <greearb@candelatech.com> wrote:
>> It appears hard to get well-shielded u.fl (IPEX) to SMA pigtails, and all of
>> the
>> modern ath9k NICs I've seen use u.fl connectors on the NIC.
>>
>> I have found a vendor that will do double-shielded 1.32mm cable, and I have
>> some of those
>> on order, but the way u.fl connectors are made it seems there is always a
>> bit of un-shielded
>> cable where the connector is crimped onto the cable.
>>
>> I am curious if anyone has any suggestions or experience with connecting
>> u.fl NICs to
>> SMA cables in a highly shielded manner...
>
> I have an awful feeling that it's simply not going to happen - I would
> guess from what you've described that the u.fl connector is designed
> to be cheap, small and easy and not really designed for "real" work
> like what you're doing with it. I'm guessing that the signal leakage
> through the connector is probably not a problem for the manufacturers
> as they're always shielded inside a computer case - i.e. it complies
> with the FCC rules.

I think it must be able to leak quite a bit before the FCC cares...  Standard
single-shielded pigtails are quite noisy, nevermind the connectors...

But anyway...I was thinking something like this (but with different
gender u.fl side) and some sort of physical attachment option to keep
it on the NIC might be interesting:

http://www.pimfg.com/Product-Detail/000-SMA-UFL

For all I know, the NIC itself may leak worse than the u.fl pigtail connector,
however...

Thanks,
Ben

>
> Thanks,
>


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

