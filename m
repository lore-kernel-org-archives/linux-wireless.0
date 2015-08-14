Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:48991 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755574AbbHNP5c (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Aug 2015 11:57:32 -0400
Message-ID: <55CE0FEB.7080303@candelatech.com> (sfid-20150814_175741_246652_E96917D9)
Date: Fri, 14 Aug 2015 08:57:31 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: S Prasad Kandregula <sprasad.kandregula@gmail.com>
CC: Michal Kazior <michal.kazior@tieto.com>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Kalle Valo <kvalo@qca.qualcomm.com>
Subject: Re: Ath10 firmware crashing in Monitor mode(Sniffer mode)
References: <CAJa-X95EBdGASnz3KAdYz5R6w5g-a=dBy5VCZYwHp6SzQ+gUSw@mail.gmail.com> <CA+BoTQkFSQe0di1vqqB5cAPKaizRkBT5cu4fA8dQ_uR_a2HdJw@mail.gmail.com> <CAJa-X96spUg7+EZqH-Mv3s7OzbHzmXmcZ7uOw1KvPShexW6D_w@mail.gmail.com> <CA+BoTQ=Qpws=928TZe22Ds-UO_qQJ2Om+=DW=VUNUS59o1BQAA@mail.gmail.com> <CAJa-X96KPw6dY0pK1zc8UD4TdQcG0KuA3m6DSueVVyK-VPhn9g@mail.gmail.com> <CA+BoTQ=bqHPrdgGVfSfdJa5vobDBRdxRwMR_wJzUj4Z9WjotoQ@mail.gmail.com> <CAJa-X945Xvn0jHQVcKn-pyYQVNpxXnqjOH_VHJv8pVwR4kFXcw@mail.gmail.com> <CA+BoTQmLFGAn2z=E3J1C2qfNP34v57B7-rtALUQhNXrHqJeA6Q@mail.gmail.com> <55521102.9020306@candelatech.com> <CAJa-X97Av+FKwy5Q3x3jnC=KPmqFt_JfsaVQ6J3bScM-SEKnYg@mail.gmail.com> <55CD0176.5080003@candelatech.com> <4670C821-E536-47CF-BBC4-CC83F54BAE86@gmail.com>
In-Reply-To: <4670C821-E536-47CF-BBC4-CC83F54BAE86@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/13/2015 02:01 PM, S Prasad Kandregula wrote:
> Thank you Ben for immediate response,
> 
> Don't mind, could you please share your firmware path. 

Grab one of the beta-15 builds linked from this page:

http://www.candelatech.com/ath10k.php

If you want the mgt-htt version, be sure to patch your kernel per
the release notes or use one of my kernels also linked from the page.

Thanks,
Ben

> 
> Sorry I didn't change old subject line.
> 
> Thanks & Regards,
> S Prasad
> 
>> On Aug 13, 2015, at 4:43 PM, Ben Greear <greearb@candelatech.com> wrote:
>>
>>> On 08/13/2015 01:35 PM, s prasad wrote:
>>> Hi Ben,
>>>
>>> did you get a chance to look into this issue(injecting frames when
>>> device in monitor mode).
>>
>> Injection works in a limited fashion in my latest firmware.
>>
>> I'd like to figure out how to pass rate-ctrl (and other info?) down to the
>> firmware on a per-pkt basis..but I don't see a way yet.
>>
>> Probably I have to hack the htt header or something like that
>> to give some extra space.  That sort of thing might allow a host-based
>> rate-ctrl algorithm to be used....if someone is interested in working on
>> the driver/kernel side of things for this effort let me know.
>>
>> I am not aware of any crashes related to monitor mode in my
>> firmware..but if you can crash it, send me the crash dump and
>> I'll take a look.
>>
>> Thanks,
>> Ben
>>
>>
>> -- 
>> Ben Greear <greearb@candelatech.com>
>> Candela Technologies Inc  http://www.candelatech.com
>>
> 


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

