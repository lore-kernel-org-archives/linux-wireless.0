Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f44.google.com ([74.125.82.44]:33319 "EHLO
	mail-wm0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751459AbbLJKi4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Dec 2015 05:38:56 -0500
Received: by mail-wm0-f44.google.com with SMTP id c201so26099061wme.0
        for <linux-wireless@vger.kernel.org>; Thu, 10 Dec 2015 02:38:56 -0800 (PST)
Subject: Re: [PATCH 01/13] brcmfmac: Simplify scan timing configuration.
To: Kalle Valo <kvalo@codeaurora.org>,
	Arend van Spriel <arend@broadcom.com>
References: <1449656572-16158-1-git-send-email-arend@broadcom.com>
 <1449656572-16158-2-git-send-email-arend@broadcom.com>
 <87zixj93gg.fsf@kamboji.qca.qualcomm.com> <566952EA.4070107@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>
From: Arend van Spriel <aspriel@gmail.com>
Message-ID: <5669563D.30605@gmail.com> (sfid-20151210_113900_061230_2F9487B6)
Date: Thu, 10 Dec 2015 11:38:53 +0100
MIME-Version: 1.0
In-Reply-To: <566952EA.4070107@gmail.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10-12-15 11:24, Arend van Spriel wrote:
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

Had to check ;-) In 4.4 merge window there 297 commits ending with
period. With 13220 commits in total that can not be called common indeed.

Gr. AvS
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
> 
> Gr. AvS
> 
