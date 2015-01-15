Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:25554 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751465AbbAOIfP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Jan 2015 03:35:15 -0500
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
	<21687.30881.260644.741211@gargle.gargle.HOWL>
Date: Thu, 15 Jan 2015 10:35:02 +0200
In-Reply-To: <21687.30881.260644.741211@gargle.gargle.HOWL> (Sujith
	Manoharan's message of "Thu, 15 Jan 2015 13:51:53 +0530")
Message-ID: <87iog8zbk9.fsf@kamboji.qca.qualcomm.com> (sfid-20150115_093521_683090_489EE400)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sujith Manoharan <sujith@msujith.org> writes:

> Sujith Manoharan wrote:
>> None. The default stays the same. But, it can be adjusted based
>> on the platform, if higher throughput is desired.
>
> But, anyway, this patch can be dropped. We'll change the fill level
> restriction internally, based on the customer's platform.

I'm sad to hear that, now others cannot benefit from your work.

What was wrong with my proposal? Would it help if I write an RFC patch?
Just tell me what HTT fill value I should use.

-- 
Kalle Valo
