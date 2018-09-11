Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:53344 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726761AbeIKTTN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 11 Sep 2018 15:19:13 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Felix Fietkau <nbd@nbd.name>,
        linux-mediatek@lists.infradead.org
Subject: Re: [PATCH 00/22] mt76 patches 2018-09-04
References: <1536072075-6990-1-git-send-email-sgruszka@redhat.com>
Date: Tue, 11 Sep 2018 17:19:37 +0300
In-Reply-To: <1536072075-6990-1-git-send-email-sgruszka@redhat.com> (Stanislaw
        Gruszka's message of "Tue, 4 Sep 2018 16:40:53 +0200")
Message-ID: <87h8iwru9y.fsf@purkki.adurom.net> (sfid-20180911_162004_102520_B0313056)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Stanislaw Gruszka <sgruszka@redhat.com> writes:

> More mt76x0/mt76x2 integration.
>
> This set is quite big but I would like to move patches upstream
> from my github tree as fast as possible. I have there 42 more
> ready to post patches from me and Lorenzo.
> https://github.com/sgruszka/wireless-drivers-next/commits/mt76x0-draft-v3
>
> Note this set include:
> "mt76x0: fix wrong usage of wcid_mask in remove_interface"
> patch with I posted as fix for 4.19 . I assume this will be
> auto (or manually?) merged when -next will go to 4.20.

The problem is that having two identical patches with different commit
ids will confuse git and can create annoying merge conflicts. A much
safer approach is that the patch is first applied to wireless-drivers
and then I merge wireless-drivers into wireless-drivers-next. I'm
planning to do that in a day or two, I was away for a long weekend so
lagging behind again.

But the patch "mt76x0: fix wrong usage of wcid_mask in remove_interface"
should be dropped from this series. But Felix is planning to send all
pending mt76 to me via a pull request anyway so you don't need to worry
about this.

-- 
Kalle Valo
