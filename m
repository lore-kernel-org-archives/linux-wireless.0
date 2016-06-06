Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f42.google.com ([209.85.218.42]:32873 "EHLO
	mail-oi0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751174AbcFFSTx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jun 2016 14:19:53 -0400
Received: by mail-oi0-f42.google.com with SMTP id k23so239490387oih.0
        for <linux-wireless@vger.kernel.org>; Mon, 06 Jun 2016 11:19:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <57559106.5060606@candelatech.com>
References: <57559106.5060606@candelatech.com>
From: Dave Taht <dave.taht@gmail.com>
Date: Mon, 6 Jun 2016 11:19:51 -0700
Message-ID: <CAA93jw6S789CV3WJczYiRfD++yQ3F+1RPypTt2dnKxcZVtNyoA@mail.gmail.com> (sfid-20160606_201957_240241_CFA2194F)
Subject: Re: How to use fractional center frequencies (4942.5, for instance)?
To: Ben Greear <greearb@candelatech.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jun 6, 2016 at 8:04 AM, Ben Greear <greearb@candelatech.com> wrote:
>
> It appears that some cisco equipment, at least, uses fractional center
> frequencies for 5Mhz channels.

I was not aware that anything supported 5Mhz other than ath9k and
ath5k. Thx. Can you identify what cisco gear supports this?

I have long advocated that meshy networks in increasingly dense areas
use narrower channels.

https://www.usenix.org/system/files/conference/nsdi12/nsdi12-final142.pdf

was one of the better papers that went into it back in the day.


> Has anyone attempted to support this with ath9k?
>
> Thanks,
> Ben
>
> --
> Ben Greear <greearb@candelatech.com>
> Candela Technologies Inc  http://www.candelatech.com
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Dave Täht
Let's go make home routers and wifi faster! With better software!
http://blog.cerowrt.org
