Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:39083 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751389AbbFAHSu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Jun 2015 03:18:50 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
Subject: Re: [PATCH v4] ath10k: bypass PLL setting on target init for QCA9888
References: <1432736253-30040-1-git-send-email-kvalo@qca.qualcomm.com>
Date: Mon, 1 Jun 2015 10:18:44 +0300
In-Reply-To: <1432736253-30040-1-git-send-email-kvalo@qca.qualcomm.com> (Kalle
	Valo's message of "Wed, 27 May 2015 17:17:33 +0300")
Message-ID: <87r3pvvquj.fsf@kamboji.qca.qualcomm.com> (sfid-20150601_091932_255172_1DD2DF05)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@qca.qualcomm.com> writes:

> From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
>
> Some of of qca988x solutions are having global reset issue
> during target initialization. Bypassing PLL setting before
> downloading firmware and letting the SoC run on REF_CLK is fixing
> the problem. Corresponding firmware change is also needed to set
> the clock source once the target is initialized. Since 10.2.4
> firmware is having this ROM patch, applying skip_clock_init only
> for 10.2.4 firmware versions.
>
> Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>

Thanks, applied.

-- 
Kalle Valo
