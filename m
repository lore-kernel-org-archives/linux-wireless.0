Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:44890 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752094AbbABNda (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Jan 2015 08:33:30 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Sujith Manoharan <sujith@msujith.org>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: Enable RX batching
References: <1419834084-11859-1-git-send-email-sujith@msujith.org>
	<87fvbt62x9.fsf@kamboji.qca.qualcomm.com>
	<21670.22986.926659.849716@gargle.gargle.HOWL>
	<87bnmh5zyh.fsf@kamboji.qca.qualcomm.com>
	<21670.30281.688316.623369@gargle.gargle.HOWL>
Date: Fri, 2 Jan 2015 15:33:20 +0200
In-Reply-To: <21670.30281.688316.623369@gargle.gargle.HOWL> (Sujith
	Manoharan's message of "Fri, 2 Jan 2015 16:13:21 +0530")
Message-ID: <874ms95mu7.fsf@kamboji.qca.qualcomm.com> (sfid-20150102_143507_720034_A0CA64B0)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sujith Manoharan <sujith@msujith.org> writes:

> Kalle Valo wrote:
>> > Along with the other patch and an internal fix,
>> > UDP RX increased to about 950 Mbps.
>> 
>> What was the number before?
>
> It was about 600 Mbps. Maybe slightly higher, but the CPU
> was maxed out by the torrent of tasklets trying to
> replenish HTT buffers.

Wow, that's a huge improvement.

-- 
Kalle Valo
