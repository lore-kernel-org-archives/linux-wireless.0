Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:51194 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753103AbbKLXFx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Nov 2015 18:05:53 -0500
Message-ID: <56451B2F.3060704@codeaurora.org> (sfid-20151113_000622_203551_4C69AABE)
Date: Thu, 12 Nov 2015 15:05:19 -0800
From: Peter Oh <poh@codeaurora.org>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>,
	Peter Oh <poh@qca.qualcomm.com>, ath10k@lists.infradead.org
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2] cfg80211: add VHT support for Mesh
References: <ab294ba62856f00c06dde10b1bf57f5f341a7198.1447351137.git.poh@qca.qualcomm.com>	 <1447358605.2131.3.camel@sipsolutions.net>	 <564505A6.9030001@codeaurora.org>	 <1447364413.2131.5.camel@sipsolutions.net>	 <56451294.9060205@codeaurora.org> <1447367523.2131.6.camel@sipsolutions.net>
In-Reply-To: <1447367523.2131.6.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On 11/12/2015 02:32 PM, Johannes Berg wrote:
> On Thu, 2015-11-12 at 14:28 -0800, Peter Oh wrote:
>>   
>> Exactly the same communication mechanism and purpose are used with
>> NL80211_EXT_FEATURE_VHT_IBSS which is already a part of NL80211
>> feature
>> flag.
>> The new feature flag, NL80211_EXT_FEATURE_VHT_MESH, follows the same
>> purpose and usage.
> No, it doesn't. Check how the _IBSS one is used in the code to actually
> *do* something.
that's right. so take a look reset of explanation for this patch.
> johannes
Thanks,
Peter
