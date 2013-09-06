Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:31872 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750788Ab3IFJnZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Sep 2013 05:43:25 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 0/3] ath10k: HTT stats
References: <20130903084302.26199.3538.stgit@localhost6.localdomain6>
Date: Fri, 6 Sep 2013 12:43:17 +0300
In-Reply-To: <20130903084302.26199.3538.stgit@localhost6.localdomain6> (Kalle
	Valo's message of "Tue, 03 Sep 2013 11:43:48 +0300")
Message-ID: <87ioyei8ui.fsf@kamboji.qca.qualcomm.com> (sfid-20130906_114339_947781_F05B2C94)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@qca.qualcomm.com> writes:

> Adds trace events and a debugfs interface to enable HTT stats
> from firmware.
>
> ---
>
> Kalle Valo (3):
>       ath10k: add trace event ath10k_htt_stats
>       ath10k: implement ath10k_debug_start/stop()
>       ath10k: add htt_stats_enable debugfs file

All three applied.

-- 
Kalle Valo
