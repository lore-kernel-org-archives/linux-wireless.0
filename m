Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:58925 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754063AbbCLOCq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Mar 2015 10:02:46 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Oleksij Rempel <linux@rempel-privat.de>
Cc: Adrian Chadd <adrian@freebsd.org>,
	"linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	ath9k-devel <ath9k-devel@lists.ath9k.org>
Subject: Re: [PATCH] ath9k_htc: force FW v1.4.0
References: <1425929918-860-1-git-send-email-linux@rempel-privat.de>
	<87385dz2yx.fsf@kamboji.qca.qualcomm.com>
	<CAJ-Vmon6j71Eurbe7Sg2ZB06hbOymVYSge_-LeUKCXRDmLE5mw@mail.gmail.com>
	<54FF5431.3020708@rempel-privat.de>
Date: Thu, 12 Mar 2015 16:02:39 +0200
In-Reply-To: <54FF5431.3020708@rempel-privat.de> (Oleksij Rempel's message of
	"Tue, 10 Mar 2015 21:29:37 +0100")
Message-ID: <87bnjytitc.fsf@kamboji.qca.qualcomm.com> (sfid-20150312_150250_736379_6D60012C)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Oleksij Rempel <linux@rempel-privat.de> writes:

> Am 10.03.2015 um 16:35 schrieb Adrian Chadd:
>> Yeah, let's have it warn for a month or two.
>> 
>> There's some pending work that will break the API with 1.3 firmware,
>> so it has to happen sooner rather than later. But yeah, maybe warn for
>> about a month would be good. the older firmware is still in the git
>> tree in case people want it.
>
> I'm not sure if warning patch will do the trick.
> Let me resend this patch in one or two months. Are you ok with it?
> Like Adrian said, there are pending patches (since 2013) which will
> brake compatibility with 1.3

Yeah, that's better. The crystall ball[1] says that 4.2 will be released
in August, that should be plenty of time for user space to catch up. So
if you resend this end of April or so the patch should go to 4.2.

[1] http://phb-crystal-ball.org/

-- 
Kalle Valo
