Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yk0-f178.google.com ([209.85.160.178]:36657 "EHLO
	mail-yk0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752958AbcCGUDC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Mar 2016 15:03:02 -0500
Received: by mail-yk0-f178.google.com with SMTP id 1so53583157ykg.3
        for <linux-wireless@vger.kernel.org>; Mon, 07 Mar 2016 12:03:01 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <87egbmtpv3.fsf@kamboji.qca.qualcomm.com>
References: <20160307121950.CDA876067A@smtp.codeaurora.org>
	<87egbmtpv3.fsf@kamboji.qca.qualcomm.com>
Date: Mon, 7 Mar 2016 21:03:01 +0100
Message-ID: <CAF7Mx6oFVK6HY3+QfEFDd9P8GvGqPbaLLdvwMn-Qi_BJQNL5QA@mail.gmail.com> (sfid-20160307_210307_272968_819085B8)
Subject: Re: [01/21] brcmfmac: change function name forbrcmf_cfg80211_wait_vif_event_timeout()
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Arend van Spriel <arend@broadcom.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 7, 2016 at 1:49 PM, Kalle Valo <kvalo@codeaurora.org> wrote:
> Kalle Valo <kvalo@codeaurora.org> writes:
>
>> 1 patches skipped:
>>
>> [17/21] brcmfmac: fix sdio sg table alloc crash
>>
>> There was a conflict so please rebase that patch:
>>
>> Applying: brcmfmac: fix sdio sg table alloc crash
>> fatal: sha1 information is lacking or useless (drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c).
>> Repository lacks necessary blobs to fall back on 3-way merge.
>> Cannot fall back to three-way merge.
>> Patch failed at 0001 brcmfmac: fix sdio sg table alloc crash
>
> Ah, I noticed only now your comment that this patch is in
> wireless-drivers already. So no actions needed.
>
> But in the future please don't submit the same patch twice, otherwise I
> accidentally commit it twice which is bad. Instead document the
> dependency and we can sort it out.

Yeah. We already discussed this earlier [1]. Has been noted.

Thanks,
Arend

[1] http://article.gmane.org/gmane.linux.kernel.wireless.general/148691

> --
> Kalle Valo
