Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:4969 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752471AbaLAH0s (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Dec 2014 02:26:48 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 2/3] ath10k: remove callback argument
References: <1417082978-1701-1-git-send-email-michal.kazior@tieto.com>
	<1417082978-1701-2-git-send-email-michal.kazior@tieto.com>
Date: Mon, 1 Dec 2014 09:26:42 +0200
In-Reply-To: <1417082978-1701-2-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Thu, 27 Nov 2014 11:09:37 +0100")
Message-ID: <87iohvrft9.fsf@kamboji.qca.qualcomm.com> (sfid-20141201_082651_520166_BDC0889D)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> Pass the eid argument via skbuff control buffer.
> This will make it possible to work with queues of
> HTC event buffers.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

To make the title more unique I changed the title to:

ath10k: remove transfer_id from ath10k_hif_cb::tx_completion

-- 
Kalle Valo
