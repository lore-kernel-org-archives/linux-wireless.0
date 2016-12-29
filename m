Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:56443 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752474AbcL2NSX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 29 Dec 2016 08:18:23 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [1/5] ath10k: fix IRAM banks number for QCA9377
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1481130454-27244-1-git-send-email-bartosz.markowski@tieto.com>
References: <1481130454-27244-1-git-send-email-bartosz.markowski@tieto.com>
To: Bartosz Markowski <bartosz.markowski@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
        "Bartosz Markowski" <bartosz.markowski@tieto.com>
Message-ID: <ad2a4327484c42999daeb8e94ea3e525@euamsexm01a.eu.qualcomm.com> (sfid-20161229_142012_723701_F882F09C)
Date: Thu, 29 Dec 2016 14:18:15 +0100
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bartosz Markowski <bartosz.markowski@tieto.com> wrote:
> QCA9377 firmware shall alloc 4 IRAM banks
> 
> Signed-off-by: Bartosz Markowski <bartosz.markowski@tieto.com>

5 patches applied to ath-next branch of ath.git, thanks.

77cf13ad5731 ath10k: fix IRAM banks number for QCA9377
b08b5b53a1ed ath10k: override CE5 config for QCA9377
35bac90abf5e ath10k: decrease num of peers support
7cfe0455ee12 ath10k: set CTS protection VDEV param only if VDEV is up
861769017404 ath10k: add debug trace to rts/cts set function

-- 
https://patchwork.kernel.org/patch/9464915/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
