Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:57115 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751009AbcGMQbz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jul 2016 12:31:55 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Cathy Luo" <cluo@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>
Subject: Re: [PATCH v3 1/2] mwifiex: add manufacturing mode support
References: <1468417703-32716-1-git-send-email-akarwar@marvell.com>
	<87twfta66k.fsf@purkki.adurom.net>
	<2dcba20e490840918e80c4f91a250739@SC-EXCH04.marvell.com>
Date: Wed, 13 Jul 2016 19:31:02 +0300
In-Reply-To: <2dcba20e490840918e80c4f91a250739@SC-EXCH04.marvell.com>
	(Amitkumar Karwar's message of "Wed, 13 Jul 2016 15:57:15 +0000")
Message-ID: <87eg6xzeih.fsf@kamboji.qca.qualcomm.com> (sfid-20160713_183359_780400_9EB2652D)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Amitkumar Karwar <akarwar@marvell.com> writes:

> Hi Kalle,
>
>> -----Original Message-----
>> From: Kalle Valo [mailto:kvalo@codeaurora.org]
>> Sent: Wednesday, July 13, 2016 9:20 PM
>> To: Amitkumar Karwar
>> Cc: linux-wireless@vger.kernel.org; Cathy Luo; Nishant Sarmukadam
>> Subject: Re: [PATCH v3 1/2] mwifiex: add manufacturing mode support
>> 
>> Amitkumar Karwar <akarwar@marvell.com> writes:
>> 
>> > By default normal mode is chosen when driver is loaded. This patch
>> > adds a provision to choose manufacturing mode via module parameters.
>> >
>> > Command to load driver in manufacturing mode insmod mwifiex.ko
>> > mfg_mode=1 and mfg_firmware=mrvl/firmware.
>> >
>> > Tested-by: chunfan chen <jeffc@marvell.com>
>> > Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
>> 
>> Why the mfg_firmware module parameter?
>
> It's to specify a firmware name.

Yeah, I got that. But why do you need that? Why not just hardcode the
firmware name in the driver, which is the normal thing to do?

-- 
Kalle Valo
