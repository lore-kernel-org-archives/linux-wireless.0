Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:10809 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754396AbbCLMTg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Mar 2015 08:19:36 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: fix patching mistake for AP/IBSS CSA
References: <877fuqz7b6.fsf@kamboji.qca.qualcomm.com>
	<1425907164-13935-1-git-send-email-michal.kazior@tieto.com>
Date: Thu, 12 Mar 2015 14:19:27 +0200
In-Reply-To: <1425907164-13935-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Mon, 9 Mar 2015 14:19:24 +0100")
Message-ID: <87385awgq8.fsf@kamboji.qca.qualcomm.com> (sfid-20150312_131941_921928_7E2FC2D2)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> Mistakenly v1 of `ath10k: fix AP/IBSS CSA with
> template based fw`
> (81a9a17db5d766d2872c4ab8a77b8666d22031ec) was
> applied.
>
> This patch applies the missing bits from v2:
>  * remove unnecessary locking
>  * add some (sanity) checks
>
> There are no practical functionality differences
> between v1 and v2.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

Thanks, applied. Sorry for my mistake and kudos for catching it so fast!

-- 
Kalle Valo
