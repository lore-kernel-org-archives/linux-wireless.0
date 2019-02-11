Return-Path: <SRS0=RvtO=QS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E459AC282CC
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Feb 2019 08:48:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B6C1D20823
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Feb 2019 08:48:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727237AbfBKIsP (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 11 Feb 2019 03:48:15 -0500
Received: from mailgw01.mediatek.com ([210.61.82.183]:24352 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726663AbfBKIsP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 11 Feb 2019 03:48:15 -0500
X-UUID: c8f7f495246e4c91af209617ba73f07b-20190211
X-UUID: c8f7f495246e4c91af209617ba73f07b-20190211
Received: from mtkcas09.mediatek.inc [(172.21.101.178)] by mailgw01.mediatek.com
        (envelope-from <ryder.lee@mediatek.com>)
        (mhqrelay.mediatek.com ESMTP with TLS)
        with ESMTP id 235515514; Mon, 11 Feb 2019 16:48:09 +0800
Received: from mtkcas08.mediatek.inc (172.21.101.126) by
 mtkexhb01.mediatek.inc (172.21.101.102) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Mon, 11 Feb 2019 16:48:08 +0800
Received: from [172.21.77.33] (172.21.77.33) by mtkcas08.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Mon, 11 Feb 2019 16:48:08 +0800
Message-ID: <1549874888.29377.6.camel@mtkswgap22>
Subject: Re: [PATCH] mt76: change the retun type of mt76_dma_attach()
From:   Ryder Lee <ryder.lee@mediatek.com>
To:     Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
CC:     Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>,
        Felix Fietkau <nbd@nbd.name>,
        Kalle Valo <kvalo@codeaurora.org>, <netdev@vger.kernel.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-wireless@vger.kernel.org>, Roy Luo <roychl666@gmail.com>,
        <linux-kernel@vger.kernel.org>
Date:   Mon, 11 Feb 2019 16:48:08 +0800
In-Reply-To: <f65c85c2-ef47-d141-d78e-db2a138a1daf@cogentembedded.com>
References: <228fdddb9ca96e8ce861e324eb9039722cf18f49.1549850911.git.ryder.lee@mediatek.com>
         <f65c85c2-ef47-d141-d78e-db2a138a1daf@cogentembedded.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-MTK:  N
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, 2019-02-11 at 11:38 +0300, Sergei Shtylyov wrote:
> Hello!
> 
> On 11.02.2019 5:13, Ryder Lee wrote:
> 
> > There is no need to retun 0 in mt76_dma_attach(), so switch it to void.
>                            ^ r missing :-)
> > 
> > Signed-off-by: Ryder Lee <ryder.lee@mediatek.com>
> [...]
> 
> MBR, Sergei
> 

I will resend a new one.

Thanks
Ryder


