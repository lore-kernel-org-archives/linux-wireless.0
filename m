Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:22605 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753181AbdDEHiI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 5 Apr 2017 03:38:08 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ath10k: Enable a HTC debug message during insufficient tx credits
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1490961566-328-1-git-send-email-mohammed@qca.qualcomm.com>
References: <1490961566-328-1-git-send-email-mohammed@qca.qualcomm.com>
To: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <mohammed@codeaurora.org>,
        <linux-wireless@vger.kernel.org>,
        Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
Message-ID: <cc825d32e7ce406bb172c9d05bbd22ee@euamsexm01a.eu.qualcomm.com> (sfid-20170405_093811_241403_E6B2AFC3)
Date: Wed, 5 Apr 2017 09:38:00 +0200
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com> wrote:
> From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
> 
> Add an ath10k HTC debug message when insufficient tx credits
> are available to send the WMI commands. This is very useful
> in debugging issues like 'tx credit starvation' that could
> possibly happen with multiclient setup with constant roaming
> 
> Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>

Patch applied to ath-next branch of ath.git, thanks.

03e463a4197a ath10k: enable a HTC debug message during insufficient tx credits

-- 
https://patchwork.kernel.org/patch/9656099/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
