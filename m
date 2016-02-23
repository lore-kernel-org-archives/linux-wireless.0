Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:47089 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751059AbcBWO6O (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Feb 2016 09:58:14 -0500
Message-ID: <56CC7385.5050004@candelatech.com> (sfid-20160223_155817_797301_C3663E97)
Date: Tue, 23 Feb 2016 06:58:13 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
CC: Jouni Malinen <j@w1.fi>
Subject: Re: [PATCH] mac80211:  Let VHT work on 2.4Ghz
References: <1456180974-21062-1-git-send-email-greearb@candelatech.com>	 <1456236627.9910.10.camel@sipsolutions.net>	 <56CC6A35.5000900@candelatech.com> <1456237373.9910.18.camel@sipsolutions.net>
In-Reply-To: <1456237373.9910.18.camel@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 02/23/2016 06:22 AM, Johannes Berg wrote:
> On Tue, 2016-02-23 at 06:18 -0800, Ben Greear wrote:
>
>> [root@ben-ota2 lanforge]# iw phy wiphy0 info
>> Wiphy wiphy0
>>
>> 	Band 1:
> [...]
>> 		VHT Capabilities (0x338001b2):
>> 			Max MPDU length: 11454
>> 			Supported Channel Width: neither 160 nor 80+80
>> 			RX LDPC
>> 			short GI (80 MHz)
>> 			TX STBC
>> 			RX antenna pattern consistency
>> 			TX antenna pattern consistency
>> 		VHT RX MCS set:
>> 			1 streams: MCS 0-9
>> 			2 streams: MCS 0-9
>> 			3 streams: MCS 0-9
>> 			4 streams: not supported
>> 			5 streams: not supported
>> 			6 streams: not supported
>> 			7 streams: not supported
>> 			8 streams: not supported
>> 		VHT RX highest supported: 0 Mbps
>> 		VHT TX MCS set:
>> 			1 streams: MCS 0-9
>> 			2 streams: MCS 0-9
>> 			3 streams: MCS 0-9
>> 			4 streams: not supported
>> 			5 streams: not supported
>> 			6 streams: not supported
>> 			7 streams: not supported
>> 			8 streams: not supported
>> 		VHT TX highest supported: 0 Mbps
>
>> 		Frequencies:
>> 			* 2412 MHz [1] (30.0 dBm)
>>
> [...]
>
> Oops. Well, the driver isn't supposed to do that, this is certainly
> non-spec behaviour.

Is there any harm though?  There is at least one other AP manufacturer
that really wants to test this feature, so I guess there will be products
on the market soon enough that support VHT in 2.4Ghz band.

Some day soon-ish, we'll benchmark this in an isolation chamber & over-the-air to see
how it actually performs.

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
