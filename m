Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 220-135-115-6.HINET-IP.hinet.net ([220.135.115.6]:59979 "EHLO
        ns.kevlo.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751649AbdFKNYx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 11 Jun 2017 09:24:53 -0400
Date: Sun, 11 Jun 2017 21:24:24 +0800
From: Kevin Lo <kevlo@kevlo.org>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH] rtlwifi: fix REG_USTIME_TSF register definition
Message-ID: <20170611132424.GA15690@ns.kevlo.org> (sfid-20170611_152502_458439_051B104D)
References: <20170519150240.GA47825@ns.kevlo.org>
 <CA+R5OdtxiN4XBZg3k-Suamj5r4+=jDY-10HdUCHuqb=Nt-baqg@mail.gmail.com>
 <20170610142316.GA9284@ns.kevlo.org>
 <87y3szos2p.fsf@purkki.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <87y3szos2p.fsf@purkki.adurom.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jun 11, 2017 at 11:18:38AM +0300, Kalle Valo wrote:
> 
> Kevin Lo <kevlo@kevlo.org> writes:
> 
> > Sorry for the top post.  This patch has an Acked-by Yan-Hsuan Chuang.
> >
> > On Wed, Jun 07, 2017 at 09:43:21AM +0800, 莊彥宣 wrote:
> >> Yes, the register 0x55c is for REG_USTIME_TSF.
> >> And 0x551 is for BCN_CTRL1.
> >> 
> >> 
> >> Acked-by: Yan-Hsuan, Chuang <yhchuang@realtek.com>
> >> 
> >> 2017-05-19 23:02 GMT+08:00 Kevin Lo <kevlo@kevlo.org>:
> >> 
> >> > The REG_USTIME_TSF (US Time Tuning for TSF) definition of Realtek chips
> >> > should be 0x55C.
> >> >
> >> > Signed-off-by: Kevin Lo <kevlo@kevlo.org>
> 
> I don't see Yan-Hsuan's ack on the mailing list (maybe it was dropped
> because of HTML?) and hence neither in patchwork:
> 
> https://patchwork.kernel.org/patch/9737421/

Yan-Hsuan replied privately to me.  I think he forgot to cc linux-wireless@.

> Yan-Hsuan or Larry, can you please resend the ack so that patchwork sees
> it?
> 
> -- 
> Kalle Valo
