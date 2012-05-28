Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:29701 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751602Ab2E1GvS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 May 2012 02:51:18 -0400
Message-ID: <4FC3205E.6020608@qca.qualcomm.com> (sfid-20120528_085120_750690_5A086F39)
Date: Mon, 28 May 2012 12:21:10 +0530
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	<linux-wireless@vger.kernel.org>
Subject: Re: [RFC] mac80211: net_ratelimit few aggregation related messages
References: <1337960224-7428-1-git-send-email-mohammed@qca.qualcomm.com>	 <1337976166.30100.6.camel@joe2Laptop> <4FC3180F.1060902@qca.qualcomm.com>	 <1338186413.2202.16.camel@joe2Laptop> <4FC31BDC.1050401@qca.qualcomm.com> <1338187439.2202.20.camel@joe2Laptop>
In-Reply-To: <1338187439.2202.20.camel@joe2Laptop>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 28 May 2012 12:13 PM, Joe Perches wrote:
> On Mon, 2012-05-28 at 12:01 +0530, Mohammed Shafi Shajakhan wrote:
>> On Monday 28 May 2012 11:56 AM, Joe Perches wrote:
>>> On Mon, 2012-05-28 at 11:45 +0530, Mohammed Shafi Shajakhan wrote:
>>>> just today saw this link where you had introduced net_dbg_ratelimited
>>>> http://www.digipedia.pl/usenet/thread/18978/31017/
>>>> so should i send the v2 patch using net_dbg_ratelimited to net-next
>>>> rather than wireless-testing tree ?
>>>
>>> Yes, but you should wait until net-next opens
>>> for patches (after Linus' -rc1 is released)
>> Joe, once Linus release rc1, will your changes will be updated in
>> wireless-testing ,
>
> I presume so, the patch is in Linus' tree for 3.4.
>
>> so that i can send a patch directly to John/linux
>> wireless ? thank you.
>
> I guess you'll have to wait for John to merge Linus' tree.
>

sure, thanks!

-- 
thanks,
shafi
