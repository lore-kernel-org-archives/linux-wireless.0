Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:57304 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751065AbdFNE6m (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 14 Jun 2017 00:58:42 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: =?utf-8?Q?Micha=C5=82_Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>
Cc: linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>
Subject: Re: [PATCH] wireless: brcmfmac: initialize oob irq data before request_irq()
References: <b6d30eb2d883c011d50200cfdb8c44462e1939a4.1497369605.git.mirq-linux@rere.qmqm.pl>
Date: Wed, 14 Jun 2017 07:58:35 +0300
In-Reply-To: <b6d30eb2d883c011d50200cfdb8c44462e1939a4.1497369605.git.mirq-linux@rere.qmqm.pl>
        (=?utf-8?Q?=22Micha=C5=82_Miros=C5=82aw=22's?= message of "Tue, 13 Jun 2017
 18:02:03 +0200")
Message-ID: <87poe74138.fsf@kamboji.qca.qualcomm.com> (sfid-20170614_065901_353118_8A084531)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Micha=C5=82 Miros=C5=82aw <mirq-linux@rere.qmqm.pl> writes:

> This fixes spin-forever in irq handler when IRQ is already asserted
> at request_irq() time.
>
> Signed-off-by: Micha=C5=82 Miros=C5=82aw <mirq-linux@rere.qmqm.pl>

Your name in patchwork is broken:

https://patchwork.kernel.org/patch/9784251/

You could try to fix it by registering as then you have (onetime) option
to provide your full name.

--=20
Kalle Valo
