Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:52414 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750740AbaAUFeO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Jan 2014 00:34:14 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: AP mode, set UAPSD params correctly
References: <1390234821-4405-1-git-send-email-janusz.dziedzic@tieto.com>
	<8738kilhbx.fsf@kamboji.qca.qualcomm.com>
	<CALhHN=pTEBd5P-weZSxSou3gQmb=wE4fAHTECU6oJ1PSMvfWoQ@mail.gmail.com>
Date: Tue, 21 Jan 2014 07:34:08 +0200
In-Reply-To: <CALhHN=pTEBd5P-weZSxSou3gQmb=wE4fAHTECU6oJ1PSMvfWoQ@mail.gmail.com>
	(Janusz Dziedzic's message of "Mon, 20 Jan 2014 19:48:44 +0100")
Message-ID: <87ppnlkien.fsf@kamboji.qca.qualcomm.com> (sfid-20140121_063417_693323_84631B36)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Janusz Dziedzic <janusz.dziedzic@tieto.com> writes:

> On 20 January 2014 17:59, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
>> Janusz Dziedzic <janusz.dziedzic@tieto.com> writes:
>>
>>> Move UAPSD params settings after peer assoc
>>> command. This is required to setup UAPSD
>>> params correctly.
>>>
>>> Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
>>
>> This is a pretty vague description. What is correct today can be totally
>> wrong tomorrow :)
>>
>> So I would prefer that you describe a bit more about this change. At
>> least describe the bug you are fixing (or mention the motivation behind
>> the change).
>
> ath10k handles UAPSD completly in the firmware.
> When works in AP mode we have to configure
> UAPSD params for each station. Without this
> patch we configure UAPSD params before we
> send peer assoc command to the FW, which was
> wrong. Next FW didn't know what should be trigger
> frame, couse UAPSD didn't work correctly in AP mode.
> To configure UAPSD params correctly we have to
> send them after peer assoc command.

This is much better. Can you send v2 with this description, please?

-- 
Kalle Valo
