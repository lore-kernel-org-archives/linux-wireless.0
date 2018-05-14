Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f50.google.com ([74.125.82.50]:35822 "EHLO
        mail-wm0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753935AbeENHYk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 14 May 2018 03:24:40 -0400
Received: by mail-wm0-f50.google.com with SMTP id o78-v6so13105115wmg.0
        for <linux-wireless@vger.kernel.org>; Mon, 14 May 2018 00:24:39 -0700 (PDT)
Subject: Re: [PATCH] brcmfmac: add debugfs entry for reading firmware
 capabilities
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
References: <20180511101526.10734-1-zajec5@gmail.com>
 <5AF88B10.2040504@broadcom.com> <5729429a82d2eb034b88adb7e1738ce6@milecki.pl>
Cc: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com, brcm80211-dev-list@cypress.com
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5AF939B7.9050202@broadcom.com> (sfid-20180514_092451_963082_813F325F)
Date: Mon, 14 May 2018 09:24:39 +0200
MIME-Version: 1.0
In-Reply-To: <5729429a82d2eb034b88adb7e1738ce6@milecki.pl>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 5/14/2018 7:11 AM, Rafał Miłecki wrote:
>>> +/**
>>> + * brcmf_cap_read() - expose firmware capabilities to debugfs.
>>
>> Please stick to naming convention brcmf_<module>_foo(), ie.
>> brcmf_feat_cap_read().
>
> Will do, thanks! I missed that naming convention because of
> brcmf_debugfs_fws_stats_read() / brcmf_debugfs_sdio_count_read() which
> slightly confused me. I see your point now!

Yeah. Sorry for the confusion. There is always room to improve.

Gr. AvS
