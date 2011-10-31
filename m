Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:8321 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932221Ab1JaJzj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Oct 2011 05:55:39 -0400
Message-ID: <4EAE7096.5040802@qca.qualcomm.com> (sfid-20111031_105541_403471_EBD32CC6)
Date: Mon, 31 Oct 2011 15:25:34 +0530
From: Raja Mani <rmani@qca.qualcomm.com>
MIME-Version: 1.0
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 0/7] ath6kl: Add WOW support
References: <1319539047-8756-1-git-send-email-rmani@qca.qualcomm.com> <4EAA98EF.9070004@qca.qualcomm.com>
In-Reply-To: <4EAA98EF.9070004@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 28 October 2011 05:28 PM, Kalle Valo wrote:
> On 10/25/2011 01:37 PM, rmani@qca.qualcomm.com wrote:
>
>> Using these patch sets, WOW patterns can be controlled
>> and configured via iw command. Please refer iw help menu for more details.
>>
>> There are some limitation in the recent "iw" command such as it doesn't
>> take the pattern offset where to start pattern matching in the received packets.
>> Such a enhancement will be done later..
>>
>> These patch sets are re-based on master branch, available in git://github.com/kvalo/ath6kl.git
>
> These patches conflict with multi vif so you need to rebase your
> patches. I also saw few sparse warnings:

Thanks for your review, I'll fix below sparse warnings and rebase & 
submit V2.

>
> drivers/net/wireless/ath/ath6kl/cfg80211.c:1512:42: warning: incorrect
> type in assignment (different base types)
> drivers/net/wireless/ath/ath6kl/cfg80211.c:1512:42:    expected
> restricted __le16 [addressable] [assigned] [usertype] host_req_delay
> drivers/net/wireless/ath/ath6kl/cfg80211.c:1512:42:    got restricted
> __le32 [usertype]<noident>
> drivers/net/wireless/ath/ath6kl/cfg80211.c:1485:5: warning: symbol
> 'ath6kl_pm_wow_suspend' was not declared. Should it be static?
> drivers/net/wireless/ath/ath6kl/cfg80211.c:1586:5: warning: symbol
> 'ath6kl_pm_wow_resume' was not declared. Should it be static?
>
> Kalle
