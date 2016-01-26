Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:15332 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965332AbcAZOGX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jan 2016 09:06:23 -0500
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>,
	Kalle Valo <kvalo@codeaurora.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: pull request: iwlwifi 2016-01-26
Date: Tue, 26 Jan 2016 14:05:56 +0000
Message-ID: <0BA3FCBA62E2DC44AF3030971E174FB32E9D5780@hasmsx109.ger.corp.intel.com> (sfid-20160126_150626_097240_F582A091)
References: <0BA3FCBA62E2DC44AF3030971E174FB32E9D452F@hasmsx109.ger.corp.intel.com>
 <87h9i0qwjp.fsf@kamboji.qca.qualcomm.com>
 <0BA3FCBA62E2DC44AF3030971E174FB32E9D570C@hasmsx109.ger.corp.intel.com>
 <1453816889.2759.72.camel@sipsolutions.net>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 01/26/2016 04:01 PM, Johannes Berg wrote:
>>> There's a conflict due to 8f57e4d930d, how should I fix it?
> I think we can thus drop my patch - that commit fixes the issue that
> Andrew had reported as well, and that I worked around by casting the
> result... now that abs() has a consistent result, using s32 in both
> sides of the min() is perfectly fine.
>
> johannes
>
>

I did just that in my new tag: iwlwifi-for-kalle-2016-01-26_2
