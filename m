Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:38744 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750997AbdG0KcH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 27 Jul 2017 06:32:07 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Ian Molton <ian@mnementh.co.uk>
Cc: linux-wireless@vger.kernel.org, arend.vanspriel@broadcom.com,
        franky.lin@broadcom.com, hante.meuleman@broadcom.com
Subject: Re: Patch v4: Clean up brcmfmac driver
References: <20170726202557.15632-1-ian@mnementh.co.uk>
        <878tjaxv1z.fsf@purkki.adurom.net>
        <4f2b9f3c-2fb1-3f43-ee96-127404e726c6@mnementh.co.uk>
Date: Thu, 27 Jul 2017 13:31:59 +0300
In-Reply-To: <4f2b9f3c-2fb1-3f43-ee96-127404e726c6@mnementh.co.uk> (Ian
        Molton's message of "Thu, 27 Jul 2017 10:47:36 +0100")
Message-ID: <8760eeyxuo.fsf@kamboji.qca.qualcomm.com> (sfid-20170727_123210_966768_3E876F6B)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ian Molton <ian@mnementh.co.uk> writes:

> On 27/07/17 07:17, Kalle Valo wrote:
>>> Here's a v4 of the cleanup patchset - checkpatch clean(er - I have purposely
>>> left some warnings unaddressed).
>>>
>>> I also dropped an accidental adjustment of a debug macro from v3.
>> Like I said already last time, please split the patchset into reasonable
>> sizes (and submit one patchset at a time). I will automatically drop
>> patchbombs like this.
>
> How many patches would you like at once?

Check my previous email:

https://lkml.kernel.org/r/87k23124gp.fsf@purkki.adurom.net

-- 
Kalle Valo
