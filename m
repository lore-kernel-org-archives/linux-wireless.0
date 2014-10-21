Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:31601 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752704AbaJUHiT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Oct 2014 03:38:19 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: simplify computation of mgmt rx band
References: <1412938148-6659-1-git-send-email-michal.kazior@tieto.com>
Date: Tue, 21 Oct 2014 10:37:59 +0300
In-Reply-To: <1412938148-6659-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Fri, 10 Oct 2014 12:49:08 +0200")
Message-ID: <87tx2xyiso.fsf@kamboji.qca.qualcomm.com> (sfid-20141021_093822_761629_1D44EF54)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> Using global channel won't work with chanctx. Try
> to determine the channel from the information
> provided in the wmi event itself alone. This
> should be sufficient.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

Thanks, applied.

-- 
Kalle Valo
