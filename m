Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:49030 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754427AbeDTKav (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 20 Apr 2018 06:30:51 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: cjhuang@codeaurora.org
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [2/2] ath10k: support MAC address randomization in scan
References: <1522379640-6442-3-git-send-email-cjhuang@codeaurora.org>
        <20180416134238.B16596076A@smtp.codeaurora.org>
        <607d875c3a6fc806781e7ee5dc73c7e9@codeaurora.org>
Date: Fri, 20 Apr 2018 13:30:47 +0300
In-Reply-To: <607d875c3a6fc806781e7ee5dc73c7e9@codeaurora.org>
        (cjhuang@codeaurora.org's message of "Tue, 17 Apr 2018 15:29:13
        +0800")
Message-ID: <878t9ii2zs.fsf@kamboji.qca.qualcomm.com> (sfid-20180420_123055_224519_D21C99B3)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

cjhuang@codeaurora.org writes:

> On 2018-04-16 21:42, Kalle Valo wrote:
>> Carl Huang <cjhuang@codeaurora.org> wrote:
>>
>>> The ath10k reports the random_mac_addr capability to upper layer
>>> based on the service bit firmware reported. Driver sets the
>>> spoofed flag in scan_ctrl_flag to firmware if upper layer has
>>> enabled this feature in scan request.
>>>
>>> Test with QCA6174 hw3.0 and
>>> firmware-6.bin_WLAN.RM.4.4.1-00102-QCARMSWP-1,
>>> but QCA9377 is also affected.
>>>
>>> Signed-off-by: Carl Huang <cjhuang@codeaurora.org>
>>> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
>>
>> This added a new checkpatch warning:
>>
>> drivers/net/wireless/ath/ath10k/wmi-ops.h:123: Alignment should match
>> open parenthesis
>>
>> I fixed it in the pending branch.
>
> Kvalo, as the flag issue NL80211_FEATURE_SCHED_SCAN_RANDOM_MAC_ADDR
> will be fixed from Brian side, I don't need to submit V2 for it.
>
> For this alignment warning and sparse warnings in [1/2], as you fixed
> them in the pending branch, so I needn't do anything, right?

Correct, I'm planning to apply this soon.

-- 
Kalle Valo
