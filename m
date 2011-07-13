Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:44036 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964915Ab1GMLPh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jul 2011 07:15:37 -0400
Received: by iyb12 with SMTP id 12so5497240iyb.19
        for <linux-wireless@vger.kernel.org>; Wed, 13 Jul 2011 04:15:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4E1D7866.3020302@adurom.com>
References: <1310546836.3873.6.camel@jlt3.sipsolutions.net>
 <4E1D5CB7.7070607@adurom.com> <CAGRGNgWC21fLzsm4rb_nOb8AraaZiXUjXwUGhPrAzoLLMhwSEw@mail.gmail.com>
 <4E1D7866.3020302@adurom.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Wed, 13 Jul 2011 21:15:17 +1000
Message-ID: <CAGRGNgWvU67zQ+mTVmbkEkjeJKxkZ1TobDAz=aLmUYzTyvFm_Q@mail.gmail.com> (sfid-20110713_131541_307839_1572A4D3)
Subject: Re: [TODO] at76c50x: remove wext includes
To: Kalle Valo <kvalo@adurom.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 13, 2011 at 20:50, Kalle Valo <kvalo@adurom.com> wrote:
> On 07/13/2011 01:35 PM, Julian Calaby wrote:
>> On Wed, Jul 13, 2011 at 18:52, Kalle Valo <kvalo@adurom.com> wrote:
>>> The driver has been broken due to the mac80211 changes for a long time
>>> and it's obvious that I can't maintain it anymore as I haven't touched
>>> it for a long time. I would like to just remove it altogether. Any
>>> objections?
>>
>> What hardware is it for?
>
> For USB devices from stone age which had Atmel at76c50x chipset. For
> example Belkin F5D5060 was one of them:
>
> http://www.gearxs.com/gearxs/product_info.php?products_id=3535

Thanks!

I found the device table in the driver which helpfully lists
manufacturers and model numbers, of all of those, the only ones I can
obtain on eBay are the Linksys ones and the Netgear ones - which means
I've probably got a really small chance of laying hands on one of
these chipsets as they both like to recycle model numbers.

I'll see what I can get locally and maybe pick this up if I find anything.

Until then, you might as well drop it from the kernel if nobody else
shows up - if I find anything I'll restore it from the history. (that
said, I *really* need another project at the moment =) )

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
