Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:52478 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755322AbcK2Oyw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 29 Nov 2016 09:54:52 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: =?utf-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: Arend Van Spriel <arend.vanspriel@broadcom.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 03/12] brcmfmac: move pno helper functions in separate source file
References: <1479896731-5091-1-git-send-email-arend.vanspriel@broadcom.com>
        <1479896731-5091-4-git-send-email-arend.vanspriel@broadcom.com>
        <CACna6rwSDT1UeuexMpNhVMxKHWpZGdzDg7C1b5wVOhXzO3o=MA@mail.gmail.com>
        <1480406267.10012.0.camel@sipsolutions.net>
        <f0329a78-abdc-020a-5362-7b3e6b772593@broadcom.com>
        <CACna6rx20tvodySME7+oeSbp_MmLDBta0C92tihEVK3GJkJ77w@mail.gmail.com>
Date: Tue, 29 Nov 2016 16:54:46 +0200
In-Reply-To: <CACna6rx20tvodySME7+oeSbp_MmLDBta0C92tihEVK3GJkJ77w@mail.gmail.com>
        (=?utf-8?Q?=22Rafa=C5=82_Mi=C5=82ecki=22's?= message of "Tue, 29 Nov 2016
 13:29:19 +0100")
Message-ID: <87vav6tjyh.fsf@kamboji.qca.qualcomm.com> (sfid-20161129_155456_760993_CC164D11)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rafa=C5=82 Mi=C5=82ecki <zajec5@gmail.com> writes:

> On 29 November 2016 at 10:23, Arend Van Spriel
> <arend.vanspriel@broadcom.com> wrote:
>> On 29-11-2016 8:57, Johannes Berg wrote:
>>> On Tue, 2016-11-29 at 08:08 +0100, Rafa=C5=82 Mi=C5=82ecki wrote:
>>>> On 23 November 2016 at 11:25, Arend van Spriel
>>>> <arend.vanspriel@broadcom.com> wrote:
>>>>>
>>>>> Introducing new source file for pno related functionality. Moving
>>>>> existing pno functions.
>>>>
>>>> Let me ask one basic question as I'm curious: what that PNO stands
>>>> for? I couldn't find it explained in the code.
>>>
>>> It's an Android term - Preferred Network Offload(ing?)
>>
>> Yeah. The module is called pfn in our firmware, which stands for
>> preferred network. So not sure whether it was a BRCM term morphed into
>> Android term or vice versa.
>>
>> Kalle,
>>
>> If needed I could drop the use of the term and resubmit the series.
>
> I don't have anything against it, I was just trying to understand that
> part of driver (which makes more sense now, thanks).

I don't have any problems as these are already implemented, you are only
moving code around. But if you were adding a new feature to the driver
when an explanation for the acronym is very much preferred.

--=20
Kalle Valo
