Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:41690 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757609AbbA0OR6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Jan 2015 09:17:58 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: use idr api for msdu_ids
References: <1421413092-6649-1-git-send-email-michal.kazior@tieto.com>
Date: Tue, 27 Jan 2015 16:17:47 +0200
In-Reply-To: <1421413092-6649-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Fri, 16 Jan 2015 13:58:12 +0100")
Message-ID: <87twzcb94k.fsf@kamboji.qca.qualcomm.com> (sfid-20150127_151801_810887_46DC9E19)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> HTT Tx protocol uses arbitrary host assigned ids
> too associate with MSDUs when delivering
> completions.
>
> Instead of rolling out own id generation scheme
> use the tools provided in kernel.
>
> This should have little to no effect on
> performance.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

Thanks, applied to ath.git.

-- 
Kalle Valo
