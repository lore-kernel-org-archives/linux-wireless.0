Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out.qualcomm.com ([129.46.98.28]:18948 "EHLO
        alexa-out.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750962AbdJ0Nse (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 27 Oct 2017 09:48:34 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ath10k: fix sending wmi cmd during the tdls teardown
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1507183926-711-1-git-send-email-akolli@qti.qualcomm.com>
References: <1507183926-711-1-git-send-email-akolli@qti.qualcomm.com>
To: <akolli@qti.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <akolli@codeaurora.org>,
        <linux-wireless@vger.kernel.org>,
        Anilkumar Kolli <akolli@qti.qualcomm.com>
Message-ID: <d0abf2d53d544745b0e845314e13e045@euamsexm01a.eu.qualcomm.com> (sfid-20171027_154837_131650_06030E49)
Date: Fri, 27 Oct 2017 15:48:27 +0200
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

akolli@qti.qualcomm.com wrote:

> The current firmware 10.4-3.5.1-00035 on QCA9888 supports
> TDLS explicit mode, it expects WMI_TDLS_ENABLE_PASSIVE
> for tdls setup and WMI_TDLS_DISABLE for tdls teardown.
> 
> Signed-off-by: Anilkumar Kolli <akolli@qti.qualcomm.com>
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>

Patch applied to ath-next branch of ath.git, thanks.

e5b6853e9922 ath10k: fix sending wmi cmd during the tdls teardown

-- 
https://patchwork.kernel.org/patch/9986455/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
