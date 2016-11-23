Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:33050 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965354AbcKWPjP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 23 Nov 2016 10:39:15 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v2,1/9] rt2800: correctly report MCS TX parameters
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1479462241-9299-2-git-send-email-sgruszka@redhat.com>
References: <1479462241-9299-2-git-send-email-sgruszka@redhat.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org,
        Helmut Schaa <helmut.schaa@googlemail.com>,
        Mathias Kresin <dev@kresin.me>
Message-Id: <20161123153914.DFB3D6151E@smtp.codeaurora.org> (sfid-20161123_163931_895788_346552FC)
Date: Wed, 23 Nov 2016 15:39:14 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> We should only set IEEE80211_HT_MCS_TX_RX_DIF when TX and RX MCS sets
> are not equal, i.e. when number of tx streams is different than
> number of RX streams.
> 
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>

9 patches applied to wireless-drivers-next.git, thanks.

cea5b03d8a10 rt2800: correctly report MCS TX parameters
b29a1c1f08f3 rt2800usb: do not wipe out USB_DMA_CFG settings
770e4b730a73 rt2800: OFDM rates are mandatory
b4c449b1b803 rt2800: do not overwrite WPDMA_GLO_CFG_WP_DMA_BURST_SIZE
be82de9d64e2 rt2800: correct AUTO_RSP_CFG
231aeca1e19e rt2800: correct TX_SW_CFG1 for 5592
6c40063d5a61 rt2800: use RTS/CTS protection instead of CTS-to-self
8d79b0078278 rt2800: tune *_PROT_CFG parameters
159a55a64d44 rt2800: disable CCK rates on HT

-- 
https://patchwork.kernel.org/patch/9436109/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
