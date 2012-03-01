Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:46993 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754032Ab2CAIID (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Mar 2012 03:08:03 -0500
Message-ID: <4F4F2E58.7070302@qca.qualcomm.com> (sfid-20120301_090808_284820_5A8B2939)
Date: Thu, 1 Mar 2012 13:37:52 +0530
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
MIME-Version: 1.0
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: Re: [PATCH V3 1/5] ath6kl: Group wiphy initialization into ath6kl_cfg80211_init()
References: <1330440623-5649-1-git-send-email-vthiagar@qca.qualcomm.com> <4F4F1817.9070904@qca.qualcomm.com> <4F4F2030.9080805@qca.qualcomm.com>
In-Reply-To: <4F4F2030.9080805@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 01 March 2012 12:37 PM, Kalle Valo wrote:
> On 03/01/2012 08:32 AM, Kalle Valo wrote:
>> On 02/28/2012 04:50 PM, Vasanthakumar Thiagarajan wrote:
>>> There are some code which initializes various wiphy members
>>> left outside ath6kl_cfg80211_init(), in ath6kl_core_init().
>>> Move them into a single palce.
>>>
>>> Signed-off-by: Vasanthakumar Thiagarajan<vthiagar@qca.qualcomm.com>
>>
>> Thanks, all five patches applied.
>
> There's an issue and I think these patches might cause it. Earlier (with
> commit 9289a8a8e2) my ath6kl device was always wlan0:

I never noticed any such issues, sure i'll review it once again. Thanks 
for reporting this.

Vasanth
