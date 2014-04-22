Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.redpinesignals.com ([203.196.161.92]:54299 "EHLO
	mail.redpinesignals.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750860AbaDVGlQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Apr 2014 02:41:16 -0400
Message-ID: <53560E9A.6020105@redpinesignals.com> (sfid-20140422_084121_292965_6E54AEC6)
Date: Tue, 22 Apr 2014 12:09:22 +0530
From: Sowjanya <sowjanya.t@redpinesignals.com>
MIME-Version: 1.0
To: John Tobias <john.tobias.ph@gmail.com>
CC: Ben Greear <greearb@candelatech.com>,
	linux-wireless@vger.kernel.org
Subject: Re: Testing WMM
References: <CACUGKYPP9s1cSJEpuBfQxT9=xLY57t0-kLZ8D=X2gaVcXbC2Nw@mail.gmail.com> <53553C69.8090307@candelatech.com>
In-Reply-To: <53553C69.8090307@candelatech.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

  Hello John,

     You can use Ixia chariot to send traffic (RTP/UDP/TCP type) for 
different access categories.
Also you can use iperf to send traffic with different tos.

Thanks
Sowjanya.

On 04/21/2014 09:12 PM, Ben Greear wrote:
> On 04/18/2014 04:51 PM, John Tobias wrote:
>> Hello Guys,
>>
>> I would like to test the following WMM features of the wifi driver.
>>
>> wmm_ac_vo
>> wmm_ac_vi
>> wmm_ac_be
>> wmm_ac_bk
>>
>> What tools did you use to test it?.
> Use user-space app that can set IP ToS.  The OS/driver should put the
> packets in the appropriate wmm queue.  Ensure that higher priority traffic
> actually gets higher priority when over-driving each queue.
>
> Thanks,
> Ben
>
>> Regards,
>>
>> john
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>

