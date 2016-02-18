Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:44476 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1426185AbcBRNn2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Feb 2016 08:43:28 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Arend Van Spriel <arend.van@broadcom.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: wireless dependency
References: <CAF7Mx6rQrsxkm1g9O6-dkzQPLgV0X3yb5TakrOU316Xy-bU1pw@mail.gmail.com>
	<87egcarw4x.fsf@kamboji.qca.qualcomm.com>
Date: Thu, 18 Feb 2016 15:43:20 +0200
Message-ID: <87twl6qglj.fsf@kamboji.qca.qualcomm.com> (sfid-20160218_144332_613059_C01377F8)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@codeaurora.org> writes:

> Arend Van Spriel <arend.van@broadcom.com> writes:
>
>> I am preparing a patch series for wireless-drivers-next, but there is
>> a dependency with patch that was submitted to wireless-drivers [1].
>> How should I handle this. Can I submit it for wireless-drivers-next as
>> well?
>>
>> [1] https://patchwork.kernel.org/patch/8061031/
>
> Commiting the same patch twice is not acceptable. I think the easiest is
> that you submit the dependency patches separately and document in patch
> (after "---" line) or in the cover letter what commits you need from
> wireless-drivers and why. I can then merge wireless-drivers to
> wireless-drivers-next.

I just checked and the commit is already in net-next (I guess via net
tree) so there's actually no problem. This commit should be in
wireless-drivers-next in next few minutes (as soon as the compilation
finishes).

I also saw that you already submitted the patches you were talking
about. I can just drop the duplicate patch, no need to resend anything
because of this.

commit e0045bf80f62779ba75ba04513020d60e59f5298
Author: Hante Meuleman <meuleman@broadcom.com>
Date:   Tue Jan 19 12:39:24 2016 +0100

    brcmfmac: fix sdio sg table alloc crash

-- 
Kalle Valo
