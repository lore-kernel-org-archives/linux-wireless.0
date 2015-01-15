Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:8764 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751045AbbAOIcr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Jan 2015 03:32:47 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Sujith Manoharan <sujith@msujith.org>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: Make HTT fill size configurable
References: <1420432796-10765-1-git-send-email-sujith@msujith.org>
	<87r3uy4t9y.fsf@kamboji.qca.qualcomm.com>
	<21685.35179.110539.780864@gargle.gargle.HOWL>
	<87bnm01ojf.fsf@kamboji.qca.qualcomm.com>
	<21687.29026.962216.812998@gargle.gargle.HOWL>
	<87vbk8zcr1.fsf@kamboji.qca.qualcomm.com>
	<21687.30578.746681.850817@gargle.gargle.HOWL>
Date: Thu, 15 Jan 2015 10:32:31 +0200
In-Reply-To: <21687.30578.746681.850817@gargle.gargle.HOWL> (Sujith
	Manoharan's message of "Thu, 15 Jan 2015 13:46:50 +0530")
Message-ID: <87mw5kzbog.fsf@kamboji.qca.qualcomm.com> (sfid-20150115_093250_893071_930B3331)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sujith Manoharan <sujith@msujith.org> writes:

> Kalle Valo wrote:
>> I STILL don't know what values you think people should use with
>> the htt_fill parameter.
>
> None. The default stays the same. But, it can be adjusted based
> on the platform, if higher throughput is desired.

Yeah, but everyone want higher throughput (including me). So what value
is best in your opinion?

-- 
Kalle Valo
