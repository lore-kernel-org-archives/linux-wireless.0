Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:13861 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751331AbaKZG2i (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Nov 2014 01:28:38 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: remove extra_tx_headroom
References: <1416837886-18377-1-git-send-email-michal.kazior@tieto.com>
Date: Wed, 26 Nov 2014 08:28:32 +0200
In-Reply-To: <1416837886-18377-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Mon, 24 Nov 2014 15:04:46 +0100")
Message-ID: <873896zd9r.fsf@kamboji.qca.qualcomm.com> (sfid-20141126_072841_491993_3AA2BAEE)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> Comment was out-of-date. The headroom is no longer
> necessary because HTT Tx fragment list is stored
> in dma pool item associated with each sk_buff.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

Thanks, applied.

-- 
Kalle Valo
