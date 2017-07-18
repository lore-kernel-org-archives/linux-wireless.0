Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx08-00252a01.pphosted.com ([91.207.212.211]:60564 "EHLO
        mx08-00252a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751322AbdGRI7I (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 18 Jul 2017 04:59:08 -0400
Received: from pps.filterd (m0102629.ppops.net [127.0.0.1])
        by mx08-00252a01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id v6I8uddp023274
        for <linux-wireless@vger.kernel.org>; Tue, 18 Jul 2017 09:59:07 +0100
Received: from mail-wr0-f200.google.com (mail-wr0-f200.google.com [209.85.128.200])
        by mx08-00252a01.pphosted.com with ESMTP id 2bq7hehggh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK)
        for <linux-wireless@vger.kernel.org>; Tue, 18 Jul 2017 09:59:07 +0100
Received: by mail-wr0-f200.google.com with SMTP id z53so1603831wrz.10
        for <linux-wireless@vger.kernel.org>; Tue, 18 Jul 2017 01:59:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CA+8PC_eKn_LddvcpYG=V6vD7qZfVNEmmzR3gWXxWO80SNKR-3Q@mail.gmail.com>
References: <384537059.123625.1498678388857@email.1und1.de>
 <1133935948.74840.1500297053336@email.1und1.de> <CA+8PC_eKn_LddvcpYG=V6vD7qZfVNEmmzR3gWXxWO80SNKR-3Q@mail.gmail.com>
From: James Hughes <james.hughes@raspberrypi.org>
Date: Tue, 18 Jul 2017 09:59:06 +0100
Message-ID: <CAE_XsMJ-Ssd_uY2qr1GcL5emO46akee+CjMAeP9pBmY0cfZe3Q@mail.gmail.com> (sfid-20170718_105914_107473_E2243125)
Subject: Re: brcmfmac: BCM43431 won't get probed on Raspberry Pi Zero W
To: Franky Lin <franky.lin@broadcom.com>
Cc: Stefan Wahren <stefan.wahren@i2se.com>,
        Arend Van Spriel <arend.vanspriel@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "open list:BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER"
        <brcm80211-dev-list.pdl@broadcom.com>,
        "open list:BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER"
        <linux-wireless@vger.kernel.org>,
        linux-rpi-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>>
>
> Can you please try to comment out the following lines in
> brcmf_feat_attach? That's the only suspicious line that interact with
> firmware in the patch.
>
> + brcmf_feat_iovar_data_set(ifp, BRCMF_FEAT_GSCAN, "pfn_gscan_cfg",
> +                                            &gscan_cfg, sizeof(gscan_cfg));
>
> I don't have a pi zero w but will try to see if I can reproduce it on a pi 3.

Franky/Arend, if a ZeroW would help now and in future Pi Wifi issues,
I can get one to you. Email me off list.

James

>>> [2] - https://www.kraxel.org/cgit/linux/log/?h=bcm2837
