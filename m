Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out.qualcomm.com ([129.46.98.28]:28211 "EHLO
        alexa-out.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750714AbdJ0Nqo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 27 Oct 2017 09:46:44 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [1/2] ath10k: move ath10k_mac_tdls_vif*() functions
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1507183709-585-1-git-send-email-akolli@qti.qualcomm.com>
References: <1507183709-585-1-git-send-email-akolli@qti.qualcomm.com>
To: <akolli@qti.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <akolli@codeaurora.org>,
        <linux-wireless@vger.kernel.org>,
        Anilkumar Kolli <akolli@qti.qualcomm.com>
Message-ID: <d28440c53e574b58851d99003f99f9b9@euamsexm01a.eu.qualcomm.com> (sfid-20171027_154648_054302_4F24630C)
Date: Fri, 27 Oct 2017 15:46:37 +0200
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

akolli@qti.qualcomm.com wrote:

> To be able to use ath10k_mac_tdls_vif_stations_count() in
> ath10k_hw_scan() in the following patch, move the functions
> earlier in the file.
> 
> This commit is pure code move, no functional changes.
> 
> Signed-off-by: Anilkumar Kolli <akolli@qti.qualcomm.com>
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>

2 patches applied to ath-next branch of ath.git, thanks.

dd0f9cd6bc6a ath10k: move ath10k_mac_tdls_vif*() functions
a60809313b96 ath10k: block offchannel operations if TDLS session is active

-- 
https://patchwork.kernel.org/patch/9986447/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
