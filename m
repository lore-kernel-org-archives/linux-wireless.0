Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:9377 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932079AbaH0MOW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Aug 2014 08:14:22 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 0/3] ath10k: ce fixes 2014-08-08
References: <1408961963-3682-1-git-send-email-michal.kazior@tieto.com>
Date: Wed, 27 Aug 2014 15:14:16 +0300
In-Reply-To: <1408961963-3682-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Mon, 25 Aug 2014 12:19:20 +0200")
Message-ID: <87mwaqw2nb.fsf@kamboji.qca.qualcomm.com> (sfid-20140827_141445_218374_7F1B9A39)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> This removes implicit endianess in some places.
> I'd love to get rid of it from
> ath10k_pci_diag_access* as well but let's fix
> ath10k_pci_diag_mem_* first.
>
> Note: This is based on my logging patch and fw
> crash dump fix.
>
> v2:
>  * rebased
>  * some fixes in patch [3/3] (see notes there)
>
>
> Michal Kazior (3):
>   ath10k: move pci init structures
>   ath10k: dont duplicate service-pipe mapping
>   ath10k: make target endianess more explicit

Thanks, all three applied.

-- 
Kalle Valo
