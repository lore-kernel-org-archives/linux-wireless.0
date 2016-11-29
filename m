Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f169.google.com ([209.85.216.169]:35883 "EHLO
        mail-qt0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756488AbcK2JXf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 29 Nov 2016 04:23:35 -0500
Received: by mail-qt0-f169.google.com with SMTP id w33so148899366qtc.3
        for <linux-wireless@vger.kernel.org>; Tue, 29 Nov 2016 01:23:35 -0800 (PST)
Subject: Re: [PATCH 03/12] brcmfmac: move pno helper functions in separate
 source file
To: Johannes Berg <johannes@sipsolutions.net>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
References: <1479896731-5091-1-git-send-email-arend.vanspriel@broadcom.com>
 <1479896731-5091-4-git-send-email-arend.vanspriel@broadcom.com>
 <CACna6rwSDT1UeuexMpNhVMxKHWpZGdzDg7C1b5wVOhXzO3o=MA@mail.gmail.com>
 <1480406267.10012.0.camel@sipsolutions.net>
Cc: Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless <linux-wireless@vger.kernel.org>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <f0329a78-abdc-020a-5362-7b3e6b772593@broadcom.com> (sfid-20161129_102352_605172_2DF54E74)
Date: Tue, 29 Nov 2016 10:23:31 +0100
MIME-Version: 1.0
In-Reply-To: <1480406267.10012.0.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 29-11-2016 8:57, Johannes Berg wrote:
> On Tue, 2016-11-29 at 08:08 +0100, Rafał Miłecki wrote:
>> On 23 November 2016 at 11:25, Arend van Spriel
>> <arend.vanspriel@broadcom.com> wrote:
>>>
>>> Introducing new source file for pno related functionality. Moving
>>> existing pno functions.
>>
>> Let me ask one basic question as I'm curious: what that PNO stands
>> for? I couldn't find it explained in the code.
> 
> It's an Android term - Preferred Network Offload(ing?)

Yeah. The module is called pfn in our firmware, which stands for
preferred network. So not sure whether it was a BRCM term morphed into
Android term or vice versa.

Kalle,

If needed I could drop the use of the term and resubmit the series.

Regards,
Arend
