Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:43567 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750769AbbJNGRl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Oct 2015 02:17:41 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <c_mkenna@qti.qualcomm.com>
CC: Manikanta Pubbisetty <c_mpubbi@qti.qualcomm.com>,
	<linux-wireless@vger.kernel.org>, <ath10k@lists.infradead.org>
Subject: Re: [PATCHv2] ath10k: Enable adaptive CCA
References: <1444628598-806-1-git-send-email-c_mkenna@qti.qualcomm.com>
Date: Wed, 14 Oct 2015 09:17:13 +0300
In-Reply-To: <1444628598-806-1-git-send-email-c_mkenna@qti.qualcomm.com> (c.
	mkenna's message of "Mon, 12 Oct 2015 11:13:18 +0530")
Message-ID: <87bnc2nfdi.fsf@kamboji.qca.qualcomm.com> (sfid-20151014_081744_766663_10435401)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

<c_mkenna@qti.qualcomm.com> writes:

> From: Maharaja <c_mkenna@qti.qualcomm.com>
>
> European Union has made it mandatory that all devices working in 2.4 GHz
> has to adhere to the ETSI specification (ETSI EN 300 328 V1.9.1)
> beginnig this year. The standard basically speaks about interferences
> in 2.4Ghz band.
> For example, when 802.11 device detects interference, TX must be stopped
> as long as interference is present.
>
> Adaptive CCA is a feature, when enabled the device learns from the
> environment and configures CCA levels adaptively. This will improve
> detecting interferences and the device can stop trasmissions till the
> interference is present eventually leading to good performances in
> varying interference conditions.
>
> The patch includes code for enabling adaptive CCA for 10.2.4 firmware on
> QCA988X.
>
> Signed-off-by: Maharaja Kennadyrajan <c_mkenna@qti.qualcomm.com>
> Signed-off-by: Manikanta Pubbisetty <c_mpubbi@qti.qualcomm.com>

Please do not send untested code:

In function 'ath10k_core_get_fw_feature_str',
    inlined from 'ath10k_core_get_fw_features_str' at
    drivers/net/wireless/ath/ath10k/core.c:184:41:
drivers/net/wireless/ath/ath10k/core.c:161:2: error: call to
    '__compiletime_assert_162' declared with attribute error:
    BUILD_BUG_ON failed: ARRAY_SIZE(ath10k_core_fw_feature_str) !=
    ATH10K_FW_FEATURE_COUNT

-- 
Kalle Valo
