Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qc0-f179.google.com ([209.85.216.179]:64018 "EHLO
	mail-qc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756545Ab3A0V7t convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Jan 2013 16:59:49 -0500
Received: by mail-qc0-f179.google.com with SMTP id b40so1007610qcq.24
        for <linux-wireless@vger.kernel.org>; Sun, 27 Jan 2013 13:59:48 -0800 (PST)
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <5643712.YXEVgUjzFG@zarzych>
References: <2709103.3nEV2q8lKr@zarzych>
	<97097679.G4cU4YgE3z@zarzych>
	<CA+icZUWfjE4CWU9k9DRyQhDxB1MbgaL5WfR_B=viTLKWN5YCxg@mail.gmail.com>
	<5643712.YXEVgUjzFG@zarzych>
Date: Sun, 27 Jan 2013 22:59:48 +0100
Message-ID: <CA+icZUX8u3_7EVWN7sJR5kCk=LgZvNjhuLmn=aFkm7akcmpBKA@mail.gmail.com> (sfid-20130127_225955_308336_4AE8000B)
Subject: Re: Possible bug in iwlwifi
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Maciek Zarzycki <zarzych@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jan 27, 2013 at 10:49 PM, Maciek Zarzycki <zarzych@gmail.com> wrote:
> On Sunday 27 of January 2013 22:25:16 Sedat Dilek wrote:
>
>> I can't say much to the call-traces, but in general you should add
>> your kernel-config and dmesg at least.
>> An 'lspci -nnvv' (or lsusb) wouldn't hurt, too.
>>
>> Check <wireless.kernel.org> on how to debug iwlwifi driver
>> (documentation websites).
>>
>> If you are fit in kernel-building you can try the pending patches in
>> Greg's linux-stable GIT [2].
>> Before that I would try the pending patch from iwlwifi-fixes GIT [1],
>> it's for 3.7-stable as well.
>>
>> Can you try and report?
>>
>> Regards,
>> - Sedat -
>>
>> P.S.: IIRC iwlwifi folks have an own mailing-list?
>
> Thanks for your answer. The iwlwifi page mentions this mailing list for bug reports.
>
> I'm using arch kernel. I'll compile a vanilla kernel tomorrow and also check it with the two sets of patches that you mentioned and report back. I've also just stumbled upon docs on how to report wireless related bugs. Sorry for not following them with my first email.
>

For quick testing of patches I would suggest you to do a
localmodconfig-ed kernel-setup.
Here on a Intel sandybridge CPU it's approx. 10-12min with 'make -j4'.

- Sedat -

[1] http://www.h-online.com/open/features/Good-and-quick-kernel-configuration-creation-1403046.html

> --
> Maciek Zarzycki
