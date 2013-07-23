Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:38587 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756067Ab3GWIqk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Jul 2013 04:46:40 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 2/4] ath10k: don't reset HTC endpoints unnecessarily
References: <1374129193-3533-1-git-send-email-michal.kazior@tieto.com>
	<1374495211-20353-1-git-send-email-michal.kazior@tieto.com>
	<1374495211-20353-3-git-send-email-michal.kazior@tieto.com>
Date: Tue, 23 Jul 2013 11:46:30 +0300
In-Reply-To: <1374495211-20353-3-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Mon, 22 Jul 2013 14:13:29 +0200")
Message-ID: <87r4epwtnd.fsf@kamboji.qca.qualcomm.com> (sfid-20130723_104656_577282_2881F9D2)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> Endpoints are re-initialized upon HTC start anyway
> so there's no need to do that twice in case of
> restarting HTC (i.e. in case of hardware
> recovery).
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

This is much better, thanks.

-- 
Kalle Valo
