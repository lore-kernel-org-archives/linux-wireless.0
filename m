Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:5688 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751043AbaBOGsi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 15 Feb 2014 01:48:38 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2] ath10k: fix SMPS support
References: <1391673591-8907-1-git-send-email-michal.kazior@tieto.com>
	<1392385551-3590-1-git-send-email-michal.kazior@tieto.com>
Date: Sat, 15 Feb 2014 08:48:32 +0200
In-Reply-To: <1392385551-3590-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Fri, 14 Feb 2014 14:45:51 +0100")
Message-ID: <87txc050sf.fsf@kamboji.qca.qualcomm.com> (sfid-20140215_074904_056300_DA551778)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> Firmware ignores SMPS flags in peer assoc command.
>
> For SMPS to work it is necessary to set peer
> parameter after peer assoc command so that tx
> chainmask is setup properly.
>
> This should fix packet loss and improve throughput
> with stations that have SMPS enabled upon
> association.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

Thanks, applied.

-- 
Kalle Valo
