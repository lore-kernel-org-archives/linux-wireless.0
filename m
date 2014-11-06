Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f52.google.com ([209.85.215.52]:61691 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828AbaKFNzi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Nov 2014 08:55:38 -0500
Received: by mail-la0-f52.google.com with SMTP id pv20so2576930lab.39
        for <linux-wireless@vger.kernel.org>; Thu, 06 Nov 2014 05:55:36 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <545B7CB2.4080507@raritan.com>
References: <1415267752-4704-1-git-send-email-ronald.wahl@raritan.com>
	<1415268135.1884.1.camel@sipsolutions.net>
	<545B6AD3.8020301@broadcom.com>
	<1415277562.17015.4.camel@sipsolutions.net>
	<545B7290.6060409@raritan.com>
	<1415279690.17015.7.camel@sipsolutions.net>
	<545B7CB2.4080507@raritan.com>
Date: Thu, 6 Nov 2014 14:55:36 +0100
Message-ID: <CAKv+Gu-GE7R204_J9g4pumvuW1zA1ijVk20-5heCb9yoUuR3fg@mail.gmail.com> (sfid-20141106_145541_795004_0253EE27)
Subject: Re: [PATCH] mac80211: Fix regression that triggers a kernel BUG with CCMP
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: Ronald Wahl <ronald.wahl@raritan.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Arend van Spriel <arend@broadcom.com>,
	"<linux-wireless@vger.kernel.org>" <linux-wireless@vger.kernel.org>,
	Christian Lamparter <chunkeey@googlemail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 6 November 2014 14:50, Ronald Wahl <ronald.wahl@raritan.com> wrote:
> On 06.11.2014 14:14, Johannes Berg wrote:
>>
>> On Thu, 2014-11-06 at 14:07 +0100, Ronald Wahl wrote:
>>
>>> But there are LTS kernels not maintained by Greg like 3.12 and 3.16. How
>>> about these? If sending patches to stable@kernel org is optional then
>>> it's better to kill that list or silently drop emails send to this list
>>> so no errors are returned for this address.
>>
>>
>> They can pick it up the same way though, no? Actually I think they
>> usually pick it up from Greg's tree anyway :)
>
>
> "Can" and "do" are different things. And you "think" you know what others
> people do but do you really "know" it? Anyway your original comment sounded
> a bit like "avoid sending it to the stable kernel mailinglist otherwise
> unwanted things might happen". In the end this raises the question why that
> stable kernel mailing still list exists or why there is no general rule not
> to send mails to it.
>
> So in the end that currently means that it is not wrong to send mail to
> stable@vger.kernel.org but it is your opinion that it is just not really
> necessary, right?
>

You used to get an autoreply like this when cc'ing stable@ directly

"""
<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read Documentation/stable_kernel_rules.txt
for how to do this properly.

</formletter>
"""

You are only supposed to send patches to the mailing list if they are
already upstream, i.e., if you know the upstream commit id of the
patch.

-- 
Ard.
