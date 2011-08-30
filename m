Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:36398 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752398Ab1H3JK1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Aug 2011 05:10:27 -0400
Message-ID: <4E5CA8FF.6020704@qca.qualcomm.com> (sfid-20110830_111030_772641_35CBFE6E)
Date: Tue, 30 Aug 2011 14:40:23 +0530
From: Raja Mani <rmani@qca.qualcomm.com>
MIME-Version: 1.0
To: Jouni Malinen <jouni@qca.qualcomm.com>
CC: <kvalo@qca.qualcomm.com>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 01/20] ath6kl: Add functionality for starting AP mode
References: <1314620641-24257-1-git-send-email-jouni@qca.qualcomm.com> <1314620641-24257-2-git-send-email-jouni@qca.qualcomm.com> <4E5C797F.3090900@qca.qualcomm.com> <20110830084046.GC2279@jouni.qca.qualcomm.com>
In-Reply-To: <20110830084046.GC2279@jouni.qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 30 August 2011 02:10 PM, Jouni Malinen wrote:
> On Tue, Aug 30, 2011 at 11:17:43AM +0530, Raja Mani wrote:
>> On Monday 29 August 2011 05:53 PM, Jouni Malinen wrote:
>>> +static int ath6kl_ap_beacon(struct wiphy *wiphy, struct net_device *dev,
>>> +			    struct beacon_parameters *info, bool add)
>>> +{
>
>>> +	if (!test_bit(WMI_READY,&ar->flag))
>>> +		return -EIO;
>>> +
>>> +	if (!test_bit(WLAN_ENABLED,&ar->flag))
>>> +		return -EIO;
>>
>> How about calling ath6kl_cfg80211_ready() function to check
>> WMI_READY and WLAN_ENABLED status ?
>
> Sure, I can do that, but unless something else comes up, I would rather
> do it after the patch series goes in. It looks like I missed addition of
> that helper function since I started working on this before the cleanup
> was complete.

Okay.

>
> By the way.. How did that message lost the space after the commas on
> those test_bit lines? They are included in the patch I sent.
>

When i opened your patch, I saw your complete patch code. Could be 
deleted by mistake when i sent reply..
