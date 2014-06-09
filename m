Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:61169 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932279AbaFIIeC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jun 2014 04:34:02 -0400
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
	<87fvjimsxj.fsf@kamboji.qca.qualcomm.com>
	<5391E620.4090706@candelatech.com>
	<87vbscj2ho.fsf@kamboji.qca.qualcomm.com>
	<53932F52.2030203@candelatech.com>
	<8738ffiysv.fsf@kamboji.qca.qualcomm.com>
	<539483B1.5020401@candelatech.com>
Date: Mon, 9 Jun 2014 11:17:03 +0300
In-Reply-To: <539483B1.5020401@candelatech.com> (Ben Greear's message of "Sun,
	8 Jun 2014 08:39:29 -0700")
Message-ID: <87ppiih4zk.fsf@kamboji.qca.qualcomm.com> (sfid-20140609_103408_122905_C7C858E5)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ben Greear <greearb@candelatech.com> writes:

>>> With time-of-day, time-since-boot, and MAC, each dump should be unique.
>>
>> But I would like to easily match from kernel log that the crash dump
>> matches with log. uuid would provide that in a simple way (check that
>> the uuid in the log matches with the uuid in the dump). What's so bad
>> from using uuid?
>
> Just tell me how you want me to create the uuid and I'll do so.

As kbuild found some compilation problems, I think it would be easier if
I make the final changes to your patches and send that for review. Would
that be ok for you?

-- 
Kalle Valo
