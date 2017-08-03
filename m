Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out.qualcomm.com ([129.46.98.28]:64390 "EHLO
        alexa-out-lv-02.qualcomm.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752270AbdHCLhY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 3 Aug 2017 07:37:24 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [PATCHv2,
 1/3] ath10k: extend wmi service map to accommodate new services
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1500379094-2373-2-git-send-email-mpubbise@qti.qualcomm.com>
References: <1500379094-2373-2-git-send-email-mpubbise@qti.qualcomm.com>
To: <mpubbise@qti.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Message-ID: <13b5ffdef43a4561b3cd123114cd0b8f@euamsexm01a.eu.qualcomm.com> (sfid-20170803_133728_575678_AC1BE6C1)
Date: Thu, 3 Aug 2017 13:37:18 +0200
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

mpubbise@qti.qualcomm.com wrote:

> Though there is room to accommodate 512 services in wmi service
> ready event, target uses only first 4-bits of each 32-bit word for
> advertising wmi services thereby limiting max wmi services to 64.
> 
> TDLS implementation for 10.4 firmwares introduces new wmi services by
> making use of remaining unused bits of each 32-bit word, therefore the
> wmi service mapping in host needs to be extended.
> 
> This patch adds the logic to extend the wmi SVCMAP to accommodate new
> wmi services.
> 
> Signed-off-by: Manikanta Pubbisetty <mpubbise@qti.qualcomm.com>
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>

3 patches applied to ath-next branch of ath.git, thanks.

810fe818d6a1 ath10k: extend wmi service map to accommodate new services
add6cd8d5ab7 ath10k: add tdls support for 10.4 firmwares
be5b4f4002a6 ath10k: push peer type to target for TDLS peers

-- 
https://patchwork.kernel.org/patch/9848157/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
