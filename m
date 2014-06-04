Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:53721 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750925AbaFDT3H (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Jun 2014 15:29:07 -0400
Message-ID: <538F7381.4070100@candelatech.com> (sfid-20140604_212911_677300_33CF3829)
Date: Wed, 04 Jun 2014 12:29:05 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Emmanuel Grumbach <egrumbach@gmail.com>
CC: Kalle Valo <kvalo@qca.qualcomm.com>,
	ath10k <ath10k@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Firmware debugging patches?
References: <53891ACD.7070902@candelatech.com> <87wqczz3h9.fsf@kamboji.qca.qualcomm.com> <538CA904.4000508@candelatech.com> <87ioojz1b1.fsf@kamboji.qca.qualcomm.com> <538CB782.1000509@candelatech.com> <538CC68C.10808@gmail.com> <538CC949.5020901@candelatech.com> <CANUX_P2vbKD3zkwE=DvJJWpo=gEMORCBy=XFoC2YSFpmg9sr_A@mail.gmail.com> <538CD507.1050803@candelatech.com> <CANUX_P1iaTtFccraAF_p1dFZ3SJFpdNfF=i=eAVXP8yM3GrM4A@mail.gmail.com>
In-Reply-To: <CANUX_P1iaTtFccraAF_p1dFZ3SJFpdNfF=i=eAVXP8yM3GrM4A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/04/2014 12:23 PM, Emmanuel Grumbach wrote:

>> Do you have a link to your patch that defines the types you used?
>>
> 
> Take a look at 1bd3cbc1a0e9ed977a6bd470c5bc7bd36fd87e26.
> But I am adding more and more content to this file.

Yeah, after implementing it in ath10k it seems there would
be very little over-lap, so probably each driver should just
do their own.

We can keep the debugfs file names the same, and the udev
event types the same, which should help user-space a bit.


>> It does not resolve my interest in firmware logs interleaved with
>> kernel logs and possibly supplicant, however.
>>
>> Looks like trace-cmds could do that, but it will not be
>> running for normal users when they experience crashes.
>>
>> Any suggestions other than printk for this feature?
> 
> I seems you found a way already :)

I can get firmware logs, but they are not interleaved.
Probably good enough for now..and we can always add
printk or similar in the future if we all decide it's
useful.

Being able to look at your iwlwifi work made my patches lot easier,
so thanks for taking the initiative!

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

