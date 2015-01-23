Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:43555 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751990AbbAWTay convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jan 2015 14:30:54 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: =?utf-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: Re: [PATCH V2] bcma: clean bus initialization code
References: <1421435929-21499-1-git-send-email-zajec5@gmail.com>
	<1421438379-26211-1-git-send-email-zajec5@gmail.com>
	<87h9vhl743.fsf@kamboji.qca.qualcomm.com>
	<CACna6ryPpezpP2YUAC02omReuMHagAT2G9rEwh_NYpaOQK8uJA@mail.gmail.com>
Date: Fri, 23 Jan 2015 21:30:48 +0200
In-Reply-To: <CACna6ryPpezpP2YUAC02omReuMHagAT2G9rEwh_NYpaOQK8uJA@mail.gmail.com>
	(=?utf-8?Q?=22Rafa=C5=82_Mi=C5=82ecki=22's?= message of "Fri, 23 Jan 2015
 20:16:56 +0100")
Message-ID: <87zj99jnvb.fsf@kamboji.qca.qualcomm.com> (sfid-20150123_203057_994716_35521815)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rafał Miłecki <zajec5@gmail.com> writes:

> On 23 January 2015 at 18:49, Kalle Valo <kvalo@codeaurora.org> wrote:
>> Rafał Miłecki <zajec5@gmail.com> writes:
>>
>>> This moves main bus init code to the main.c and renames old function to
>>> make its purpose clear.
>>> Thanks to this change we'll also be able to separate scanning from
>>> registration (and support PCIe Gen 2 devices) in the future.
>>>
>>> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
>>> ---
>>> V2: Fix typo (s/initialiation/initialization/)
>>>     Put bcma_detect_chip earlier in .h to match order in .c
>>
>> Thanks, applied to wireless-drivers-next.git. But to avoid any UTF-8
>> problems I applied this one manually from email. 'git log' and gitk look
>> good to me, but please do check still that the log is valid.
>
> Looks great, thanks.

Thanks for checking.

> I hope kernel.org team will upgrade patchwork soon so I can send more
> patches :|

It might take some time, they (or is it just one person?) seem to be
quite busy. Just continue sending patches and I'll apply them manually.
Luckily you seem to be the only one using non-ascii characters.

-- 
Kalle Valo
