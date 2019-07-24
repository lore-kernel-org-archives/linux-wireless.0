Return-Path: <SRS0=rB3s=VV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E22AC76186
	for <linux-wireless@archiver.kernel.org>; Wed, 24 Jul 2019 03:22:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2219B2182B
	for <linux-wireless@archiver.kernel.org>; Wed, 24 Jul 2019 03:22:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726574AbfGXDWt (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 23 Jul 2019 23:22:49 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:6817 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725837AbfGXDWt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 23 Jul 2019 23:22:49 -0400
X-UUID: bc3b6758d3ff4755bc36f76e05f40f0e-20190724
X-UUID: bc3b6758d3ff4755bc36f76e05f40f0e-20190724
Received: from mtkcas08.mediatek.inc [(172.21.101.126)] by mailgw01.mediatek.com
        (envelope-from <ryder.lee@mediatek.com>)
        (mhqrelay.mediatek.com ESMTP with TLS)
        with ESMTP id 347499950; Wed, 24 Jul 2019 11:22:43 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 mtkmbs07n1.mediatek.inc (172.21.101.16) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Wed, 24 Jul 2019 11:22:42 +0800
Received: from [172.21.77.33] (172.21.77.33) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Wed, 24 Jul 2019 11:22:42 +0800
Message-ID: <1563938562.9134.1.camel@mtkswgap22>
Subject: Re: [PATCH 0/5] fix many checkpatch.pl warnings
From:   Ryder Lee <ryder.lee@mediatek.com>
To:     Kalle Valo <kvalo@codeaurora.org>
CC:     Sean Wang <sean.wang@mediatek.com>, YF Luo <yf.luo@mediatek.com>,
        <linux-wireless@vger.kernel.org>,
        Yiwei Chung <yiwei.chung@mediatek.com>,
        <linux-mediatek@lists.infradead.org>, Roy Luo <royluo@google.com>,
        "Lorenzo Bianconi" <lorenzo.bianconi@redhat.com>,
        Felix Fietkau <nbd@nbd.name>
Date:   Wed, 24 Jul 2019 11:22:42 +0800
In-Reply-To: <8736ixrvhb.fsf@purkki.adurom.net>
References: <cover.1563772403.git.ryder.lee@mediatek.com>
         <8736ixrvhb.fsf@purkki.adurom.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-MTK:  N
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, 2019-07-23 at 11:44 +0300, Kalle Valo wrote:
> Ryder Lee <ryder.lee@mediatek.com> writes:
> 
> > This gathers many subsets to fix checkpatch.pl warnings.
> 
> Thanks, this is much better now.
> 
> > I still keep some warnings there due to readability.
> > (The most of them are - networking block comments or 80 characters limit)
> 
> I do the same in ath10k. BTW, here's my simple script which I use to
> filter unwanted checkpatch warnings etc:
> 
> https://github.com/qca/qca-swiss-army-knife/blob/master/tools/scripts/ath10k/ath10k-check
> 

It's really useful!

Thanks
Ryder


