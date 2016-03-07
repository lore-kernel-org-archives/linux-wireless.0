Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:51397 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752180AbcCGMt2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Mar 2016 07:49:28 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [01/21] brcmfmac: change function name forbrcmf_cfg80211_wait_vif_event_timeout()
References: <20160307121950.CDA876067A@smtp.codeaurora.org>
Date: Mon, 07 Mar 2016 14:49:20 +0200
In-Reply-To: <20160307121950.CDA876067A@smtp.codeaurora.org> (Kalle Valo's
	message of "Mon, 7 Mar 2016 12:19:50 +0000 (UTC)")
Message-ID: <87egbmtpv3.fsf@kamboji.qca.qualcomm.com> (sfid-20160307_134931_362572_455C247E)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@codeaurora.org> writes:

> 1 patches skipped:
>
> [17/21] brcmfmac: fix sdio sg table alloc crash
>
> There was a conflict so please rebase that patch:
>
> Applying: brcmfmac: fix sdio sg table alloc crash
> fatal: sha1 information is lacking or useless (drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c).
> Repository lacks necessary blobs to fall back on 3-way merge.
> Cannot fall back to three-way merge.
> Patch failed at 0001 brcmfmac: fix sdio sg table alloc crash

Ah, I noticed only now your comment that this patch is in
wireless-drivers already. So no actions needed.

But in the future please don't submit the same patch twice, otherwise I
accidentally commit it twice which is bad. Instead document the
dependency and we can sort it out.

-- 
Kalle Valo
