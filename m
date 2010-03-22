Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:63365 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752165Ab0CVIFR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Mar 2010 04:05:17 -0400
Received: by wyb38 with SMTP id 38so2335921wyb.19
        for <linux-wireless@vger.kernel.org>; Mon, 22 Mar 2010 01:05:15 -0700 (PDT)
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <19366.65089.541041.18060@gargle.gargle.HOWL>
References: <2d0a357f1003191828g2d133a06qd8902785ae015cd0@mail.gmail.com>
	 <19366.65089.541041.18060@gargle.gargle.HOWL>
Date: Mon, 22 Mar 2010 09:05:15 +0100
Message-ID: <2d0a357f1003220105uaafb04aq86459c822ad313b7@mail.gmail.com>
Subject: Re: [ath9k_htc] Wrong kernel config parameters in wiki?
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Sujith <Sujith.Manoharan@atheros.com>
Cc: wireless <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 22, 2010 at 6:21 AM, Sujith <Sujith.Manoharan@atheros.com> wrote:
> Sedat Dilek wrote:
>> Hi,
>>
>> a person asked on IRC about ath9k_htc support.
>>
>> First question:
>> Has the patch from [1] already entered one of the wireless-* GIT repositories?
>
> Nope, the driver has not been merged yet.
> A revised series (12 patches) was submitted.
> They should be available on patchwork.
>

New patchset from [1] applies cleanly against 2.6.34-rc2.

>> I could apply the ath9k_htc patch against 2.6.34-rc1-git9.
>>
>> The kernel config parameters in wiki [2] seems to be wrong to me:
>>
>> CONFIG_ATH=m
>> CONFIG_ATH9K_HW=m
>> CONFIG_ATH9K_HTC=m
>
> Yep, they are wrong and are fixed now.
>

The correct kernel config parameters are (only for documentation purposes):

CONFIG_ATH_COMMON=m
CONFIG_ATH9K_HW=m
CONFIG_ATH9K_COMMON=m
CONFIG_ATH9K_HTC=m

Thanks for the informations.

--
Sedat

[1] https://patchwork.kernel.org/patch/{86517..86528}/ (12 patches)
