Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out.qualcomm.com ([129.46.98.28]:36470 "EHLO
        alexa-out.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751687AbdLBOZ1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 2 Dec 2017 09:25:27 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v4] wcn36xx: Set default BTLE coexistence config
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <20171116080126.17239-1-rfried@codeaurora.org>
References: <20171116080126.17239-1-rfried@codeaurora.org>
To: Ramon Fried <rfried@codeaurora.org>
CC: <kvalo@codeaurora.org>, <k.eugene.e@gmail.com>,
        <wcn36xx@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
        <netdev@vger.kernel.org>, <bjorn.andersson@linaro.org>,
        <nicolas.dechesne@linaro.org>, Eyal Ilsar <eilsar@codeaurora.org>,
        "Ramon Fried" <rfried@codeaurora.org>
Message-ID: <895e19e4aa5842af800ae774b29599a3@euamsexm01a.eu.qualcomm.com> (sfid-20171202_152534_201347_1E3C546C)
Date: Sat, 2 Dec 2017 15:25:17 +0100
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ramon Fried <rfried@codeaurora.org> wrote:

> If the value for the firmware configuration parameters
> BTC_STATIC_LEN_LE_BT and BTC_STATIC_LEN_LE_WLAN are not set the duty
> cycle between BT and WLAN is such that if BT (including BLE) is active
> WLAN gets 0 bandwidth. When tuning these parameters having a too high
> value for WLAN means that BLE performance degrades.
> The "sweet" point of roughly half of the maximal values was empirically
> found to achieve a balance between BLE and Wi-Fi coexistence
> performance.
> 
> Signed-off-by: Eyal Ilsar <eilsar@codeaurora.org>
> Signed-off-by: Ramon Fried <rfried@codeaurora.org>
> Acked-by: Bjorn Andersson <bjorn.andersson@linaro.org>
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>

Patch applied to ath-next branch of ath.git, thanks.

4119b6160a35 wcn36xx: set default BTLE coexistence config

-- 
https://patchwork.kernel.org/patch/10060833/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
