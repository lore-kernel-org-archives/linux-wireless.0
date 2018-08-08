Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-he1eur01on0060.outbound.protection.outlook.com ([104.47.0.60]:24752
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728330AbeHHVWH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 8 Aug 2018 17:22:07 -0400
Subject: Re: [PATCH v2 0/2] Change sk_pacing_shift in ieee80211_hw for best tx
 throughput
To: Wen Gong <wgong@codeaurora.org>, ath10k@lists.infradead.org,
        johannes@sipsolutions.net
References: <1533724802-30944-1-git-send-email-wgong@codeaurora.org>
Cc: linux-wireless@vger.kernel.org
From: Peter Oh <peter.oh@bowerswilkins.com>
Message-ID: <4dbcc269-1f2b-b165-fe9e-8704fd77d1c5@bowerswilkins.com> (sfid-20180808_210113_792369_D6DFE9AA)
Date: Wed, 8 Aug 2018 12:00:46 -0700
MIME-Version: 1.0
In-Reply-To: <1533724802-30944-1-git-send-email-wgong@codeaurora.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 08/08/2018 03:40 AM, Wen Gong wrote:
> Add a field for ath10k to adjust the sk_pacing_shift, mac80211 set
> the default value to 8, and ath10k will change it to 6. Then mac80211
> will use the changed value 6 as sk_pacing_shift since 6 is the best
> value for tx throughput by test result.
I don't think you can convince people with the numbers unless you 
provide latency along with the numbers and also measurement result on 
different chipsets as Michal addressed (QCA4019, QCA9984, etc.) From 
users view point, I also agree on Toke that we cannot scarify latency 
for the small throughput improvement.

Thanks,
Peter
