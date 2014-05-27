Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:6629 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752164AbaE0JdD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 May 2014 05:33:03 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
	<apenwarr@gmail.com>
Subject: Re: [PATCH v2 0/2] ath10k: pci fixes 2014-05-15
References: <1400158139-13836-1-git-send-email-michal.kazior@tieto.com>
	<1401098579-31842-1-git-send-email-michal.kazior@tieto.com>
Date: Tue, 27 May 2014 12:32:55 +0300
In-Reply-To: <1401098579-31842-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Mon, 26 May 2014 12:02:57 +0200")
Message-ID: <87k397bm7s.fsf@kamboji.qca.qualcomm.com> (sfid-20140527_113308_347591_D26B95B2)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> Hi,
>
> Patches are a result of analysing `ath10k firmware
> crash after 4 hours of heavy TCP traffic` bug
> reported by Avery.
>
> v2:
>  * dropped patch 3/3 (memory barrier addition) [Kalle]
>
> Based on github.com/kvalo/ath/master
>
>
> Michal Kazior (2):
>   ath10k: protect src_ring state with ce_lock in tx_sg()
>   ath10k: abort incomplete scatter-gather pci tx properly

Thanks, both patches applied.

-- 
Kalle Valo
