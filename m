Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:61519 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290Ab3GaGG1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Jul 2013 02:06:27 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: improve tx throughput on slow machines
References: <1374495928-29514-1-git-send-email-michal.kazior@tieto.com>
Date: Wed, 31 Jul 2013 09:06:10 +0300
In-Reply-To: <1374495928-29514-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Mon, 22 Jul 2013 14:25:28 +0200")
Message-ID: <87ehafs1pp.fsf@kamboji.qca.qualcomm.com> (sfid-20130731_080631_219941_D21A1F9C)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> It is more efficient to move just the 802.11
> header instead of the whole payload in most cases.
>
> This has no measurable effect on modern hardware.
> It should improve performance by a few percent on
> hardware such as an Access Point that have a slow
> CPU compared to a typical desktop CPU.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

Applied, thanks.

-- 
Kalle Valo
