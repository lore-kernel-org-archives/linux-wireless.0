Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:36380 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751085AbeDQH3O (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 17 Apr 2018 03:29:14 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Tue, 17 Apr 2018 15:29:13 +0800
From: cjhuang@codeaurora.org
To: Kalle Valo <kvalo@codeaurora.org>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [2/2] ath10k: support MAC address randomization in scan
In-Reply-To: <20180416134238.B16596076A@smtp.codeaurora.org>
References: <1522379640-6442-3-git-send-email-cjhuang@codeaurora.org>
 <20180416134238.B16596076A@smtp.codeaurora.org>
Message-ID: <607d875c3a6fc806781e7ee5dc73c7e9@codeaurora.org> (sfid-20180417_092918_459997_0EB04ABC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2018-04-16 21:42, Kalle Valo wrote:
> Carl Huang <cjhuang@codeaurora.org> wrote:
> 
>> The ath10k reports the random_mac_addr capability to upper layer
>> based on the service bit firmware reported. Driver sets the
>> spoofed flag in scan_ctrl_flag to firmware if upper layer has
>> enabled this feature in scan request.
>> 
>> Test with QCA6174 hw3.0 and 
>> firmware-6.bin_WLAN.RM.4.4.1-00102-QCARMSWP-1,
>> but QCA9377 is also affected.
>> 
>> Signed-off-by: Carl Huang <cjhuang@codeaurora.org>
>> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
> 
> This added a new checkpatch warning:
> 
> drivers/net/wireless/ath/ath10k/wmi-ops.h:123: Alignment should match
> open parenthesis
> 
> I fixed it in the pending branch.

Kvalo, as the flag issue NL80211_FEATURE_SCHED_SCAN_RANDOM_MAC_ADDR will 
be fixed from
Brian side, I don't need to submit V2 for it.

For this alignment warning and sparse warnings in [1/2], as you fixed 
them in the pending
branch, so I needn't do anything, right?


Thanks,
Carl
