Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:47061 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751353Ab2FME7a (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jun 2012 00:59:30 -0400
Message-ID: <4FD81E2C.1000507@qca.qualcomm.com> (sfid-20120613_065934_563792_EB6CAA48)
Date: Wed, 13 Jun 2012 10:29:24 +0530
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	<linux-wireless@vger.kernel.org>,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
Subject: Re: [PATCH] mac80211: ratelimit few aggregated messages
References: <1339048943-4643-1-git-send-email-mohammed@qca.qualcomm.com>	 <1339050308.6009.9.camel@joe2Laptop> <4FD0540C.5060808@qca.qualcomm.com>	 <1339053852.6009.13.camel@joe2Laptop> <4FD05A27.80102@qca.qualcomm.com>	 <1339055836.6009.20.camel@joe2Laptop> <4FD0688F.5020603@qca.qualcomm.com> <1339098774.14838.4.camel@joe2Laptop>
In-Reply-To: <1339098774.14838.4.camel@joe2Laptop>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Joe,

On Friday 08 June 2012 01:22 AM, Joe Perches wrote:
> On Thu, 2012-06-07 at 14:08 +0530, Mohammed Shafi Shajakhan wrote:
>> On Thursday 07 June 2012 01:27 PM, Joe Perches wrote:
>>> On Thu, 2012-06-07 at 13:07 +0530, Mohammed Shafi Shajakhan wrote:
>>>> what about the other wiphy_debug messages, we would
>>>> still retain them know
>>>
>>> Yes, and...
>>>
>>> No, you know those should now still be wiphy_debug
>>> unless the message is HT related and need a new change.
>>
>> sure. so lets drop this patch and do that generic stuff.
>
> I did a little while ago.
> Please modify the patch based on wireless-next commit d63e9ae3b12

sorry for the delayed reply. so you had already posted the change you 
had suggested in (netdev@vger.kernel.org mailing list ?) and i have to 
do any changes based on that patch right ? thank you!


-- 
thanks,
shafi
