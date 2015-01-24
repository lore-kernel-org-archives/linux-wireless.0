Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f169.google.com ([74.125.82.169]:47707 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752937AbbAXKuz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 Jan 2015 05:50:55 -0500
Received: by mail-we0-f169.google.com with SMTP id u56so1663023wes.0
        for <linux-wireless@vger.kernel.org>; Sat, 24 Jan 2015 02:50:54 -0800 (PST)
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <87bnloiht4.fsf@kamboji.qca.qualcomm.com>
References: <1422094745-12718-1-git-send-email-hong@topbug.net>
	<87k30ciiir.fsf@kamboji.qca.qualcomm.com>
	<CA+icZUVq-bhryv=Aj7JuCzFU6kTQEh+jiwBR_bnJzNnjJ2Kg-A@mail.gmail.com>
	<87bnloiht4.fsf@kamboji.qca.qualcomm.com>
Date: Sat, 24 Jan 2015 11:50:54 +0100
Message-ID: <CA+icZUWmBnpb2K0_Eyoe6x7gwZUN7DpXhjf3X7kuV19WVFY8Hw@mail.gmail.com> (sfid-20150124_115058_568750_37E34D88)
Subject: Re: [PATCH] ath9k and ath9k_htc: rename variable "led_blink"
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Hong Xu <hong@topbug.net>,
	wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jan 24, 2015 at 11:39 AM, Kalle Valo <kvalo@codeaurora.org> wrote:
> (I'll drop ath9k-devel as someone from there seems to be spamming with
> vacation responses)
>
> Sedat Dilek <sedat.dilek@gmail.com> writes:
>
>> 2nd, use the Fixes tag [2] in this case with a reference to the
>> culprit commit [1].
>>
>> Fixes: 3a939a671225 ("ath9k_htc: Add a module parameter to disable blink")
>
> Good point. I just found a handy tip from SubmittingPatches, just add
> this to ~/.gitconfig:
>
>         [core]
>                 abbrev = 12
>         [pretty]
>                 fixes = Fixes: %h (\"%s\")
>
> And then you get the fixes line automatically formatted for whatever
> commit you want:
>
> $ git log --format=fixes | head -5
> Fixes: fa1270678ce4 ("ath10k: Enable the MCS8 and MCS9 at 2.4G band")
> Fixes: 296f98ed02dd ("ath10k: fix pmf for wmi-tlv on qca6174")
> Fixes: 3443aaf6f11d ("ath10k: remove sw encryption for pmf")
> Fixes: d541c931dc93 ("ath10k: disable irqs after fw crash")
> Fixes: 9f282daeedc9 ("ath10k: disable uapsd autotrigger")
>
> Yet another reason why git is so awesome.
>

/o\.
Thanks, I added a core and pretty tag to my ~/.gitconfig, espacially
the 12-digit thingie was a long standing todo :-).

Working with tig I have to check the tipps of Peter Hutterer in his
blog for my local ~/.tigrc again.
This got lost when changing to Ubuntu/precise.

- Sedat -
