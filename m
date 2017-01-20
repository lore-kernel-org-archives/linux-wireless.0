Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:36789 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751642AbdATK6Z (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 20 Jan 2017 05:58:25 -0500
Received: by mail-oi0-f66.google.com with SMTP id u143so5223282oif.3
        for <linux-wireless@vger.kernel.org>; Fri, 20 Jan 2017 02:58:24 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <52453214-bab2-dc0b-c684-2389fe028442@broadcom.com>
References: <20170118142703.9824-1-zajec5@gmail.com> <da843f98-cd01-17f7-45cc-4530e8b87bfe@broadcom.com>
 <52453214-bab2-dc0b-c684-2389fe028442@broadcom.com>
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Date: Fri, 20 Jan 2017 11:58:24 +0100
Message-ID: <CACna6rwhe+Vupq=7CxQAQfRce2_gH7kNj1QwRyoCpTLms+mn5Q@mail.gmail.com> (sfid-20170120_115828_334543_46A7884B)
Subject: Re: [PATCH RFC 1/2] brcmfmac: merge two brcmf_err macros into one
To: Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Franky Lin <frankyl@broadcom.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "open list:BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER"
        <brcm80211-dev-list.pdl@broadcom.com>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 20 January 2017 at 11:14, Arend Van Spriel
<arend.vanspriel@broadcom.com> wrote:
> On 20-1-2017 11:13, Arend Van Spriel wrote:
>> On 18-1-2017 15:27, Rafa=C5=82 Mi=C5=82ecki wrote:
>>> From: Rafa=C5=82 Mi=C5=82ecki <rafal@milecki.pl>
>>>
>>> This allows simplifying the code by adding a simple IS_ENABLED check fo=
r
>>> CONFIG_BRCMDB symbol.
>
> Actually it should be CONFIG_BRCMDBG above.
>
> Kalle,
>
> Can you fix that in the commit message?

It's only RFC, I'll make sure to fix that in final version

--=20
Rafa=C5=82
