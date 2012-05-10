Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:33114 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755449Ab2EJKPD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2012 06:15:03 -0400
From: Kalle Valo <kvalo@adurom.com>
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org, Luciano Coelho <coelho@ti.com>
Subject: Re: [PATCH 00/78] 18xx chip support
References: <1336641263-5761-1-git-send-email-arik@wizery.com>
	<87ipg48ivh.fsf@purkki.adurom.net>
	<CA+XVXfcFx3ZDiPrwmDHbVbHs=_V0wsJasNvXAE9XrPodr_xVTg@mail.gmail.com>
Date: Thu, 10 May 2012 13:15:01 +0300
In-Reply-To: <CA+XVXfcFx3ZDiPrwmDHbVbHs=_V0wsJasNvXAE9XrPodr_xVTg@mail.gmail.com>
	(Arik Nemtsov's message of "Thu, 10 May 2012 13:11:58 +0300")
Message-ID: <87ehqs8hqy.fsf@purkki.adurom.net> (sfid-20120510_121507_565337_1B69BC26)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arik Nemtsov <arik@wizery.com> writes:

> On Thu, May 10, 2012 at 12:50 PM, Kalle Valo <kvalo@adurom.com> wrote:
>> Arik Nemtsov <arik@wizery.com> writes:
>>
>>> This series adds initial support for the 18xx chip family. The new
>>> module uses wlcore for functionality common with the 12xx family.
>>
>> You do know that sending 78 patches in one patchset is very much
>> frowned upon? No sane person (outside of wl12xx) is going to review
>> all of these.
>
> Yea I don't like it as well, but it took this amount of patches to get
> the card up and running. Posting some skeleton code seems kind of
> useless.

You can always submit patches in smaller (10-15 patches) chunks.

-- 
Kalle Valo
