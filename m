Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vb0-f44.google.com ([209.85.212.44]:47931 "EHLO
	mail-vb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936365Ab3DQSDG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Apr 2013 14:03:06 -0400
Received: by mail-vb0-f44.google.com with SMTP id e12so1489432vbg.31
        for <linux-wireless@vger.kernel.org>; Wed, 17 Apr 2013 11:03:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJ8GFOhz+Feh-=sO6T3HziNejS5uj4aPhf_Jr4Nop2=bszOe5A@mail.gmail.com>
References: <CAJ8GFOjheLNiawD7K-VnGa5ishbnr6rm0YHUvJs8XgZK1EaJtQ@mail.gmail.com>
	<515EF88F.1030606@openwrt.org>
	<CAJ8GFOhz+Feh-=sO6T3HziNejS5uj4aPhf_Jr4Nop2=bszOe5A@mail.gmail.com>
Date: Wed, 17 Apr 2013 13:03:05 -0500
Message-ID: <CAJ8GFOiZmgc=tb1BEw5jsKT4hE9ExmDrtgDh-dmS4K7=AbkBdg@mail.gmail.com> (sfid-20130417_200313_622525_7959C54D)
Subject: Re: AR9342: Two odd packets in every beacon interval in 5Ghz
From: Harshal Chhaya <harshal@gmail.com>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Apr 5, 2013 at 11:32 AM, Harshal Chhaya <harshal@gmail.com> wrote:
> On Fri, Apr 5, 2013 at 11:15 AM, Felix Fietkau <nbd@openwrt.org> wrote:
>> On 2013-04-05 5:24 PM, Harshal Chhaya wrote:
>>> Hello,
>>>
>>> We have an AR9342-based AP that is sending out two odd packets each
>>> beacon interval. These packets are 1804 bytes in size, are transmitted
>>> at 6.5Mbps and have the dest MAC address the same as the source MAC
>>> address.
> ...
>> Maybe it's (failing) PA predistortion calibration, which needs to send
>> training frames to complete.
>> I'd suggest trying a newer compat-wireless version, this type of
>> calibration has been disabled there because of various issues (including
>> hardware damage on some chips).
>
> Felix,
>
> Thanks for that suggestion. I will try a newer compat-wireless and let
> you know what happens.


Felix,

Sorry for the delayed reply (a couple of other problems had to be
fixed first) but a newer compat-wireless indeed fixed the problem. No
more slow, long packets.

Thank you for explaining what those packets were and for the solution.

Thanks,
- Harshal
