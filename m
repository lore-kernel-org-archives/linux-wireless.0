Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:36380 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753426AbaHLHoU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Aug 2014 03:44:20 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: fix wmi service bitmap debug
References: <1406628239-31322-1-git-send-email-michal.kazior@tieto.com>
Date: Tue, 12 Aug 2014 10:44:14 +0300
In-Reply-To: <1406628239-31322-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Tue, 29 Jul 2014 12:03:59 +0200")
Message-ID: <87y4uuqhip.fsf@kamboji.qca.qualcomm.com> (sfid-20140812_094424_594212_A4642E01)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> The 10.x and main firmware branches have
> conflicting WMI service bitmap definitions.
>
> This also fixes WMI services parsing on big-endian
> hosts and changes debugfs output to be more human
> friendly.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

Thanks, applied.

-- 
Kalle Valo
