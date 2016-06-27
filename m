Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:50605 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751385AbcF0ILv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jun 2016 04:11:51 -0400
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	ath9k-devel <ath9k-devel@qualcomm.com>,
	miaoqing pan <miaoqing@codeaurora.org>
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: Mirco Tischler <mt-ml@gmx.de>
Subject: Re: ath9k: fix GPIO mask for AR9462 and AR9565
Date: Mon, 27 Jun 2016 08:08:51 +0000
Message-ID: <87por3dpf2.fsf@kamboji.qca.qualcomm.com> (sfid-20160627_101157_778173_31852C1B)
References: <20160627072235.GB31166@frangipani>
In-Reply-To: <20160627072235.GB31166@frangipani> (Mirco Tischler's message of
	"Mon, 27 Jun 2016 09:22:35 +0200")
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mirco Tischler <mt-ml@gmx.de> writes:

>>Thanks, 1 patch applied to ath-current branch of ath.git:
>>
>>e024111f6946 ath9k: fix GPIO mask for AR9462 and AR9565
>
> I see this warning in 4.7-rc4. Could the fix please go into 4.7? if I
> understand correctly it is only queued for 4.8?

The patch is queued for 4.7 and the patch is in the net tree currently.
I'm expect it to reach Linus' tree during this week.

> Btw. I applied the patch and it does fix the problem :)

This is good to know, gives more confidence that the fix is correct.
Thanks for testing.

-- 
Kalle Valo