Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:43712 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752688AbaIVKdk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Sep 2014 06:33:40 -0400
Received: by mail-wi0-f173.google.com with SMTP id r20so2617946wiv.12
        for <linux-wireless@vger.kernel.org>; Mon, 22 Sep 2014 03:33:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87oau8m1hg.fsf@kamboji.qca.qualcomm.com>
References: <1411046487-19544-1-git-send-email-michal.kazior@tieto.com>
	<1411046487-19544-7-git-send-email-michal.kazior@tieto.com>
	<87a95wngzt.fsf@kamboji.qca.qualcomm.com>
	<CA+BoTQmsVqvGgu_fUqKGqhEKXV7E_w0KdcH_GFoPhAvyjtVdDA@mail.gmail.com>
	<87oau8m1hg.fsf@kamboji.qca.qualcomm.com>
Date: Mon, 22 Sep 2014 12:33:39 +0200
Message-ID: <CA+BoTQmNx2BaJB5b0irmZUi14xAhBeAtVZAcQU_K=M6QnZXHHQ@mail.gmail.com> (sfid-20140922_123352_085434_6C3AA94F)
Subject: Re: [PATCH 6/9] ath10k: deduplicate wmi service ready logic
From: Michal Kazior <michal.kazior@tieto.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 22 September 2014 11:46, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> Michal Kazior <michal.kazior@tieto.com> writes:
[...]
> Like discussed in IRC, you don't need to resent the whole patchset just
> because of this. I have now folded the patch below onto your patch in
> ath-next-test, please review:
>
> https://github.com/kvalo/ath/commit/1d13ab4a3bdfd342ed8fbead859de398b379435c

Looks good. Thanks!


Michał
