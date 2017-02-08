Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 17.mo1.mail-out.ovh.net ([87.98.179.142]:33125 "EHLO
        17.mo1.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754323AbdBHOHB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 8 Feb 2017 09:07:01 -0500
Received: from player691.ha.ovh.net (b9.ovh.net [213.186.33.59])
        by mo1.mail-out.ovh.net (Postfix) with ESMTP id E9FCD55B2D
        for <linux-wireless@vger.kernel.org>; Wed,  8 Feb 2017 11:00:56 +0100 (CET)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Date: Wed, 08 Feb 2017 11:00:47 +0100
From: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <rafal@milecki.pl>
To: Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Franky Lin <frankyl@broadcom.com>,
        linux-wireless@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com
Subject: Re: [PATCH V3 4/9] brcmfmac: add struct brcmf_pub parameter to the
 __brcmf_err
In-Reply-To: <2812805e-9108-284f-2165-34624d603364@broadcom.com>
References: <20170202213321.11591-1-zajec5@gmail.com>
 <20170202213321.11591-4-zajec5@gmail.com>
 <2812805e-9108-284f-2165-34624d603364@broadcom.com>
Message-ID: <209e8eef55927a76470d44482c6d0090@milecki.pl> (sfid-20170208_150706_029260_5FA0CBF7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2017-02-08 10:54, Arend Van Spriel wrote:
> On 2-2-2017 22:33, Rafał Miłecki wrote:
>> From: Rafał Miłecki <rafal@milecki.pl>
>> 
>> This will allow getting struct device reference from the passed
>> brcmf_pub for the needs of dev_err. More detailed messages are really
>> important for home routers which frequently have 2 (or even 3) 
>> wireless
>> cards supported by brcmfmac.
>> 
>> Note that all calls are yet to be updated as for now brcmf_err macro
>> always passes NULL. This will be handled in following patch to make 
>> this
>> change easier to review.
> 
> I prefer brcmf_err() to have struct device reference directly instead 
> of
> using brcmf_pub. That would remove the need for patches 5 till 7 as bus
> specific code already has struct device. So I have acked the first 
> three
> patches, but would like to revise 8 and 9.
> 
> Kalle,
> 
> I acked the first three patches. Can those three still go in for 4.11?

Sounds OK to me. Kalle, I ack Arend's request if it isn't too late.
