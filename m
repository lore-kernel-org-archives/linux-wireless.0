Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:45277 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752186AbaBKD6C (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Feb 2014 22:58:02 -0500
Message-ID: <52F99FB8.8080001@candelatech.com> (sfid-20140211_045806_749054_7E904EBF)
Date: Mon, 10 Feb 2014 19:57:44 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Zhao Hongjiang <zhaohongjiang@huawei.com>
CC: johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
	zhousiyi@huawei.com
Subject: Re: Get multiple ip addresses by dhcp for wireless card
References: <52F84DFD.4030602@huawei.com> <52F87608.808@candelatech.com> <52F88FEA.3000102@huawei.com> <52F92696.3030003@candelatech.com> <52F99ED7.3090304@huawei.com>
In-Reply-To: <52F99ED7.3090304@huawei.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/10/2014 07:53 PM, Zhao Hongjiang wrote:

>> What driver are you using?  I'm not sure anything other than ath9k
>> can do this feature.  Ath5k probably works, and definitely worked
>> at one time.  Ath10k supports this to some degree, and will have more
>> support in the future.
>>
>> You typically have to disable hardware crypt to make this work.
>>
> I use bcm4329 chipset and it don't have "Disable HW encryption" options.
> any suggestion for this is appreciated, thanks very much.

I doubt that chipset is going to support multiple stations.

Use ath9k and you should have more success.

Thanks,
Ben

>
>> Thanks,
>> Ben
>>
>


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

