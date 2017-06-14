Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [91.227.64.183] ([91.227.64.183]:49472 "EHLO rere.qmqm.pl"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1750728AbdFNL3c (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 14 Jun 2017 07:29:32 -0400
Date: Wed, 14 Jun 2017 13:29:25 +0200
From: =?iso-8859-2?Q?Micha=B3_Miros=B3aw?= <mirq-linux@rere.qmqm.pl>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>
Subject: Re: [PATCH] wireless: brcmfmac: initialize oob irq data before
 request_irq()
Message-ID: <20170614112925.d3j3l5bam5gwhj7h@qmqm.qmqm.pl> (sfid-20170614_132935_681986_10467FE8)
References: <b6d30eb2d883c011d50200cfdb8c44462e1939a4.1497369605.git.mirq-linux@rere.qmqm.pl>
 <87poe74138.fsf@kamboji.qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
In-Reply-To: <87poe74138.fsf@kamboji.qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 14, 2017 at 07:58:35AM +0300, Kalle Valo wrote:
> Micha³ Miros³aw <mirq-linux@rere.qmqm.pl> writes:
> > This fixes spin-forever in irq handler when IRQ is already asserted
> > at request_irq() time.
> >
> > Signed-off-by: Micha³ Miros³aw <mirq-linux@rere.qmqm.pl>
> 
> Your name in patchwork is broken:
> 
> https://patchwork.kernel.org/patch/9784251/
> 
> You could try to fix it by registering as then you have (onetime) option
> to provide your full name.

Doesn't like UTF-8? Registration didn't help though.

Best Regards,
Micha³ Miros³aw
