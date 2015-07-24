Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:17286 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753599AbbGXHqr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Jul 2015 03:46:47 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Peter Oh <poh@qca.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v3 0/3] ath10k: update data path to support QCA99X0
References: <cover.1437011880.git.poh@qca.qualcomm.com>
Date: Fri, 24 Jul 2015 10:46:42 +0300
In-Reply-To: <cover.1437011880.git.poh@qca.qualcomm.com> (Peter Oh's message
	of "Wed, 15 Jul 2015 19:01:18 -0700")
Message-ID: <87r3nyf15p.fsf@kamboji.qca.qualcomm.com> (sfid-20150724_094650_592744_BF0E6BFC)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Peter Oh <poh@qca.qualcomm.com> writes:

> This patch series update ath10k HTT Tx/Rx path to support
> QCA99X0 chip and make it able to run data traffic on both of
> Tx and Rx path.
>
> v2: fixed a type mismatch warning in htt_tx.c
> v3: fixed checkpatch warnings
>
> Peter Oh (3):
>   ath10k: update tx path to support QCA99X0
>   ath10k: redefine rx_ppdu_end_common structure to cover qca99x0
>   ath10k: add support for qca99x0 Rx descriptors

Thanks, all three applied.

-- 
Kalle Valo
