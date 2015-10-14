Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:28020 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752579AbbJNKME convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Oct 2015 06:12:04 -0400
From: "Kennady Rajan, Maharaja" <c_mkenna@qti.qualcomm.com>
To: "Valo, Kalle" <kvalo@qca.qualcomm.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Subject: Re: [PATCHv2] ath10k: Enable adaptive CCA
Date: Wed, 14 Oct 2015 10:11:46 +0000
Message-ID: <1444817512360.4749@qti.qualcomm.com> (sfid-20151014_121210_394189_C1BCA54A)
References: <1444628598-806-1-git-send-email-c_mkenna@qti.qualcomm.com>,<87bnc2nfdi.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <87bnc2nfdi.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=US-ASCII
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> From: Maharaja <c_mkenna@qti.qualcomm.com>
>
>> European Union has made it mandatory that all devices working in 2.4 GHz
>> has to adhere to the ETSI specification (ETSI EN 300 328 V1.9.1)
>> beginnig this year. The standard basically speaks about interferences
>> in 2.4Ghz band.
>> For example, when 802.11 device detects interference, TX must be stopped
>> as long as interference is present.
>
>> Adaptive CCA is a feature, when enabled the device learns from the
>> environment and configures CCA levels adaptively. This will improve
>> detecting interferences and the device can stop trasmissions till the
>> interference is present eventually leading to good performances in
>> varying interference conditions.
>
>> The patch includes code for enabling adaptive CCA for 10.2.4 firmware on
>> QCA988X.
>
>> Signed-off-by: Maharaja Kennadyrajan <c_mkenna@qti.qualcomm.com>
>> Signed-off-by: Manikanta Pubbisetty <c_mpubbi@qti.qualcomm.com>

>Please do not send untested code:

>In function 'ath10k_core_get_fw_feature_str',
>    inlined from 'ath10k_core_get_fw_features_str' at
>    drivers/net/wireless/ath/ath10k/core.c:184:41:
>drivers/net/wireless/ath/ath10k/core.c:161:2: error: call to
>    '__compiletime_assert_162' declared with attribute error:
>    BUILD_BUG_ON failed: ARRAY_SIZE(ath10k_core_fw_feature_str) !=
>    ATH10K_FW_FEATURE_COUNT

I have missed to add the wireless module in menuconfig while compilation. So I haven't see the errors while running the compilation script. Now I changed and compilation error has been resolved.

Regards,
Maha