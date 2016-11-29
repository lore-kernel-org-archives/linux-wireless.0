Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:33501 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755105AbcK2M3V (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 29 Nov 2016 07:29:21 -0500
Received: by mail-oi0-f67.google.com with SMTP id f201so18083462oib.0
        for <linux-wireless@vger.kernel.org>; Tue, 29 Nov 2016 04:29:20 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <f0329a78-abdc-020a-5362-7b3e6b772593@broadcom.com>
References: <1479896731-5091-1-git-send-email-arend.vanspriel@broadcom.com>
 <1479896731-5091-4-git-send-email-arend.vanspriel@broadcom.com>
 <CACna6rwSDT1UeuexMpNhVMxKHWpZGdzDg7C1b5wVOhXzO3o=MA@mail.gmail.com>
 <1480406267.10012.0.camel@sipsolutions.net> <f0329a78-abdc-020a-5362-7b3e6b772593@broadcom.com>
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Date: Tue, 29 Nov 2016 13:29:19 +0100
Message-ID: <CACna6rx20tvodySME7+oeSbp_MmLDBta0C92tihEVK3GJkJ77w@mail.gmail.com> (sfid-20161129_132925_048936_732781F8)
Subject: Re: [PATCH 03/12] brcmfmac: move pno helper functions in separate
 source file
To: Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 29 November 2016 at 10:23, Arend Van Spriel
<arend.vanspriel@broadcom.com> wrote:
> On 29-11-2016 8:57, Johannes Berg wrote:
>> On Tue, 2016-11-29 at 08:08 +0100, Rafa=C5=82 Mi=C5=82ecki wrote:
>>> On 23 November 2016 at 11:25, Arend van Spriel
>>> <arend.vanspriel@broadcom.com> wrote:
>>>>
>>>> Introducing new source file for pno related functionality. Moving
>>>> existing pno functions.
>>>
>>> Let me ask one basic question as I'm curious: what that PNO stands
>>> for? I couldn't find it explained in the code.
>>
>> It's an Android term - Preferred Network Offload(ing?)
>
> Yeah. The module is called pfn in our firmware, which stands for
> preferred network. So not sure whether it was a BRCM term morphed into
> Android term or vice versa.
>
> Kalle,
>
> If needed I could drop the use of the term and resubmit the series.

I don't have anything against it, I was just trying to understand that
part of driver (which makes more sense now, thanks).

--=20
Rafa=C5=82
