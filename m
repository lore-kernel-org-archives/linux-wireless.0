Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:5413 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751371AbaK0M7i (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Nov 2014 07:59:38 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 0/7] ath10k: add support for new wmi-tlv backend
References: <1417079481-22255-1-git-send-email-michal.kazior@tieto.com>
Date: Thu, 27 Nov 2014 14:59:32 +0200
In-Reply-To: <1417079481-22255-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Thu, 27 Nov 2014 10:11:14 +0100")
Message-ID: <87ppc8u7d7.fsf@kamboji.qca.qualcomm.com> (sfid-20141127_135941_495140_10FE290B)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> First 2 patches are simple fixes. Patch 3 isn't
> strictly related to wmi-tlv but I decided to
> include it anyway. Other patches gradually
> implement wmi-tlv.
>
> There's a bunch of false-positive checkpatch
> warnings regarding `CHECK: No space is necessary
> after a cast`.
>
> v2:
>  * a lot of fixes (see notes on patch #7)
>
> Michal Kazior (7):
>   ath10k: fix wmi svc bitmap dbg print
>   ath10k: add sanity checks for service bmap parsing
>   ath10k: make wmi service bitmap non-debug

These look ok and are now in ath-next-text.

>   ath10k: implement intermediate event args
>   ath10k: introduce wmi ops
>   ath10k: make some wmi functions public
>   ath10k: implement wmi-tlv backend

I still need to look at these more carefully.

-- 
Kalle Valo
