Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:53841 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934617AbdDSN7M (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 19 Apr 2017 09:59:12 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ath9k: Add Dell Wireless 1601 with wowlan capability
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <20170406135110.3f4d1f92@anakin>
References: <20170406135110.3f4d1f92@anakin>
To: =?utf-8?q?Damien_Th=C3=A9bault?= <damien@dtbo.net>
CC: <linux-wireless@vger.kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "QCA ath9k Development" <ath9k-devel@qca.qualcomm.com>
Message-ID: <1008815b6786468fabe113b52226484a@euamsexm01a.eu.qualcomm.com> (sfid-20170419_155915_458558_499A40ED)
Date: Wed, 19 Apr 2017 15:59:04 +0200
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Damien Thébault wrote:
> Add the Dell Wireless 1601 card as an AR9462 in the ath9k pci list.
> Note that the wowlan feature is supported and has been tested
> successfully.
> 
> Signed-off-by: Damien Thébault <damien@dtbo.net>

Patch applied to ath-next branch of ath.git, thanks.

050fd820dc17 ath9k: Add Dell Wireless 1601 with wowlan capability

-- 
https://patchwork.kernel.org/patch/9666923/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
