Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:50860 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727072AbeIDRBm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 4 Sep 2018 13:01:42 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Tue, 04 Sep 2018 18:06:44 +0530
From: Balaji Pothunoori <bpothuno@codeaurora.org>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH v3] ath10k: average ack rssi support for data frames
In-Reply-To: <87va7l78vp.fsf@kamboji.qca.qualcomm.com>
References: <1536062951-17955-1-git-send-email-bpothuno@codeaurora.org>
 <87va7l78vp.fsf@kamboji.qca.qualcomm.com>
Message-ID: <aa4584654d70628c0f553d96786b49ea@codeaurora.org> (sfid-20180904_143648_441062_13EF9D4D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2018-09-04 17:49, Kalle Valo wrote:
> Balaji Pothunoori <bpothuno@codeaurora.org> writes:
> 
>> Average ack rssi value is weighted average of ack rssi for
>> no of msdu's has been sent.
>> This feature is enabled by the host driver if firmware is capable.
>> After receiving event from host, firmware allocates the necessary
>> memory to store the ack_rssi for data packets during the init time.
>> 
>> After each successful transmission, If tx completion status is OK
>> and 24th bit is set in HTT message header then host will fetch the
>> ack_rssi else host can ignore the ack_rssi field
>> 
>> Signed-off-by: Balaji Pothunoori <bpothuno@codeaurora.org>
>> ---
>> v2:
>>    Addressed ath10k-check warnings
>> v3:
>>    cfg80211/mac80211 changes are already merged hence
>>    rebased ath10k patch alone.
> 
> Heh, we had a collision. Just 2 hours ago I rebased v2, fixed some
> conflicts and it's now in pending branch:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git/commit/?h=pending&id=ca376d236d335ccc9475ea1ab49df4643d8246b7
> 
> So please check that, and if it's good most likely I'll drop this v3.

Thanks kalle,
I am fine with the changes and you can ignore this v3.

Regards,
Balaji.
