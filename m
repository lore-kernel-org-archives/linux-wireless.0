Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f41.google.com ([74.125.83.41]:33410 "EHLO
        mail-pg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751851AbdATLDG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 20 Jan 2017 06:03:06 -0500
Received: by mail-pg0-f41.google.com with SMTP id 204so23058575pge.0
        for <linux-wireless@vger.kernel.org>; Fri, 20 Jan 2017 03:03:06 -0800 (PST)
Subject: Re: [PATCH RFC 1/2] brcmfmac: merge two brcmf_err macros into one
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
References: <20170118142703.9824-1-zajec5@gmail.com>
 <da843f98-cd01-17f7-45cc-4530e8b87bfe@broadcom.com>
 <52453214-bab2-dc0b-c684-2389fe028442@broadcom.com>
 <CACna6rwhe+Vupq=7CxQAQfRce2_gH7kNj1QwRyoCpTLms+mn5Q@mail.gmail.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Franky Lin <frankyl@broadcom.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "open list:BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER"
        <brcm80211-dev-list.pdl@broadcom.com>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <b533bcce-c88a-aaf9-a8a7-1fd3fc37f44e@broadcom.com> (sfid-20170120_120310_630142_F3508867)
Date: Fri, 20 Jan 2017 12:03:00 +0100
MIME-Version: 1.0
In-Reply-To: <CACna6rwhe+Vupq=7CxQAQfRce2_gH7kNj1QwRyoCpTLms+mn5Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 20-1-2017 11:58, Rafał Miłecki wrote:
> On 20 January 2017 at 11:14, Arend Van Spriel
> <arend.vanspriel@broadcom.com> wrote:
>> On 20-1-2017 11:13, Arend Van Spriel wrote:
>>> On 18-1-2017 15:27, Rafał Miłecki wrote:
>>>> From: Rafał Miłecki <rafal@milecki.pl>
>>>>
>>>> This allows simplifying the code by adding a simple IS_ENABLED check for
>>>> CONFIG_BRCMDB symbol.
>>
>> Actually it should be CONFIG_BRCMDBG above.
>>
>> Kalle,
>>
>> Can you fix that in the commit message?
> 
> It's only RFC, I'll make sure to fix that in final version

You're right. Missed that.

Regards,
Arend
