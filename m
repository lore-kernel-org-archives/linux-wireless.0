Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:61203 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753807AbaJGOPo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Oct 2014 10:15:44 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 0/4] ath10k: Add pktlog support
References: <1412269778-1045-1-git-send-email-rmanohar@qti.qualcomm.com>
Date: Tue, 7 Oct 2014 17:15:20 +0300
In-Reply-To: <1412269778-1045-1-git-send-email-rmanohar@qti.qualcomm.com>
	(Rajkumar Manoharan's message of "Thu, 2 Oct 2014 22:39:34 +0530")
Message-ID: <87sij0hsp3.fsf@kamboji.qca.qualcomm.com> (sfid-20141007_161548_312088_0965755C)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rajkumar Manoharan <rmanohar@qti.qualcomm.com> writes:

> This implements the Packet log feature for ath10k.
> All tx and rx events and rx descriptor details are
> posted to user space by tracepoints.
>
> v2: Addressed review comments and based on discussion with Michal
>     dropped tx_msdu_id patch and added tx info changes
>
> Rajkumar Manoharan (4):
>   ath10k: Add support to configure pktlog filter
>   ath10k: add tracing for ath10k_htt_pktlog
>   ath10k: add tracing for rx descriptor
>   ath10k: add tracing for tx msdu pktlog event

Thanks, all four patches applied.

-- 
Kalle Valo
