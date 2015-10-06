Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:27323 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751432AbbJFLoO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Oct 2015 07:44:14 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 0/2] ath10k: implement debugfs interface for Transmit Power Control stats
References: <20150918075706.6983.11216.stgit@potku.adurom.net>
Date: Tue, 6 Oct 2015 14:43:50 +0300
In-Reply-To: <20150918075706.6983.11216.stgit@potku.adurom.net> (Kalle Valo's
	message of "Fri, 18 Sep 2015 10:58:22 +0300")
Message-ID: <87d1ws2pe1.fsf@kamboji.qca.qualcomm.com> (sfid-20151006_134418_675106_40BEF0DB)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@qca.qualcomm.com> writes:

> This implements a simple interface for debugging TPC stats. I did a small hack
> to sparse to check endian usage with signed 32 bit values.
>
> ---
>
> Kalle Valo (1):
>       ath10k: add a_sle32_to_cpu()
>
> Maharaja Kennadyrajan (1):
>       ath10k: implement debugfs interface for Transmit Power Control stats

Applied.

-- 
Kalle Valo
