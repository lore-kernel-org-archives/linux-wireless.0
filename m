Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:48097 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752065AbcHAIzy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Aug 2016 04:55:54 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: "russianneuromancer\@ya.ru" <russianneuromancer@ya.ru>
Cc: linux-wireless@vger.kernel.org, ath6kl@lists.infradead.org
Subject: Re: Dell Venue 8 Pro "Dell Wireless" (Atheros 6k) chipset with SDIO ID 0271:0418 not recognized/supported
References: <14140188.nOOhQX7Q2z@laptop1> <87bn1e88r4.fsf@purkki.adurom.net>
	<12631469979153@web27h.yandex.ru>
Date: Mon, 01 Aug 2016 11:55:48 +0300
In-Reply-To: <12631469979153@web27h.yandex.ru> (russianneuromancer@ya.ru's
	message of "Sun, 31 Jul 2016 23:32:33 +0800")
Message-ID: <87oa5c98bv.fsf@kamboji.qca.qualcomm.com> (sfid-20160801_105557_414541_0A93E996)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

please don't reply to me privately. Let's keep the discussion on the
lists so that others can join and learn.

"russianneuromancer@ya.ru" <russianneuromancer@ya.ru> writes:

>> That looks good to me, but please submit it officially as defined in
>> the wiki
>
> Just to be sure I understand you right - I have to just send e-mail with
> attached file "support-Dell-OEM-chipset-found-in-Venue-8-Pro-SDIO-I.patch" - is
> that correct?

You should submit the patch following the general Linux patch submission
rules. If you are not familiar with that I recommend doing thorough
research before your first. And for the actual submission I strongly
recommend to use 'git send-email'. Also remember to make sure that all
legal requirements are fulfilled, especially Signed-off-by tags.

Oh, and you have to use your real legal name. I can't take patches from
pseudonyms.

Here are few pointers:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
https://www.kernel.org/doc/Documentation/SubmittingPatches
https://kernelnewbies.org/FirstKernelPatch

-- 
Kalle Valo
