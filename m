Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f53.google.com ([209.85.214.53]:34067 "EHLO
        mail-it0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750802AbdE1UZZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 28 May 2017 16:25:25 -0400
Received: by mail-it0-f53.google.com with SMTP id a10so5937810itg.1
        for <linux-wireless@vger.kernel.org>; Sun, 28 May 2017 13:25:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <531d6bb5-e864-111a-b976-8664b6f68e80@broadcom.com>
References: <CAOf5uwkT=Z2V3JadZeFKKU6m1sTozcC+ObEPzwR_qPuzv6X7Xw@mail.gmail.com>
 <531d6bb5-e864-111a-b976-8664b6f68e80@broadcom.com>
From: Michael Nazzareno Trimarchi <michael@amarulasolutions.com>
Date: Sun, 28 May 2017 22:25:23 +0200
Message-ID: <CAOf5uw=fnr=A0cb9nCzjk1HKj4VcQtnxHXCuSdKDKmhcfJbZqA@mail.gmail.com> (sfid-20170528_222530_443523_DB846C46)
Subject: Re: Probelm on (brcmfmac: use pre-allocated scatter-gather table for txglomming)
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: Arend van Spriel <arend@broadcom.com>,
        linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Arend

On Sun, May 28, 2017 at 9:37 PM, Arend van Spriel
<arend.vanspriel@broadcom.com> wrote:
> On 11-03-16 16:23, Michael Trimarchi wrote:
>> Hi
>>
>> I have a kernel panic on the brcmf_sdiod_sgtable_alloc just because
>> the function is called before brcmf_sdio_probe.
>>
>> I think that
>>  nents = max_t(uint, BRCMF_DEFAULT_RXGLOM_SIZE,
>>                       sdiodev->bus_if->drvr->settings->sdiod_txglomsz);
>>
>> drvr is null. Can you explain how it can work or do you have already a
>> fix for this?
>
> It sounds familiar so what kernel version are you seeing this.
>

This should be already sort out 1 year ago ;)

Regards
Michael

> Regards,
> Arend



-- 
| Michael Nazzareno Trimarchi                     Amarula Solutions BV |
| COO  -  Founder                                      Cruquiuskade 47 |
| +31(0)851119172                                 Amsterdam 1018 AM NL |
|                  [`as] http://www.amarulasolutions.com               |
