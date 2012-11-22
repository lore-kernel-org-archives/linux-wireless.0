Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:53848 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755411Ab2KVSla (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Nov 2012 13:41:30 -0500
From: Kalle Valo <kvalo@adurom.com>
To: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	qca_vkondrat <qca_vkondrat@qca.qualcomm.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH v8 2/4] wireless: allow Atheros card to not depend on ath.ko
References: <1352978222-13866-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
	<1352978222-13866-3-git-send-email-qca_vkondrat@qca.qualcomm.com>
	<8206721.qz6ygglX4j@lx-vladimir> <87txsjvwdw.fsf@purkki.adurom.net>
	<CAB=NE6XP83QVZ8Vv1R247HLW3ep_quQ8yP9STKT5L_jMrpxUOA@mail.gmail.com>
Date: Thu, 22 Nov 2012 09:08:48 +0200
In-Reply-To: <CAB=NE6XP83QVZ8Vv1R247HLW3ep_quQ8yP9STKT5L_jMrpxUOA@mail.gmail.com>
	(Luis R. Rodriguez's message of "Wed, 21 Nov 2012 07:10:44 -0800")
Message-ID: <87mwyaw1vj.fsf@purkki.adurom.net> (sfid-20121122_194137_397701_517C83C6)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Luis R. Rodriguez" <rodrigue@qca.qualcomm.com> writes:

>> > As was discussed, I prepared this patch that address Kconfig issue for the
>> > Atheros wifi cards.
>> >
>> > Any opinions on this?
>>
>> Looks good to me, but I didn't check that carefully...
>>
>> Actually I think ath6kl can make use of this as well, it shouldn't
>> depend anything from ath.ko.
>
> Indeed it should.

-ECONFUSED :)

Do you mean that ath6kl should or should not depend on ath.ko?

-- 
Kalle Valo
