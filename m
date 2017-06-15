Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:36668 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752426AbdFOOkG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Jun 2017 10:40:06 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: =?utf-8?Q?Micha=C5=82_Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>
Cc: linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>
Subject: Re: [PATCH] wireless: brcmfmac: initialize oob irq data before request_irq()
References: <b6d30eb2d883c011d50200cfdb8c44462e1939a4.1497369605.git.mirq-linux@rere.qmqm.pl>
        <87poe74138.fsf@kamboji.qca.qualcomm.com>
        <20170614112925.d3j3l5bam5gwhj7h@qmqm.qmqm.pl>
Date: Thu, 15 Jun 2017 17:40:01 +0300
In-Reply-To: <20170614112925.d3j3l5bam5gwhj7h@qmqm.qmqm.pl> (=?utf-8?Q?=22?=
 =?utf-8?Q?Micha=C5=82=09Miros=C5=82aw=22's?= message of "Wed, 14 Jun 2017
 13:29:25 +0200")
Message-ID: <87vanxe2m6.fsf@codeaurora.org> (sfid-20170615_164010_234851_E86D2C8E)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Micha=C5=82 Miros=C5=82aw <mirq-linux@rere.qmqm.pl> writes:

> On Wed, Jun 14, 2017 at 07:58:35AM +0300, Kalle Valo wrote:
>> Micha=C5=82 Miros=C5=82aw <mirq-linux@rere.qmqm.pl> writes:
>> > This fixes spin-forever in irq handler when IRQ is already asserted
>> > at request_irq() time.
>> >
>> > Signed-off-by: Micha=C5=82 Miros=C5=82aw <mirq-linux@rere.qmqm.pl>
>>=20
>> Your name in patchwork is broken:
>>=20
>> https://patchwork.kernel.org/patch/9784251/
>>=20
>> You could try to fix it by registering as then you have (onetime) option
>> to provide your full name.
>
> Doesn't like UTF-8?

patchwork.kernel.org was updated something like a year ago to get proper
UTF-8 support and I have been succesfully applied patches from Rafal who
also uses UTF-8 with his name:

git log --author rafal@milecki.pl drivers/net/wireless/

You could always compare his posts with yours and see what you do
differently. Here's one example:

https://patchwork.kernel.org/patch/9640743/

> Registration didn't help though.

Darn. This time I can manually apply the patch but for the future we
should try to solve this.

--=20
Kalle Valo
