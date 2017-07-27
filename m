Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f173.google.com ([209.85.128.173]:36766 "EHLO
        mail-wr0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750878AbdG0Jwc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 27 Jul 2017 05:52:32 -0400
Received: by mail-wr0-f173.google.com with SMTP id y43so141413103wrd.3
        for <linux-wireless@vger.kernel.org>; Thu, 27 Jul 2017 02:52:31 -0700 (PDT)
Message-ID: <5979B7DD.2070704@broadcom.com> (sfid-20170727_115238_581741_E4F42812)
Date: Thu, 27 Jul 2017 11:52:29 +0200
From: Arend van Spriel <arend.vanspriel@broadcom.com>
MIME-Version: 1.0
To: Ian Molton <ian@mnementh.co.uk>
CC: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org,
        franky.lin@broadcom.com, hante.meuleman@broadcom.com
Subject: Re: Patch v4: Clean up brcmfmac driver
References: <20170726202557.15632-1-ian@mnementh.co.uk> <878tjaxv1z.fsf@purkki.adurom.net> <4f2b9f3c-2fb1-3f43-ee96-127404e726c6@mnementh.co.uk>
In-Reply-To: <4f2b9f3c-2fb1-3f43-ee96-127404e726c6@mnementh.co.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 7/27/2017 11:47 AM, Ian Molton wrote:
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

Hi Ian,

~10-15 patches should be fine although I am simply ploughing through the 
lot right now.

Regards,
Arend
