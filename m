Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f172.google.com ([209.85.214.172]:62431 "EHLO
	mail-iw0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752964Ab0LGXGH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Dec 2010 18:06:07 -0500
Received: by iwn40 with SMTP id 40so537124iwn.3
        for <linux-wireless@vger.kernel.org>; Tue, 07 Dec 2010 15:06:06 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AANLkTikDW6d+rTagHzXD_nFA1K7L1sVxEcFGXtrKhHXs@mail.gmail.com>
References: <1291669987-23434-1-git-send-email-greearb@candelatech.com>
 <20101206215958.GJ21442@tux> <AANLkTikDW6d+rTagHzXD_nFA1K7L1sVxEcFGXtrKhHXs@mail.gmail.com>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Tue, 7 Dec 2010 15:05:46 -0800
Message-ID: <AANLkTi=pXQ1D7Pxc3c==pxHH662dKogscfGjHrACxAvS@mail.gmail.com>
Subject: Re: [ath9k-devel] [PATCH] ath9k: Make DMA warning in ath_stoprecv WARN_ON_ONCE.
To: "greearb@gmail.com" <greearb@gmail.com>
Cc: "ath9k-devel@venema.h4ckr.net" <ath9k-devel@venema.h4ckr.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 6, 2010 at 2:02 PM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:
> On Mon, Dec 6, 2010 at 1:59 PM, Luis R. Rodriguez
> <lrodriguez@atheros.com> wrote:
>> On Mon, Dec 06, 2010 at 01:13:07PM -0800, greearb@gmail.com wrote:
>>> From: Ben Greear <greearb@candelatech.com>
>>>
>>> This decreases spammage in the log.  A single line message
>>> will still be printed, so users can be aware that problem
>>> exists.
>>>
>>> Signed-off-by: Ben Greear <greearb@candelatech.com>
>>
>> Acked-by: Luis R. Rodriguez <lrodriguez@atheros.com>
>
> You forgot to address linville, and no need to send to ath9k-devel if
> you already know the patch is good.

Ben, your patch did not get merged in today's pick of patches by John
but I like it and want to resuse the same definition in my new patches
so I will resubmit in my new series. Thanks.

  Luis
