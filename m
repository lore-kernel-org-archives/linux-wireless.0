Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:38960 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751204AbbJ2LEC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Oct 2015 07:04:02 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Bartosz Markowski <bartosz.markowski@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2] ath10k: add QCA9377 chipset support
References: <1446041393-4652-1-git-send-email-bartosz.markowski@tieto.com>
Date: Thu, 29 Oct 2015 13:03:42 +0200
In-Reply-To: <1446041393-4652-1-git-send-email-bartosz.markowski@tieto.com>
	(Bartosz Markowski's message of "Wed, 28 Oct 2015 15:09:53 +0100")
Message-ID: <87bnbiq6lt.fsf@kamboji.qca.qualcomm.com> (sfid-20151029_120415_229300_9A3DBD16)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bartosz Markowski <bartosz.markowski@tieto.com> writes:

> Add the hardware name, revision and update the pci_id table.
>
> Currently there're two HW ref. designs available I'm aware of,
> with 1.0.2 and 1.1 chip revisions. I've access and been using
> the first one so far and this patch cover only it.
>
> QCA9377 inherits most of the stuff (e.g. fw interfaces)
> from QCA61x4 design, so the integration was pretty straightforward.
>
> Signed-off-by: Bartosz Markowski <bartosz.markowski@tieto.com>

Applied, thanks.

I pushed the firmware image here:

https://github.com/kvalo/ath10k-firmware/tree/master/QCA9377/hw1.0

All reports, good or bad, are very welcome.

-- 
Kalle Valo
