Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:65079 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755478Ab2FGIiq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jun 2012 04:38:46 -0400
Message-ID: <4FD0688F.5020603@qca.qualcomm.com> (sfid-20120607_103853_481216_7982BAE5)
Date: Thu, 7 Jun 2012 14:08:39 +0530
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	<linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] mac80211: ratelimit few aggregated messages
References: <1339048943-4643-1-git-send-email-mohammed@qca.qualcomm.com>	 <1339050308.6009.9.camel@joe2Laptop> <4FD0540C.5060808@qca.qualcomm.com>	 <1339053852.6009.13.camel@joe2Laptop> <4FD05A27.80102@qca.qualcomm.com> <1339055836.6009.20.camel@joe2Laptop>
In-Reply-To: <1339055836.6009.20.camel@joe2Laptop>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 07 June 2012 01:27 PM, Joe Perches wrote:
> On Thu, 2012-06-07 at 13:07 +0530, Mohammed Shafi Shajakhan wrote:
>> what about the other wiphy_debug messages, we would
>> still retain them know
>
> Yes, and...
>
> No, you know those should now still be wiphy_debug
> unless the message is HT related and need a new change.

sure. so lets drop this patch and do that generic stuff.

>
> All sorts of kneed/need, knitting/nitting bits are in
> my head right now, but I'll spare all of you any more.
>
> English is still a spelt-silly language.


:)

>
> cheers, Joe
>


-- 
thanks,
shafi
