Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:38796 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750838AbeAYFfZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 25 Jan 2018 00:35:25 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v2,1/4] ath9k: Alternative EEPROM size for AR9003
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1516780939-7176-2-git-send-email-Wojciech.Dubowik@neratec.com>
References: <1516780939-7176-2-git-send-email-Wojciech.Dubowik@neratec.com>
To: Wojciech Dubowik <Wojciech.Dubowik@neratec.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com,
        Wojciech Dubowik <Wojciech.Dubowik@neratec.com>
Message-Id: <20180125053524.983BB60A60@smtp.codeaurora.org> (sfid-20180125_063528_563750_31FB1979)
Date: Thu, 25 Jan 2018 05:35:24 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Wojciech Dubowik <Wojciech.Dubowik@neratec.com> wrote:

> AR9003 factory calibration allows to use bigger EEPROM than
> standard 1k without changing the default layout. Allow
> probing of EEPROM at alternative address if initial check
> for default fails.
> The original ar9003 eeprom ops are still be used.
> 
> Signed-off-by: Wojciech Dubowik <Wojciech.Dubowik@neratec.com>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

4 patches applied to ath-next branch of ath.git, thanks.

528782ecf59f ath9k: Alternative EEPROM size for AR9003
34d4fcd8813a ath9k: Read noise floor calibration data from eeprom
8da58553cc63 ath9k: Use calibrated noise floor value when available
3717957ce55c ath9k: Display calibration data piers in debugfs

-- 
https://patchwork.kernel.org/patch/10181889/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
