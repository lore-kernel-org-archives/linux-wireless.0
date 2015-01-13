Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:42221 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751318AbbAMOoz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Jan 2015 09:44:55 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Sujith Manoharan <sujith@msujith.org>
CC: Michal Kazior <michal.kazior@tieto.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Subject: Re: [PATCH] ath10k: Make HTT fill size configurable
References: <1420432796-10765-1-git-send-email-sujith@msujith.org>
	<CA+BoTQ=HqF0vBj4chXfoY9GKcFBP8Xh37HXo5etDDZ1XCg6O4w@mail.gmail.com>
	<21677.3195.451116.244389@gargle.gargle.HOWL>
Date: Tue, 13 Jan 2015 16:44:42 +0200
In-Reply-To: <21677.3195.451116.244389@gargle.gargle.HOWL> (Sujith Manoharan's
	message of "Wed, 7 Jan 2015 16:07:47 +0530")
Message-ID: <87zj9m4u5h.fsf@kamboji.qca.qualcomm.com> (sfid-20150113_154506_360943_B676E70D)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sujith Manoharan <sujith@msujith.org> writes:

>> I have a patch internally which removes the replenishment tasklet and
>> I wonder how will it behave with rx batching then, hmm..
>
> I tried that earlier and could see only marginal improvement. The biggest
> increase came when I replaced netif_receive_skb() with netif_rx()
> in mac80211/rx.c.

Any ideas why that increases throughput?

-- 
Kalle Valo
