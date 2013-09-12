Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:18334 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754130Ab3ILQXY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Sep 2013 12:23:24 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Jingoo Han <jg1.han@samsung.com>
CC: "'John W. Linville'" <linville@tuxdriver.com>,
	<linux-wireless@vger.kernel.org>, <ath10k@lists.infradead.org>
Subject: Re: [PATCH 06/12] wireless: ath10k: remove unnecessary pci_set_drvdata()
References: <00b101ceae16$ecb87c30$c6297490$%han@samsung.com>
	<00b701ceae18$69cd1860$3d674920$%han@samsung.com>
Date: Thu, 12 Sep 2013 19:23:07 +0300
In-Reply-To: <00b701ceae18$69cd1860$3d674920$%han@samsung.com> (Jingoo Han's
	message of "Tue, 10 Sep 2013 20:25:11 +0900")
Message-ID: <87wqmmdn6c.fsf@qca.qualcomm.com> (sfid-20130912_182337_358951_C7FA1499)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jingoo Han <jg1.han@samsung.com> writes:

> The driver core clears the driver data to NULL after device_release
> or on probe failure. Thus, it is not needed to manually clear the
> device driver data to NULL.
>
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>

Thanks, applied.

-- 
Kalle Valo
