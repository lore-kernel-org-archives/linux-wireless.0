Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:47030 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753386Ab3JHS6Y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Oct 2013 14:58:24 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v3 0/2] ath10k: wep & ampdu fix
References: <1380874630-14280-1-git-send-email-michal.kazior@tieto.com>
	<1381200718-16271-1-git-send-email-michal.kazior@tieto.com>
Date: Tue, 8 Oct 2013 21:58:19 +0300
In-Reply-To: <1381200718-16271-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Mon, 7 Oct 2013 19:51:56 -0700")
Message-ID: <871u3vsi7o.fsf@kamboji.qca.qualcomm.com> (sfid-20131008_205827_460886_B827F22B)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> Hi,
>
> One throughput fix and one bug fix.
>
> The bug fix addresses my oversight when reworking
> HTC/WMI. I haven't seen the error yet but I'm
> quite certain this should be fixed.
>
> v2:
>  * A-MPDU patch contains a workaround for
>    Netgear/Linksys 11ac APs
>  * patchset cover mail title changed to avoid
>    confusion (too many patchsets named the same
>    way..)
>
> v3:
>  * fix lines over 80 chars (Kalle)
>  * fix max() cast warning (Kalle)
>  * rebase (Kalle)
>  * add Tested-by (thanks Kalle!)
>
>
> Michal Kazior (1):
>   ath10k: fix scheduling while atomic bug

I dropped this patch for now, need to think more about how to handle
this.

> Sujith Manoharan (1):
>   ath10k: Fix bug in max. VHT A-MPDU size

This is applied, thanks.

-- 
Kalle Valo
