Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:35188 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752282AbdDEHeP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 5 Apr 2017 03:34:15 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ath10k: Fix NAPI enable/disable symmetry for AHB interface
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1490023366-8176-1-git-send-email-mohammed@qca.qualcomm.com>
References: <1490023366-8176-1-git-send-email-mohammed@qca.qualcomm.com>
To: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <mohammed@codeaurora.org>,
        <linux-wireless@vger.kernel.org>,
        Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
Message-ID: <03b850bce8814651b5a0b021f4597ce2@euamsexm01a.eu.qualcomm.com> (sfid-20170405_093418_954154_20E58BD3)
Date: Wed, 5 Apr 2017 09:34:07 +0200
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com> wrote:
> From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
> 
> Move NAPI enable to 'ath10k_ahb_hif_start' from
> 'ath10k_ahb_hif_power_up'. This is to maintain the symmetry
> of calling napi_enable() from ath10k_ahb_hif_start() so that it
> matches with  napi_disable() being called from ath10k_pci_hif_stop().
> 
> This change is based on the crash fix from Kalle for PCI interface in
> commit 1427228d5869 ("ath10k: fix napi crash during rmmod when probe
> firmware fails").
> 
> Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>

Patch applied to ath-next branch of ath.git, thanks.

a7595a820b07 ath10k: fix NAPI enable/disable symmetry for AHB interface

-- 
https://patchwork.kernel.org/patch/9634379/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
