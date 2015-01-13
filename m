Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:28450 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751052AbbAMOsm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Jan 2015 09:48:42 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
CC: Michal Kazior <michal.kazior@tieto.com>,
	Sujith Manoharan <sujith@msujith.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Subject: Re: [PATCH] ath10k: Make HTT fill size configurable
References: <1420432796-10765-1-git-send-email-sujith@msujith.org>
	<CA+BoTQ=HqF0vBj4chXfoY9GKcFBP8Xh37HXo5etDDZ1XCg6O4w@mail.gmail.com>
	<54AD103B.40002@qti.qualcomm.com>
Date: Tue, 13 Jan 2015 16:48:29 +0200
In-Reply-To: <54AD103B.40002@qti.qualcomm.com> (Vasanthakumar Thiagarajan's
	message of "Wed, 7 Jan 2015 16:23:47 +0530")
Message-ID: <87vbka4tz6.fsf@kamboji.qca.qualcomm.com> (sfid-20150113_154846_151517_305FEFF5)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com> writes:

>>> This patch adds a module parameter to adjust the fill size
>>> based on the platform/usage.
>>
>> I don't think this should be adjustable.
>
> Default value of 16 causes rx ring corruption within 1 hour of stress
> testing. Increasing this limit to 1000 solves the issue, not sure what
> max value in > 16 and <= 1000 works.

Does the patch below fix that issue? Or is this issue still open?

5de6dfc82f71 ath10k: Fix potential Rx ring corruption

-- 
Kalle Valo
