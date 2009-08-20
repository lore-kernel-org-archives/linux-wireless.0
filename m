Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f207.google.com ([209.85.219.207]:40295 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753836AbZHTHWi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Aug 2009 03:22:38 -0400
Received: by ewy3 with SMTP id 3so2664620ewy.18
        for <linux-wireless@vger.kernel.org>; Thu, 20 Aug 2009 00:22:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <43e72e890908200012x23b7773dvf215676726a514e5@mail.gmail.com>
References: <eb3ff54b0908200002s4dc0dbf7kc28dda3fa7afaeb9@mail.gmail.com>
	 <43e72e890908200012x23b7773dvf215676726a514e5@mail.gmail.com>
Date: Thu, 20 Aug 2009 10:22:38 +0300
Message-ID: <eb3ff54b0908200022mf4d2950v366c82698dfe440b@mail.gmail.com>
Subject: Re: Linux Kernel Wireless stack presentation
From: Rami Rosen <ramirose@gmail.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luis,
First, thanks for your quick response.

> * Ditch iwconfig and refer to iw

I do mention also iw; for example, in slide 70, slide 111.
My impression is that both set of tools, wireless-tools and iw, will
coexist for the next
near future and maybe beyond.


> * ath5k/ath9k do not have any firmware burned onto any "ROM", the
> devices just do not require software, everything is done by the driver

Thanks for the info!

Regards,
Rami Rosen


On Thu, Aug 20, 2009 at 10:12 AM, Luis R. Rodriguez<mcgrof@gmail.com> wrote:
> On Thu, Aug 20, 2009 at 12:02 AM, Rami Rosen<ramirose@gmail.com> wrote:
>> Folks,
>>
>>  I am giving on Thursday next week a lecture about the Linux Kernel
>> Wireless stack in a
>> Linux User Group in Herzelia (Israel).
>>
>>  The slides are available online now, so I thought some of you might
>> be interested
>> to take a look; the presentation is very detailed (over 110 pages).
>>
>> see:
>> http://tuxology.net/wp-content/uploads/2009/08/wirelessLecHerzelinux.pdf
>
> A few comments:
>
> * Ditch iwconfig and refer to iw
> * ath5k/ath9k do not have any firmware burned onto any "ROM", the
> devices just do not require software, everything is done by the driver
>
>   Luis
>
