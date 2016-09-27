Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:17969 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934222AbcI0MRF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Sep 2016 08:17:05 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ath10k: Fix rfc1042 header retrieval in QCA4019 with eth decap
 mode
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1469623085-13942-1-git-send-email-vthiagar@qti.qualcomm.com>
References: <1469623085-13942-1-git-send-email-vthiagar@qti.qualcomm.com>
To: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
CC: <ath10k@lists.infradead.org>,
        Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>,
        <linux-wireless@vger.kernel.org>
Message-ID: <b725ab111d4f49d094d887a6555e9d81@euamsexm01a.eu.qualcomm.com> (sfid-20160927_141715_652580_779847DA)
Date: Tue, 27 Sep 2016 14:16:57 +0200
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com> wrote:
> Chipset from QCA99X0 onwards (QCA99X0, QCA9984, QCA4019 & future)
> rx_hdr_status is not padded to align in 4-byte boundary. Define a
> new hw_params field to handle different alignment behaviour between
> different hw. This patch fixes improper retrieval of rfc1042 header
> with QCA4019. This patch along with "ath10k: Properly remove padding
> from the start of rx payload" will fix traffic failure in ethernet
> decap mode for QCA4019.
> 
> Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>

Patch applied to ath-next branch of ath.git, thanks.

2f38c3c01de9 ath10k: fix rfc1042 header retrieval in QCA4019 with eth decap mode

-- 
https://patchwork.kernel.org/patch/9249751/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
