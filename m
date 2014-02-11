Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:26183 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750969AbaBKMv7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Feb 2014 07:51:59 -0500
Message-ID: <52FA1CE7.7040909@broadcom.com> (sfid-20140211_135202_636369_4500FD78)
Date: Tue, 11 Feb 2014 13:51:51 +0100
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Ben Greear <greearb@candelatech.com>,
	Zhao Hongjiang <zhaohongjiang@huawei.com>
CC: <johannes@sipsolutions.net>, <linux-wireless@vger.kernel.org>,
	<zhousiyi@huawei.com>
Subject: Re: Get multiple ip addresses by dhcp for wireless card
References: <52F84DFD.4030602@huawei.com> <52F87608.808@candelatech.com> <52F88FEA.3000102@huawei.com> <52F92696.3030003@candelatech.com> <52F99ED7.3090304@huawei.com> <52F99FB8.8080001@candelatech.com>
In-Reply-To: <52F99FB8.8080001@candelatech.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/11/2014 04:57 AM, Ben Greear wrote:
> On 02/10/2014 07:53 PM, Zhao Hongjiang wrote:
> 
>>> What driver are you using?  I'm not sure anything other than ath9k
>>> can do this feature.  Ath5k probably works, and definitely worked
>>> at one time.  Ath10k supports this to some degree, and will have more
>>> support in the future.
>>>
>>> You typically have to disable hardware crypt to make this work.
>>>
>> I use bcm4329 chipset and it don't have "Disable HW encryption" options.
>> any suggestion for this is appreciated, thanks very much.
> 
> I doubt that chipset is going to support multiple stations.

It definitely does not.

Gr. AvS

> Use ath9k and you should have more success.
> 
> Thanks,
> Ben
> 
>>
>>> Thanks,
>>> Ben
>>>
>>
> 
> 

