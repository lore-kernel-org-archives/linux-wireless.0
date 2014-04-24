Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:4239 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751363AbaDXGXm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Apr 2014 02:23:42 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCHv2 0/4] ath10k: AP-related fixes
References: <1397037685-7485-1-git-send-email-michal.kazior@tieto.com>
	<1397460010-19153-1-git-send-email-michal.kazior@tieto.com>
Date: Thu, 24 Apr 2014 09:23:32 +0300
In-Reply-To: <1397460010-19153-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Mon, 14 Apr 2014 09:20:06 +0200")
Message-ID: <87wqefmejf.fsf@kamboji.qca.qualcomm.com> (sfid-20140424_082346_814927_13CE2AD2)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> Hi,
>
> This is a bunch of fixes I've found while
> investigating tx credit issues.
>
> I've only experienced problem fixed by 4/4
> firsthand. Other patches are preemptive fixes :-)
>
> v2:
>  * minor tweaks
>
> Michal Kazior (4):
>   ath10k: make sure to not leak beacon dma mapping
>   ath10k: make sure to not use invalid beacon pointer
>   ath10k: prevent beacon memory leak
>   ath10k: fix firmware recovery with ap interface

Thanks, all patches applied.

-- 
Kalle Valo
