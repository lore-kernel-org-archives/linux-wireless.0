Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:47184 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725999AbeIFPAS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Sep 2018 11:00:18 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Thu, 06 Sep 2018 15:55:30 +0530
From: Balaji Pothunoori <bpothuno@codeaurora.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2 3/3] ath10k: management tx ack rssi capability check
In-Reply-To: <1535532794.5215.20.camel@sipsolutions.net>
References: <1532006789-32454-1-git-send-email-bpothuno@codeaurora.org>
 <1532006789-32454-4-git-send-email-bpothuno@codeaurora.org>
 (sfid-20180719_152706_974046_A35360D2)
 <1535532794.5215.20.camel@sipsolutions.net>
Message-ID: <d1446d6996ed97412dff5897d713a06b@codeaurora.org> (sfid-20180906_122534_069114_FD1C2C1C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2018-08-29 14:23, Johannes Berg wrote:
> On Thu, 2018-07-19 at 18:56 +0530, Balaji Pothunoori wrote:
>> 
>> 
>> -	if (test_bit(WMI_SERVICE_TX_DATA_ACK_RSSI, ar->wmi.svc_map))
>> +	if (test_bit(WMI_SERVICE_TX_DATA_ACK_RSSI, ar->wmi.svc_map) ||
>> +	    test_bit(WMI_SERVICE_HTT_MGMT_TX_COMP_VALID_FLAGS, 
>> ar->wmi.svc_map))
>>  		wiphy_ext_feature_set(ar->hw->wiphy,
>> -				NL80211_EXT_FEATURE_DATA_ACK_SIGNAL_SUPPORT);
>> +			NL80211_EXT_FEATURE_DATA_ACK_SIGNAL_SUPPORT);
> 
> You should use the new name, and fix indentation.
> 
> johannes

Sure, i will send updated v3 patch.
