Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:18211 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932259AbcFCQdX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Jun 2016 12:33:23 -0400
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: Ben Greear <greearb@candelatech.com>
CC: Rajkumar Manoharan <rmanohar@codeaurora.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Manoharan, Rajkumar" <rmanohar@qti.qualcomm.com>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Subject: Re: [PATCH 2/2] ath10k: remove 10.1 firmware support
Date: Fri, 3 Jun 2016 16:33:16 +0000
Message-ID: <87oa7iut9x.fsf@kamboji.qca.qualcomm.com> (sfid-20160603_183327_103471_4A4E9620)
References: <20160603153328.11947-1-rmanohar@qti.qualcomm.com>
	<20160603153328.11947-2-rmanohar@qti.qualcomm.com>
	<5751A6D5.7080901@candelatech.com>
	<743182bcbd1efbdb576bcc51b0215300@codeaurora.org>
	<87shwuuuct.fsf@kamboji.qca.qualcomm.com>	<5751AE44.8050607@candelatech.com>
In-Reply-To: <5751AE44.8050607@candelatech.com> (Ben Greear's message of "Fri,
	3 Jun 2016 09:20:20 -0700")
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ben Greear <greearb@candelatech.com> writes:

>>> Is it possible to upgrade CT firmware to 10.2 WMI/HTT interfaces?
>>
>> That's a good idea. That shouldn't be too hard, right? I don't think HTT needs
>> any changes, but for WMI few commands and ids need to be changed.
>
> I was thinking the 10.2 mgt-over-htt API would be trouble-some to make work on
> 10.1 firmware.

Yeah, that would be harder. But I don't see Rajkumar removing support
for that (yet) or am I missing something?

-- 
Kalle Valo