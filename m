Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:51675 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752439AbbLJKkC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Dec 2015 05:40:02 -0500
Message-ID: <56695680.9020207@broadcom.com> (sfid-20151210_114006_458956_562D6866)
Date: Thu, 10 Dec 2015 11:40:00 +0100
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Arend van Spriel <aspriel@gmail.com>,
	Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>
Subject: Re: [PATCH 01/13] brcmfmac: Simplify scan timing configuration.
References: <1449656572-16158-1-git-send-email-arend@broadcom.com> <1449656572-16158-2-git-send-email-arend@broadcom.com> <87zixj93gg.fsf@kamboji.qca.qualcomm.com> <566952EA.4070107@gmail.com>
In-Reply-To: <566952EA.4070107@gmail.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/10/2015 11:24 AM, Arend van Spriel wrote:
> On 09-12-15 14:06, Kalle Valo wrote:
>> Arend van Spriel <arend@broadcom.com> writes:
>>
>>> From: Hante Meuleman <meuleman@broadcom.com>
>>>
>>
>> Please, no empty commit logs. For a patch like this it takes like 30
>> seconds to write a short log describing why and how you are simplifying
>> the code. Next year I'm thinking of start rejecting patches without a
>> commit log.
>
> Time to consider new year resolutions, heh ;-) Anyway, it is noted and
> will see if I can gatekeep this better.
>
>> This is a minor nitpick but it's not that common to the commit title
>> with a period.
>
> Have to agree to the nitpicking part :-p Can keep it in mind though.
>
>>> Reviewed-by: Arend Van Spriel <arend@broadcom.com>
>>> Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
>>> Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
>>> Change-Id: Ie179527eb29f2ed8b7869dac24591e2513775393
>>> Reviewed-on: http://hnd-swgit.sj.broadcom.com:8080/5445
>>> Reviewed-by: brcm80211 ci <brcm80211-ci@broadcom.com>
>>> Signed-off-by: Arend van Spriel <arend@broadcom.com>
>>
>> Forgot to clean the tags? :)
>
> *sigh* Obviously. Should not try to multitask when preparing patch series.

Do you want me to resend after cleaning it up?

Gr. AvS

> Gr. AvS
>

