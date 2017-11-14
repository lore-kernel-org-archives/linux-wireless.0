Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:55254 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750888AbdKNGyn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 14 Nov 2017 01:54:43 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Ramon Fried <rfried@codeaurora.org>
Cc: k.eugene.e@gmail.com, wcn36xx@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bjorn.andersson@linaro.org,
        nicolas.dechesne@linaro.org, Eyal Ilsar <eilsar@codeaurora.org>
Subject: Re: [PATCH] wcn36xx: Set BTLE coexistence related configuration values to defaults
References: <1510496506-4428-1-git-send-email-rfried@codeaurora.org>
Date: Tue, 14 Nov 2017 08:54:37 +0200
In-Reply-To: <1510496506-4428-1-git-send-email-rfried@codeaurora.org> (Ramon
        Fried's message of "Sun, 12 Nov 2017 16:21:46 +0200")
Message-ID: <871sl1jqoi.fsf@kamboji.qca.qualcomm.com> (sfid-20171114_075526_439100_4F4F961A)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ramon Fried <rfried@codeaurora.org> writes:

> From: Eyal Ilsar <eilsar@codeaurora.org>
>
> If the value for the firmware configuration parameters
> BTC_STATIC_LEN_LE_BT and BTC_STATIC_LEN_LE_WLAN are not set the duty
> cycle between BT and WLAN is such that if BT (including BLE) is active
> WLAN gets 0 bandwidth. When tuning these parameters having a too high
> value for WLAN means that BLE performance degrades. The "sweet" point
> of roughly half of the maximal values was empirically found to achieve
> a balance between BLE and Wi-Fi coexistence performance.
>
> Signed-off-by: Eyal Ilsar <eilsar@codeaurora.org>
> Signed-off-by: Ramon Fried <rfried@codeaurora.org>

Then submit a new version of the patch then please include the version
number:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches#patch_version_missing

So after fixing Bjorn's comments the next version should be v3.

-- 
Kalle Valo
