Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:32834 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751939AbcA0MUQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jan 2016 07:20:16 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: "Grumbach\, Emmanuel" <emmanuel.grumbach@intel.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: pull request: iwlwifi 2016-01-26
References: <0BA3FCBA62E2DC44AF3030971E174FB32E9D452F@hasmsx109.ger.corp.intel.com>
	<87h9i0qwjp.fsf@kamboji.qca.qualcomm.com>
	<0BA3FCBA62E2DC44AF3030971E174FB32E9D570C@hasmsx109.ger.corp.intel.com>
	<1453816889.2759.72.camel@sipsolutions.net>
	<0BA3FCBA62E2DC44AF3030971E174FB32E9D5780@hasmsx109.ger.corp.intel.com>
Date: Wed, 27 Jan 2016 14:20:08 +0200
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E9D5780@hasmsx109.ger.corp.intel.com>
	(Emmanuel Grumbach's message of "Tue, 26 Jan 2016 14:05:56 +0000")
Message-ID: <87oac7nrif.fsf@kamboji.qca.qualcomm.com> (sfid-20160127_132019_449420_27C90D17)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Grumbach, Emmanuel" <emmanuel.grumbach@intel.com> writes:

> On 01/26/2016 04:01 PM, Johannes Berg wrote:
>>>> There's a conflict due to 8f57e4d930d, how should I fix it?
>> I think we can thus drop my patch - that commit fixes the issue that
>> Andrew had reported as well, and that I worked around by casting the
>> result... now that abs() has a consistent result, using s32 in both
>> sides of the min() is perfectly fine.
>>
>> johannes
>>
>>
>
> I did just that in my new tag: iwlwifi-for-kalle-2016-01-26_2

Pulled, thanks.

-- 
Kalle Valo
