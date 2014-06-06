Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:22984 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751237AbaFFGv5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Jun 2014 02:51:57 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Ben Greear <greearb@candelatech.com>
CC: Emmanuel Grumbach <egrumbach@gmail.com>,
	ath10k <ath10k@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Firmware debugging patches?
References: <53891ACD.7070902@candelatech.com>
	<87wqczz3h9.fsf@kamboji.qca.qualcomm.com>
	<538CA904.4000508@candelatech.com>
	<87ioojz1b1.fsf@kamboji.qca.qualcomm.com>
	<538CB782.1000509@candelatech.com> <538CC68C.10808@gmail.com>
	<538CC949.5020901@candelatech.com>
	<CANUX_P2vbKD3zkwE=DvJJWpo=gEMORCBy=XFoC2YSFpmg9sr_A@mail.gmail.com>
	<538CD507.1050803@candelatech.com>
	<87bnu7pqe2.fsf@kamboji.qca.qualcomm.com>
	<53909372.1040707@candelatech.com>
Date: Fri, 6 Jun 2014 09:51:52 +0300
In-Reply-To: <53909372.1040707@candelatech.com> (Ben Greear's message of "Thu,
	5 Jun 2014 08:57:38 -0700")
Message-ID: <87fvjimsxj.fsf@kamboji.qca.qualcomm.com> (sfid-20140606_085201_491391_65B8A2EC)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ben Greear <greearb@candelatech.com> writes:

>> Why do you want to put the crash dump in kernel log, can you describe
>> your "use case" here? For me it would be enough to have a UUID for each
>> crash dump and then have the driver print that to kernel log:
>> 
>> ath10k: firmware crashed (uuid 1234567890-4321)
>> 
>> And then you just need to find the correct dump from the file system and
>> start debugging. Would that be enough for you?
>
> Not all systems will have fancy user-space able to deal with this.
>
> At the very least, please leave in the current firmware crash
> dump text.

I'm not removing anything. That was just an example how we can identify
crashes.

-- 
Kalle Valo
