Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:57691 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750819AbaHBGMs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Aug 2014 02:12:48 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: improve channel switching
References: <1406554132-17264-1-git-send-email-michal.kazior@tieto.com>
Date: Sat, 2 Aug 2014 09:12:25 +0300
In-Reply-To: <1406554132-17264-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Mon, 28 Jul 2014 15:28:52 +0200")
Message-ID: <87ppgj5sja.fsf@kamboji.qca.qualcomm.com> (sfid-20140802_081404_305621_D58AE0E4)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> In some cases during heavy tx vdev stop-start
> would timeout on vdev synchronization causing
> traffic to stall for a few seconds.
>
> Instead of stop-starting use a dedicated vdev
> restart command and down vdevs explicitly before
> doing so.
>
> This gets rid of the synchronization
> warnings/timeouts and makes channel switching
> smoother during traffic.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

Thanks, applied.

-- 
Kalle Valo
