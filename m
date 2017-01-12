Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:53861 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750817AbdALK5a (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 12 Jan 2017 05:57:30 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ath5k: drop bogus warning on drv_set_key with unsupported cipher
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <20161227111609.11113-1-nbd@nbd.name>
References: <20161227111609.11113-1-nbd@nbd.name>
To: Felix Fietkau <nbd@nbd.name>
CC: <linux-wireless@vger.kernel.org>, <kvalo@codeaurora.org>
Message-ID: <c74b45b76a9d4e6696fb58a55580f86c@euamsexm01a.eu.qualcomm.com> (sfid-20170112_115734_701188_25C3451B)
Date: Thu, 12 Jan 2017 11:56:55 +0100
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Felix Fietkau <nbd@nbd.name> wrote:
> Simply return -EOPNOTSUPP instead.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Felix Fietkau <nbd@nbd.name>

Patch applied to ath-next branch of ath.git, thanks.

a70e1d6fd6b5 ath5k: drop bogus warning on drv_set_key with unsupported cipher

-- 
https://patchwork.kernel.org/patch/9489183/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
