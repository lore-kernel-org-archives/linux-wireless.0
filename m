Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vc0-f175.google.com ([209.85.220.175]:57393 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161978Ab3DEQcs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Apr 2013 12:32:48 -0400
Received: by mail-vc0-f175.google.com with SMTP id hf12so3393880vcb.34
        for <linux-wireless@vger.kernel.org>; Fri, 05 Apr 2013 09:32:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <515EF88F.1030606@openwrt.org>
References: <CAJ8GFOjheLNiawD7K-VnGa5ishbnr6rm0YHUvJs8XgZK1EaJtQ@mail.gmail.com>
	<515EF88F.1030606@openwrt.org>
Date: Fri, 5 Apr 2013 11:32:47 -0500
Message-ID: <CAJ8GFOhz+Feh-=sO6T3HziNejS5uj4aPhf_Jr4Nop2=bszOe5A@mail.gmail.com> (sfid-20130405_183254_399528_E253AF36)
Subject: Re: AR9342: Two odd packets in every beacon interval in 5Ghz
From: Harshal Chhaya <harshal@gmail.com>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Apr 5, 2013 at 11:15 AM, Felix Fietkau <nbd@openwrt.org> wrote:
> On 2013-04-05 5:24 PM, Harshal Chhaya wrote:
>> Hello,
>>
>> We have an AR9342-based AP that is sending out two odd packets each
>> beacon interval. These packets are 1804 bytes in size, are transmitted
>> at 6.5Mbps and have the dest MAC address the same as the source MAC
>> address.
...
> Maybe it's (failing) PA predistortion calibration, which needs to send
> training frames to complete.
> I'd suggest trying a newer compat-wireless version, this type of
> calibration has been disabled there because of various issues (including
> hardware damage on some chips).

Felix,

Thanks for that suggestion. I will try a newer compat-wireless and let
you know what happens.

Regards,
- Harshal
