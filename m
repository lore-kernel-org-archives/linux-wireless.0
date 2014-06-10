Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:42485 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752430AbaFJPGp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Jun 2014 11:06:45 -0400
Message-ID: <53971F04.6060109@candelatech.com> (sfid-20140610_170651_374641_16A85147)
Date: Tue, 10 Jun 2014 08:06:44 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	ath10k <ath10k@lists.infradead.org>,
	Emmanuel Grumbach <egrumbach@gmail.com>
Subject: Re: Firmware debugging patches?
References: <53891ACD.7070902@candelatech.com>	<87wqczz3h9.fsf@kamboji.qca.qualcomm.com>	<538CA904.4000508@candelatech.com>	<87ioojz1b1.fsf@kamboji.qca.qualcomm.com>	<538CB782.1000509@candelatech.com> <538CC68C.10808@gmail.com>	<538CC949.5020901@candelatech.com>	<CANUX_P2vbKD3zkwE=DvJJWpo=gEMORCBy=XFoC2YSFpmg9sr_A@mail.gmail.com>	<538CD507.1050803@candelatech.com>	<87bnu7pqe2.fsf@kamboji.qca.qualcomm.com>	<53909372.1040707@candelatech.com>	<87fvjimsxj.fsf@kamboji.qca.qualcomm.com>	<5391E620.4090706@candelatech.com>	<87vbscj2ho.fsf@kamboji.qca.qualcomm.com>	<53932F52.2030203@candelatech.com>	<8738ffiysv.fsf@kamboji.qca.qualcomm.com>	<539483B1.5020401@candelatech.com>	<87ppiih4zk.fsf@kamboji.qca.qualcomm.com>	<5395CE36.30407@candelatech.com> <5395D718.4090704@candelatech.com>	<5395E089.1000601@candelatech.com> <87fvjde1u0.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <87fvjde1u0.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 06/09/2014 11:05 PM, Kalle Valo wrote:
> Ben Greear <greearb@candelatech.com> writes:
>
>>>>> As kbuild found some compilation problems, I think it would be easier if
>>>>> I make the final changes to your patches and send that for review. Would
>>>>> that be ok for you?
>>>>
>>>> Yes, that would be great.
>>>
>>> In case it helps, let me post my latest patches...will get those up
>>> in an hour or two.
>>
>> Actually, I seem to have just forgotten everything over the weekend...the
>> v2 patches I posted last Friday are current with my own tree.  So,
>> if you can tweak them to your satisfaction, that should work fine for
>> me.
>
> Great, thanks. I'll try to send a new version today. If you could then
> review them carefully and test as well, that would be really good.

I'll update my decode tool to support this as soon as it is pushed to your
tree, and will put it into our development tree for testing.  I have some
more patches related to this that I can post after the current 4 make it
upstream...these patches dump BSS data areas and send uevent, etc.

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
