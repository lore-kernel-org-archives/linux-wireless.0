Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:54816 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751674AbbAXKj0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 Jan 2015 05:39:26 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: sedat.dilek@gmail.com
Cc: Hong Xu <hong@topbug.net>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath9k and ath9k_htc: rename variable "led_blink"
References: <1422094745-12718-1-git-send-email-hong@topbug.net>
	<87k30ciiir.fsf@kamboji.qca.qualcomm.com>
	<CA+icZUVq-bhryv=Aj7JuCzFU6kTQEh+jiwBR_bnJzNnjJ2Kg-A@mail.gmail.com>
Date: Sat, 24 Jan 2015 12:39:19 +0200
In-Reply-To: <CA+icZUVq-bhryv=Aj7JuCzFU6kTQEh+jiwBR_bnJzNnjJ2Kg-A@mail.gmail.com>
	(Sedat Dilek's message of "Sat, 24 Jan 2015 11:33:48 +0100")
Message-ID: <87bnloiht4.fsf@kamboji.qca.qualcomm.com> (sfid-20150124_113934_851111_79417476)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

(I'll drop ath9k-devel as someone from there seems to be spamming with
vacation responses)

Sedat Dilek <sedat.dilek@gmail.com> writes:

> 2nd, use the Fixes tag [2] in this case with a reference to the
> culprit commit [1].
>
> Fixes: 3a939a671225 ("ath9k_htc: Add a module parameter to disable blink")

Good point. I just found a handy tip from SubmittingPatches, just add
this to ~/.gitconfig:

	[core]
		abbrev = 12
	[pretty]
		fixes = Fixes: %h (\"%s\")

And then you get the fixes line automatically formatted for whatever
commit you want:

$ git log --format=fixes | head -5
Fixes: fa1270678ce4 ("ath10k: Enable the MCS8 and MCS9 at 2.4G band")
Fixes: 296f98ed02dd ("ath10k: fix pmf for wmi-tlv on qca6174")
Fixes: 3443aaf6f11d ("ath10k: remove sw encryption for pmf")
Fixes: d541c931dc93 ("ath10k: disable irqs after fw crash")
Fixes: 9f282daeedc9 ("ath10k: disable uapsd autotrigger")

Yet another reason why git is so awesome.

-- 
Kalle Valo
