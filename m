Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:57017 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751762AbcGRTEp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Jul 2016 15:04:45 -0400
Message-ID: <578D2846.5060600@candelatech.com> (sfid-20160718_210459_173275_4FF515E1)
Date: Mon, 18 Jul 2016 12:04:38 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>,
	Purushottam Kushwaha <pkushwah@qti.qualcomm.com>
CC: linux-wireless@vger.kernel.org, jouni@qca.qualcomm.com,
	usdutt@qti.qualcomm.com, ganeshk@qti.qualcomm.com,
	mkalikot@qca.qualcomm.com, amarnath@qca.qualcomm.com
Subject: Re: [PATCH v2] cfg80211: Allow differnt beacon interval if driver
 supports
References: <1468849985-6881-1-git-send-email-pkushwah@qti.qualcomm.com> <1468868209.2944.1.camel@sipsolutions.net>
In-Reply-To: <1468868209.2944.1.camel@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 07/18/2016 11:56 AM, Johannes Berg wrote:
> On Mon, 2016-07-18 at 19:23 +0530, Purushottam Kushwaha wrote:
>> Driver may allow support for different beacon interval on virtual
>> interfaces.
>> Allow if such support is advertised by driver. This adds new
>> ext_feature as NL80211_EXT_FEATURE_DIFF_BEACON_INTERVAL.
>
> We have NL80211_IFACE_COMB_STA_AP_BI_MATCH in interface combinations,
> perhaps it would make sense to also put this flag there?

I was under impression that ath9k had supported this for years,
but I guess I haven't tested it lately....

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
