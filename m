Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:34186 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751795AbdFUQyl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 21 Jun 2017 12:54:41 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: =?utf-8?Q?Micha=C5=82_Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>
Cc: linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>
Subject: Re: [PATCH] wireless: brcmfmac: initialize oob irq data before request_irq()
References: <b6d30eb2d883c011d50200cfdb8c44462e1939a4.1497369605.git.mirq-linux@rere.qmqm.pl>
Date: Wed, 21 Jun 2017 18:36:09 +0300
In-Reply-To: <b6d30eb2d883c011d50200cfdb8c44462e1939a4.1497369605.git.mirq-linux@rere.qmqm.pl>
        (=?utf-8?Q?=22Micha=C5=82_Miros=C5=82aw=22's?= message of "Tue, 13 Jun 2017
 18:02:03 +0200")
Message-ID: <874lv9nyja.fsf@purkki.adurom.net> (sfid-20170621_185444_456389_5D0893AF)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Micha=C5=82 Miros=C5=82aw <mirq-linux@rere.qmqm.pl> writes:

> This fixes spin-forever in irq handler when IRQ is already asserted
> at request_irq() time.
>
> Signed-off-by: Micha=C5=82 Miros=C5=82aw <mirq-linux@rere.qmqm.pl>

To avoid the UTF-8 problem I skipped patchwork and applied this manually
to wireless-drivers-next:

3f426c968955 brcmfmac: initialize oob irq data before request_irq()

But hopefully you can get your name in patchwork fixed so that I don't
need to manually apply your patches.

--=20
Kalle Valo
