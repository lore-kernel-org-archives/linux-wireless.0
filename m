Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:9780 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752426AbaLAHGu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Dec 2014 02:06:50 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: add pointer constness to traces
References: <1417074131-18460-1-git-send-email-michal.kazior@tieto.com>
Date: Mon, 1 Dec 2014 09:06:45 +0200
In-Reply-To: <1417074131-18460-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Thu, 27 Nov 2014 08:42:11 +0100")
Message-ID: <87r3wjrgqi.fsf@kamboji.qca.qualcomm.com> (sfid-20141201_080654_053456_D77A880E)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> Traces shouldn't modified passed data. This will
> make it possible to pass const arguments to
> traces.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

Thanks, applied.

-- 
Kalle Valo
