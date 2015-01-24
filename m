Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f43.google.com ([74.125.82.43]:61881 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751561AbbAXKoG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 Jan 2015 05:44:06 -0500
Received: by mail-wg0-f43.google.com with SMTP id y19so1632958wgg.2
        for <linux-wireless@vger.kernel.org>; Sat, 24 Jan 2015 02:44:04 -0800 (PST)
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <54C37635.6010708@rempel-privat.de>
References: <1422094745-12718-1-git-send-email-hong@topbug.net>
	<87k30ciiir.fsf@kamboji.qca.qualcomm.com>
	<CA+icZUVq-bhryv=Aj7JuCzFU6kTQEh+jiwBR_bnJzNnjJ2Kg-A@mail.gmail.com>
	<54C37635.6010708@rempel-privat.de>
Date: Sat, 24 Jan 2015 11:44:04 +0100
Message-ID: <CA+icZUWb8s2=9wf6Uzi4XX+mfEVZSDT4=2XS_ppJa2rtd0CJZA@mail.gmail.com> (sfid-20150124_114413_094273_CB8A16D2)
Subject: Re: [PATCH] ath9k and ath9k_htc: rename variable "led_blink"
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Oleksij Rempel <linux@rempel-privat.de>
Cc: Kalle Valo <kvalo@codeaurora.org>, Hong Xu <hong@topbug.net>,
	wireless <linux-wireless@vger.kernel.org>,
	ath9k-devel@lists.ath9k.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jan 24, 2015 at 11:38 AM, Oleksij Rempel <linux@rempel-privat.de> wrote:
> Am 24.01.2015 um 11:33 schrieb Sedat Dilek:
>> On Sat, Jan 24, 2015 at 11:23 AM, Kalle Valo <kvalo@codeaurora.org> wrote:
>>> Hong Xu <hong@topbug.net> writes:
>>>
>>>> ath9k and ath9k_htc use the variable name "led_blink" to indicate
>>>> whether the module parameter "blink" is on. This name is easy to
>>>> conflict with other variables, thus they are renamed.
>>>
>>> Please state clearly that this fixes a compiler error found by kbuild.
>>> Also it's very much recommended to add the actual compiler error to the
>>> commit log:
>>>
>>> drivers/net/wireless/ath/ath9k/ath9k_htc.o:(.data+0x47c): multiple definition of `led_blink'
>>> drivers/net/wireless/ath/ath9k/ath9k.o:(.bss+0x20): first defined here
>>>
>>
>> Some more things...
>>
>> If you post a vN (referring to your v3) of a patch, please add a
>> history of changes.
>
> What kind of history do you wont to have here? Kernel log should not be
> overloaded with patch preparation history.
>

Not here.
Referring to "[PATCH v3] ath9k_htc: Add a module parameter to disable blink".

And no, the history of changes are 1. important 2. not in the
"commit-body", so you will not see them when the patch is pushed to
the appropriate Git tree.

- Sedat -
