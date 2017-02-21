Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:51722 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750998AbdBUIs0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 21 Feb 2017 03:48:26 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Andrew Zaborowski <andrew.zaborowski@intel.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH v6 1/3] cfg80211: Accept multiple RSSI thresholds for CQM
References: <20170210090231.14696-1-andrew.zaborowski@intel.com>
        <1487147264.4026.13.camel@sipsolutions.net>
        <87vasb96ep.fsf@purkki.adurom.net>
        <CAOq732LwAs6bG5dPMuBWA7MnSMLSRyySEq-2y2niDU0ZsFRNfA@mail.gmail.com>
Date: Tue, 21 Feb 2017 10:48:13 +0200
In-Reply-To: <CAOq732LwAs6bG5dPMuBWA7MnSMLSRyySEq-2y2niDU0ZsFRNfA@mail.gmail.com>
        (Andrew Zaborowski's message of "Tue, 21 Feb 2017 02:44:10 +0100")
Message-ID: <87d1ecdj5e.fsf@kamboji.qca.qualcomm.com> (sfid-20170221_094829_718074_58F29CC0)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Andrew Zaborowski <andrew.zaborowski@intel.com> writes:

> Hi,
>
> On 15 February 2017 at 09:58, Kalle Valo <kvalo@codeaurora.org> wrote:
>> Johannes Berg <johannes@sipsolutions.net> writes:
>>> On Fri, 2017-02-10 at 10:02 +0100, Andrew Zaborowski wrote:
>>>> Change the SET CQM command's RSSI threshold attribute to accept any
>>>> number of thresholds as a sorted array.  The API should be backwards
>>>> compatible so that if one s32 threshold value is passed, the old
>>>> mechanism is enabled.  The netlink event generated is the same in
>>>> both cases.
>>>
>>> I've applied this now, thanks for your patience :)
>>>
>>> I got a bit confused - and then fixed it up - patchwork has giving your
>>> name as "Andrzej Zaborowski" which apparently you didn't really want
>>> (any more). I've fixed it for these patches to be as the patches you
>>> sent, but no guarantees I've done this before or will remember to do
>>> that in the future - if you can somehow change your name in patchwork
>>> (patchwork.kernel.org) that would be good.
>
> Thanks, changed it for consistency now.
>
>>
>> IIRC if you haven't registered to patchwork.kernel.org it's possible to
>> change the name easily. But after registration the user needs to contact
>> helpdesk to change the name.
>
> Indeed I was able to set name on registration today but can see no way
> to modify it.  The project's mailing list has a thread about a patch
> that's about to be backported to the patchwork.kernel.org version
> though,
> https://github.com/getpatchwork/patchwork/commit/d365402fb98dfb2c4aea4b58346096f85bdfa0c3

Great, that's exactly the right way to fix this. Thanks for letting us
now.

-- 
Kalle Valo
