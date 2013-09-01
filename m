Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:64271 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751626Ab3IAGgf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Sep 2013 02:36:35 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 0/6] ath10k: CE cleanups
References: <1377068249-26025-1-git-send-email-michal.kazior@tieto.com>
	<1377601683-12072-1-git-send-email-michal.kazior@tieto.com>
Date: Sun, 1 Sep 2013 09:36:30 +0300
In-Reply-To: <1377601683-12072-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Tue, 27 Aug 2013 13:07:57 +0200")
Message-ID: <87zjrx6ob5.fsf@kamboji.qca.qualcomm.com> (sfid-20130901_083640_331823_5A0F8E3D)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> This patchset contains non-functional changes
> except patch #1 which changes memory allocation
> from dynamic to static.
>
> There is still some more to clean up in PCI/CE
> but it's probably better to keep patchsets compact
> and more frequent.
>
> v2:
>  * fix checkpatch warning (Kalle)
>
>
> Michal.
>
>
> Michal Kazior (6):
>   ath10k: use inline ce_state structure
>   ath10k: remove ce_op_state
>   ath10k: remove unused ce_attr parameters
>   ath10k: rename hif_ce_pipe_info to ath10k_pci_pipe
>   ath10k: rename ce_state to ath10k_ce_pipe
>   ath10k: rename ce_ring_state to ath10k_ce_ring

Applied all six, thanks.

I dropped the lock addition from patch 1 and patch 5 had a conflict due
to that change. Please double check that I didn't break anything.

-- 
Kalle Valo
