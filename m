Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.impitoyable.jabatus.fr ([109.234.163.30]:46633 "EHLO
        mail.impitoyable.jabatus.fr" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1166562AbdD2Kjj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 29 Apr 2017 06:39:39 -0400
From: Michael Mera <dev@michaelmera.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: "ath10k\@lists.infradead.org" <ath10k@lists.infradead.org>,
        "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [RESEND] ath10k: fix out of bounds access to local buffer
In-Reply-To: <87r30fxw7u.fsf@kamboji.qca.qualcomm.com>
References: <20170424071157.6979-1-dev@michaelmera.com> <0a7aa133740b4488a19bd95115831988@euamsexm01a.eu.qualcomm.com> <87a873wjak.fsf@michaelmera.com> <87r30fxw7u.fsf@kamboji.qca.qualcomm.com>
Date: Sat, 29 Apr 2017 19:39:13 +0900
Message-ID: <877f235wha.fsf@michaelmera.com> (sfid-20170429_123953_492717_B7D3AE14)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@qca.qualcomm.com> writes:
> I actually guessed why you did that. But I want to keep the output of my
> test script clean, makes review a lot easier. Making exceptions to the
> script is more work for me.

Yes, sorry. I found the ath10k specific instructions only after
submitting the patch.

> Anyway, I already did the change in my pending branch and will apply the
> patch in few days. Thanks for the fix.

Thank you,
Michael Mera
