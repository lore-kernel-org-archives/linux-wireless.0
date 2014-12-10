Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:3647 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932354AbaLJTzs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Dec 2014 14:55:48 -0500
Message-ID: <5488A538.4000005@qca.qualcomm.com> (sfid-20141210_205551_178758_0287C7A5)
Date: Wed, 10 Dec 2014 11:55:36 -0800
From: Peter Oh <poh@qca.qualcomm.com>
MIME-Version: 1.0
To: Ben Greear <greearb@candelatech.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: unregister and remove frag_threshold callback
References: <1417799786-11391-1-git-send-email-poh@qca.qualcomm.com> <54827F30.8050005@candelatech.com> <548891FB.2060500@qca.qualcomm.com> <5488991A.9000604@candelatech.com>
In-Reply-To: <5488991A.9000604@candelatech.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On 12/10/2014 11:03 AM, Ben Greear wrote:
> On 12/10/2014 10:33 AM, poh wrote:
>> On 12/05/2014 07:59 PM, Ben Greear wrote:
>>>
>>> On 12/05/2014 09:16 AM, Peter Oh wrote:
>>>> Setting fragmentation threshold has not been supported by
>>>> any of firmware versions, hence unregister the callback and
>>>> remove the function.
>>> How hard is it to just fix the firmware instead?
>> It's due to hardware limitation such as lack of buffers/RAM size limitation, hence it's very hard from sw perspective.
> Out of curiosity, how much more RAM do you need?  I was able to squeeze somewhere around 80k out of the firmware
> in my quest to support 64 station vdevs....
I don't have exact number of memory since the answer is from our 
firmware team.
I assume it's not coming in near future to firmware.
> Thanks,
> Ben
>
Thanks,
Peter
