Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:13189 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752501AbaIRHvC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Sep 2014 03:51:02 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 00/10] ath10k: checkpatch fixes from v3.17
References: <20140914094728.9063.32593.stgit@x230>
Date: Thu, 18 Sep 2014 10:50:54 +0300
In-Reply-To: <20140914094728.9063.32593.stgit@x230> (Kalle Valo's message of
	"Sun, 14 Sep 2014 12:49:55 +0300")
Message-ID: <87r3z9s6xt.fsf@kamboji.qca.qualcomm.com> (sfid-20140918_095112_679384_BF5D04EE)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@qca.qualcomm.com> writes:

> Hi,
>
> some fixes to recently added checkpatch warnings. Please review.
>
> Kalle
>
> ---
>
> Kalle Valo (10):
>       ath10k: fix parenthesis alignment warning in ath10k_htt_rx_alloc()
>       ath10k: fix checkpatch warnings about parenthesis alignment
>       ath10k: fix use of multiple blank lines
>       ath10k: fix missing a blank line after declarations
>       ath10k: fix space after a cast style errors
>       ath10k: don't use return on void functions
>       ath10k: else is not generally useful after a break or return
>       ath10k: miscellaneous checkpatch fixes
>       ath10k: reformat help text in ath10k_read_simulate_fw_crash()
>       ath10k: use ether_addr_copy()

All ten applied.

-- 
Kalle Valo
