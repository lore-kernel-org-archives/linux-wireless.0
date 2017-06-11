Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:60210 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751743AbdFKISn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 11 Jun 2017 04:18:43 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Kevin Lo <kevlo@kevlo.org>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH] rtlwifi: fix REG_USTIME_TSF register definition
References: <20170519150240.GA47825@ns.kevlo.org>
        <CA+R5OdtxiN4XBZg3k-Suamj5r4+=jDY-10HdUCHuqb=Nt-baqg@mail.gmail.com>
        <20170610142316.GA9284@ns.kevlo.org>
Date: Sun, 11 Jun 2017 11:18:38 +0300
In-Reply-To: <20170610142316.GA9284@ns.kevlo.org> (Kevin Lo's message of "Sat,
        10 Jun 2017 22:23:16 +0800")
Message-ID: <87y3szos2p.fsf@purkki.adurom.net> (sfid-20170611_101848_413419_D3020241)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kevin Lo <kevlo@kevlo.org> writes:

> Sorry for the top post.  This patch has an Acked-by Yan-Hsuan Chuang.
>
> On Wed, Jun 07, 2017 at 09:43:21AM +0800, =E8=8E=8A=E5=BD=A5=E5=AE=A3 wro=
te:
>> Yes, the register 0x55c is for REG_USTIME_TSF.
>> And 0x551 is for BCN_CTRL1.
>>=20
>>=20
>> Acked-by: Yan-Hsuan, Chuang <yhchuang@realtek.com>
>>=20
>> 2017-05-19 23:02 GMT+08:00 Kevin Lo <kevlo@kevlo.org>:
>>=20
>> > The REG_USTIME_TSF (US Time Tuning for TSF) definition of Realtek chips
>> > should be 0x55C.
>> >
>> > Signed-off-by: Kevin Lo <kevlo@kevlo.org>

I don't see Yan-Hsuan's ack on the mailing list (maybe it was dropped
because of HTML?) and hence neither in patchwork:

https://patchwork.kernel.org/patch/9737421/

Yan-Hsuan or Larry, can you please resend the ack so that patchwork sees
it?

--=20
Kalle Valo
