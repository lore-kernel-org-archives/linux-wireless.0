Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:39464 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756865Ab2EJKZd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2012 06:25:33 -0400
Received: by bkcji2 with SMTP id ji2so1114609bkc.19
        for <linux-wireless@vger.kernel.org>; Thu, 10 May 2012 03:25:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87ehqs8hqy.fsf@purkki.adurom.net>
References: <1336641263-5761-1-git-send-email-arik@wizery.com>
 <87ipg48ivh.fsf@purkki.adurom.net> <CA+XVXfcFx3ZDiPrwmDHbVbHs=_V0wsJasNvXAE9XrPodr_xVTg@mail.gmail.com>
 <87ehqs8hqy.fsf@purkki.adurom.net>
From: Arik Nemtsov <arik@wizery.com>
Date: Thu, 10 May 2012 13:25:16 +0300
Message-ID: <CA+XVXffbZ03ANuagfnYQow6y4L07gVb=wP3SDTWKsnF5RDKnZw@mail.gmail.com> (sfid-20120510_122535_476025_225D4916)
Subject: Re: [PATCH 00/78] 18xx chip support
To: Kalle Valo <kvalo@adurom.com>
Cc: linux-wireless@vger.kernel.org, Luciano Coelho <coelho@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 10, 2012 at 1:15 PM, Kalle Valo <kvalo@adurom.com> wrote:
> Arik Nemtsov <arik@wizery.com> writes:
>
>> On Thu, May 10, 2012 at 12:50 PM, Kalle Valo <kvalo@adurom.com> wrote:
>>> Arik Nemtsov <arik@wizery.com> writes:
>>>
>>>> This series adds initial support for the 18xx chip family. The new
>>>> module uses wlcore for functionality common with the 12xx family.
>>>
>>> You do know that sending 78 patches in one patchset is very much
>>> frowned upon? No sane person (outside of wl12xx) is going to review
>>> all of these.
>>
>> Yea I don't like it as well, but it took this amount of patches to get
>> the card up and running. Posting some skeleton code seems kind of
>> useless.
>
> You can always submit patches in smaller (10-15 patches) chunks.

We'll try to better split stuff in the future.

Arik
