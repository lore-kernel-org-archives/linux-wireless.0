Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:46767 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752423AbaKZGgh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Nov 2014 01:36:37 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: don't drop corrupted mgmt frames
References: <1416839648-31803-1-git-send-email-michal.kazior@tieto.com>
Date: Wed, 26 Nov 2014 08:36:29 +0200
In-Reply-To: <1416839648-31803-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Mon, 24 Nov 2014 15:34:08 +0100")
Message-ID: <87ppcaxyc2.fsf@kamboji.qca.qualcomm.com> (sfid-20141126_073644_685113_0D487D2D)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> Some firmware revisions don't seem to deilver
> management frames with FCS error via WMI so narrow
> down the HTT rule to not drop corrupted management
> frames.
>
> This basically increases number of frames ath10k
> reports while sniffing.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

Thanks, applied.

-- 
Kalle Valo
