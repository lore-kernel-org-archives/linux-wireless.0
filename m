Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:53604 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751501AbaEZJpg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 May 2014 05:45:36 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 0/3] ath10k: async pci probing
References: <1400767955-16313-1-git-send-email-michal.kazior@tieto.com>
	<1400840927-14272-1-git-send-email-michal.kazior@tieto.com>
Date: Mon, 26 May 2014 12:45:21 +0300
In-Reply-To: <1400840927-14272-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Fri, 23 May 2014 12:28:44 +0200")
Message-ID: <87ppj0swjy.fsf@kamboji.qca.qualcomm.com> (sfid-20140526_114539_679640_BD77C562)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> Hi,
>
> Recently I've tried to build ath10k into kernel
> and discovered it doesn't play nice.
>
>
> v2:
>  * split and introduce an additional patch [2/3]
>  * unbind driver upon failure
>
>
> Michal Kazior (3):
>   ath10k: relocate core create/destroy functions
>   ath10k: remove unnecessary tasklet_kill()
>   ath10k: make core registering async

Thanks, all three applied.

-- 
Kalle Valo
