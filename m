Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ot0-f196.google.com ([74.125.82.196]:33301 "EHLO
        mail-ot0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751427AbdARJHL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 18 Jan 2017 04:07:11 -0500
Received: by mail-ot0-f196.google.com with SMTP id f9so620008otd.0
        for <linux-wireless@vger.kernel.org>; Wed, 18 Jan 2017 01:06:47 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <d1aca4b7-3493-5935-befb-af1b2dadc7d1@broadcom.com>
References: <20170117163419.1184-1-zajec5@gmail.com> <20170117163419.1184-2-zajec5@gmail.com>
 <d1aca4b7-3493-5935-befb-af1b2dadc7d1@broadcom.com>
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Date: Wed, 18 Jan 2017 10:06:46 +0100
Message-ID: <CACna6rz9_vxEvDs7OoWALxat0XSEW3E4V0idrjZWAbiSmQvRAw@mail.gmail.com> (sfid-20170118_100728_850028_9CE55B7D)
Subject: Re: [PATCH 2/2] brcmfmac: move function declarations to proper headers
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

On 18 January 2017 at 09:58, Arend Van Spriel
<arend.vanspriel@broadcom.com> wrote:
> On 17-1-2017 17:34, Rafa=C5=82 Mi=C5=82ecki wrote:
>> From: Rafa=C5=82 Mi=C5=82ecki <rafal@milecki.pl>
>>
>> Function brcmf_c_set_joinpref_default is in common.c, so move it to the
>> related header. All other (touched) ones are in core.c so take them out
>> of the bus.h.
>> I just needed to include bus.h to have enum brcmf_bus_state defined.
>
> I prefer to keep the bus api in separate include file so please leave
> those. That leaves the move of brcmf_c_set_joinpref_default(). Please
> send a v2 and consider it acked by me.

Oh, I just realized there isn't bus.c! Would that make sense to move
these functions from core.c to new bus.c then?

--=20
Rafa=C5=82
