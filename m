Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:3383 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751054AbcFEFGQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 5 Jun 2016 01:06:16 -0400
From: "Thiagarajan, Vasanthakumar" <vthiagar@qti.qualcomm.com>
To: "Valo, Kalle" <kvalo@qca.qualcomm.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/2] ath10k: Define an enum to enable cycle counter
 wraparound logic
Date: Sun, 5 Jun 2016 05:06:08 +0000
Message-ID: <5753B330.1070804@qti.qualcomm.com> (sfid-20160605_070641_192977_7A2BFAA7)
References: <1464968596-19834-1-git-send-email-vthiagar@qti.qualcomm.com>
 <8760tpt37i.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <8760tpt37i.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset="Windows-1252"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>> --- a/drivers/net/wireless/ath/ath10k/core.c
>> +++ b/drivers/net/wireless/ath/ath10k/core.c
>> @@ -55,7 +55,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
>>   		.name = "qca988x hw2.0",
>>   		.patch_load_addr = QCA988X_HW_2_0_PATCH_LOAD_ADDR,
>>   		.uart_pin = 7,
>> -		.has_shifted_cc_wraparound = true,
>> +		.cc_wraparound_type = ATH10K_HW_CC_WRAP_SHIFTED_ALL,
>>   		.otp_exe_param = 0,
>>   		.channel_counters_freq_hz = 88000,
>>   		.max_probe_resp_desc_thres = 0,
>> @@ -224,7 +224,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
>>   		.name = "qca4019 hw1.0",
>>   		.patch_load_addr = QCA4019_HW_1_0_PATCH_LOAD_ADDR,
>>   		.uart_pin = 7,
>> -		.has_shifted_cc_wraparound = true,
>> +		.cc_wraparound_type = ATH10K_HW_CC_WRAP_SHIFTED_ALL,
>>   		.otp_exe_param = 0x0010000,
>>   		.continuous_frag_desc = true,
>>   		.channel_counters_freq_hz = 125000,
>
> As the pending branch has the QCA9887 patch I added
> ATH10K_HW_CC_WRAP_SHIFTED_ALL also for QCA9887. Please review my changes
> in the pending branch:
>
> https://git.kernel.org/cgit/linux/kernel/git/kvalo/ath.git/commit/?h=pending&id=2fa32dbd9f26e8b2f323ca30ad116ea486840aba
>

Looks good, thanks.

Vasanth
