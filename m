Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:41370 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727772AbeISRle (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 19 Sep 2018 13:41:34 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Sid Hayn <sidhayn@gmail.com>
Cc: sgruszka@redhat.com,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Felix Fietkau <nbd@nbd.name>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        linux-mediatek@lists.infradead.org
Subject: Re: [PATCH] mt76x0: run vco calibration for each channel configuration
References: <20180907211312.17918-1-lorenzo.bianconi@redhat.com>
        <20180918114356.GB15285@redhat.com>
        <20180918120234.GD15285@redhat.com>
        <871s9r2d3g.fsf@kamboji.qca.qualcomm.com>
        <CAM0KTbAPHPK04SntA9UL0rGaaNjTy=E2hRoO7xiRkbMcq9b7Sw@mail.gmail.com>
Date: Wed, 19 Sep 2018 15:03:52 +0300
In-Reply-To: <CAM0KTbAPHPK04SntA9UL0rGaaNjTy=E2hRoO7xiRkbMcq9b7Sw@mail.gmail.com>
        (Sid Hayn's message of "Tue, 18 Sep 2018 10:26:09 -0400")
Message-ID: <87worh1yon.fsf@kamboji.qca.qualcomm.com> (sfid-20180919_140359_928757_CB0003EE)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sid Hayn <sidhayn@gmail.com> writes:

> mt76x0 isn't in 4.18 at all, it's being added in 4.19 isn't it?  I'm
> not sure you can call it a regression, but adding a new driver with a
> known bug that breaks an entire use case (monitor mode) seems silly
> when a small and tested fix is available.  Pretty please.

Unfortunately it's not that simple as you think. And do take into
account that the maintainers need to deal with a lot of patches and
email so keeping things simple is important.

And please do not top post:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches#do_not_top_post_and_edit_your_quotes

-- 
Kalle Valo
