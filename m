Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:31039 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752571AbaLAHbd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Dec 2014 02:31:33 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: simplify rx ring size/fill calculation
References: <1417083163-2962-1-git-send-email-michal.kazior@tieto.com>
Date: Mon, 1 Dec 2014 09:31:27 +0200
In-Reply-To: <1417083163-2962-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Thu, 27 Nov 2014 11:12:43 +0100")
Message-ID: <87a937rflc.fsf@kamboji.qca.qualcomm.com> (sfid-20141201_083135_833789_2BC7DE2D)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> Don't bother with fancy arithmetic and just
> hardcode the final values.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

Thanks, applied.

-- 
Kalle Valo
