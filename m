Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:40442 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751823AbeFXRCC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 24 Jun 2018 13:02:02 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: mt7601u: remove warning when avg_rssi is zero
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180609101043.GA28502@redhat.com>
References: <20180609101043.GA28502@redhat.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Jakub Kicinski <kubakici@wp.pl>, linux-wireless@vger.kernel.org,
        Adam Borowski <kilobyte@angband.pl>
Message-Id: <20180624170201.D38DE607EB@smtp.codeaurora.org> (sfid-20180624_190205_545116_B1695959)
Date: Sun, 24 Jun 2018 17:02:01 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Stanislaw Gruszka <sgruszka@redhat.com> wrote:

> It turned out that we can run calibration without already received
> frames with RSSI data. In such case just don't update AGC register
> and don't print the warning.
> 
> Fixes: b305a6ab0247 ("mt7601u: use EWMA to calculate avg_rssi")
> Reported-by: Adam Borowski <kilobyte@angband.pl>
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> Acked-by: Jakub Kicinski <kubakici@wp.pl>

Patch applied to wireless-drivers.git, thanks.

92963318a255 mt7601u: remove warning when avg_rssi is zero

-- 
https://patchwork.kernel.org/patch/10455479/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
