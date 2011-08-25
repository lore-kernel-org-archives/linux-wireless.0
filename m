Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:48134 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752040Ab1HYRC7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Aug 2011 13:02:59 -0400
Received: by wyg24 with SMTP id 24so1840914wyg.19
        for <linux-wireless@vger.kernel.org>; Thu, 25 Aug 2011 10:02:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87ipplonyc.fsf@purkki.adurom.net>
References: <1314213161-8871-1-git-send-email-linville@tuxdriver.com>
	<CAG6hwVNvLREnnZQ0t8UaKZ7Q1nn-4kx=z_1nPzVG89a5NMWFpg@mail.gmail.com>
	<20110824193224.GL9770@tuxdriver.com>
	<CAG6hwVMWMGXZMfnQSLQD6BCSG0kuP_0C6rKs_XYwmK4v7esRsQ@mail.gmail.com>
	<87ipplonyc.fsf@purkki.adurom.net>
Date: Thu, 25 Aug 2011 10:02:58 -0700
Message-ID: <CAG6hwVPPTWq+9Ryrun-_VHjf6JKOOttvPg0h6Kk6tv-N+wqEkg@mail.gmail.com> (sfid-20110825_190307_669786_DDE2031C)
Subject: Re: [PATCH] mac80211: refactor skb copy to failq in mesh_path_move_to_queue
From: Thomas Pedersen <thomas@cozybit.com>
To: Kalle Valo <kvalo@adurom.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 25, 2011 at 2:11 AM, Kalle Valo <kvalo@adurom.com> wrote:
> Thomas Pedersen <thomas@cozybit.com> writes:
>
>>>> However, this does look nicer. Please be sure to apply the version
>>>> submitted on 11 August.
>>>
>>> You just told me yesterday to apply the 9 August version???
>>>
>>
>> OK that is confusing. I meant 9 August version of patch 1/8 only, the
>> rest should be 11 August.
>
> WTF, this is the second time I'm reading something like this in 24 hours?
>
> John has loads of things to do already. If something changes in the
> series series, ask John to drop that version and RESUBMIT IT! Don't
> force John to waste time by trying to find the correct versions of
> your patch from the past.
>
> I want to John to focus on more important things than doing the work
> of the people who don't bother to resubmit their patches. Resubmitting
> a patch series takes maximum of 10 minutes, even when being extra
> careful.
>

Sorry. In the future I'll make sure John doesn't have to pull from two
different versions of the same patchset.

> --
> Kalle Valo
>
