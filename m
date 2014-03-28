Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:32925 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751185AbaC1MdQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Mar 2014 08:33:16 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 0/3] ath10k: ce fixes
References: <1395745943-29492-1-git-send-email-michal.kazior@tieto.com>
	<1395992065-10086-1-git-send-email-michal.kazior@tieto.com>
Date: Fri, 28 Mar 2014 14:33:10 +0200
In-Reply-To: <1395992065-10086-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Fri, 28 Mar 2014 08:34:22 +0100")
Message-ID: <8761mywlix.fsf@kamboji.qca.qualcomm.com> (sfid-20140328_133319_386207_554FF4DD)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> Hi,
>
> This addresses memory allocations failures
> recently reported by Avery Pennarun.
>
>
> v2:
>  * add a new patch (result of splitting)
>  * fix commit message
>
>
> Michal Kazior (3):
>   ath10k: convert pci_alloc_consistent() to dma_alloc_coherent()
>   ath10k: split ce initialization and allocation
>   ath10k: deinit copy engine before resetting

Thanks, all patches applied.

-- 
Kalle Valo
