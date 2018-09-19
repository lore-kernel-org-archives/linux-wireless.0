Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58672 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727605AbeISRBv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 19 Sep 2018 13:01:51 -0400
Date: Wed, 19 Sep 2018 13:24:18 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Sid Hayn <sidhayn@gmail.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Felix Fietkau <nbd@nbd.name>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        linux-mediatek@lists.infradead.org
Subject: Re: [PATCH] mt76x0: run vco calibration for each channel
 configuration
Message-ID: <20180919112416.GA24594@redhat.com> (sfid-20180919_132426_515562_63DAF971)
References: <20180907211312.17918-1-lorenzo.bianconi@redhat.com>
 <20180918114356.GB15285@redhat.com>
 <20180918120234.GD15285@redhat.com>
 <871s9r2d3g.fsf@kamboji.qca.qualcomm.com>
 <CAM0KTbAPHPK04SntA9UL0rGaaNjTy=E2hRoO7xiRkbMcq9b7Sw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAM0KTbAPHPK04SntA9UL0rGaaNjTy=E2hRoO7xiRkbMcq9b7Sw@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 18, 2018 at 10:26:09AM -0400, Sid Hayn wrote:
> mt76x0 isn't in 4.18 at all, it's being added in 4.19 isn't it?  I'm
> not sure you can call it a regression, but adding a new driver with a
> known bug that breaks an entire use case (monitor mode) seems silly
> when a small and tested fix is available.  Pretty please.

Patch conflict with pending mt76 -next patches. Apply it and rebase
all other patches on top of it, is a lot of work. I agree with
Kalle that it will be better to apply this patch on top of -next
and CC stable. Problem should be fixed in 4.19.1 or 4.19.2 .

Regards
Stanislaw
