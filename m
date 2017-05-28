Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f176.google.com ([209.85.220.176]:33348 "EHLO
        mail-qk0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750802AbdE1TiB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 28 May 2017 15:38:01 -0400
Received: by mail-qk0-f176.google.com with SMTP id y201so36277476qka.0
        for <linux-wireless@vger.kernel.org>; Sun, 28 May 2017 12:38:01 -0700 (PDT)
Subject: Re: Probelm on (brcmfmac: use pre-allocated scatter-gather table for
 txglomming)
To: Michael Trimarchi <michael@amarulasolutions.com>,
        Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless@vger.kernel.org
References: <CAOf5uwkT=Z2V3JadZeFKKU6m1sTozcC+ObEPzwR_qPuzv6X7Xw@mail.gmail.com>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <531d6bb5-e864-111a-b976-8664b6f68e80@broadcom.com> (sfid-20170528_213805_573684_9C22C51D)
Date: Sun, 28 May 2017 21:37:56 +0200
MIME-Version: 1.0
In-Reply-To: <CAOf5uwkT=Z2V3JadZeFKKU6m1sTozcC+ObEPzwR_qPuzv6X7Xw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11-03-16 16:23, Michael Trimarchi wrote:
> Hi
> 
> I have a kernel panic on the brcmf_sdiod_sgtable_alloc just because
> the function is called before brcmf_sdio_probe.
> 
> I think that
>  nents = max_t(uint, BRCMF_DEFAULT_RXGLOM_SIZE,
>                       sdiodev->bus_if->drvr->settings->sdiod_txglomsz);
> 
> drvr is null. Can you explain how it can work or do you have already a
> fix for this?

It sounds familiar so what kernel version are you seeing this.

Regards,
Arend
