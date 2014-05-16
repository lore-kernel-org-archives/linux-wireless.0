Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:50050 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932441AbaEPNu6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 May 2014 09:50:58 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Bartosz Markowski <bartosz.markowski@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: get rid of pci_assign_resource() call from pci_probe
References: <1400068627-4076-1-git-send-email-bartosz.markowski@tieto.com>
Date: Fri, 16 May 2014 16:50:50 +0300
In-Reply-To: <1400068627-4076-1-git-send-email-bartosz.markowski@tieto.com>
	(Bartosz Markowski's message of "Wed, 14 May 2014 13:57:07 +0200")
Message-ID: <87k39l4yth.fsf@kamboji.qca.qualcomm.com> (sfid-20140516_155106_570257_F02EE620)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bartosz Markowski <bartosz.markowski@tieto.com> writes:

> On ARM-based (MSM mach), the pci_assign_resource() is passing
> some invalid pointers and leading to L2 cache errors,
> what prevents the PCI communication completly.
>
> So far I have not found this funtion to be directly called by
> any other wifi driver and did not found this assigning needed
> on any other platform. So removing it completly.
>
> Signed-off-by: Bartosz Markowski <bartosz.markowski@tieto.com>

Thanks, applied.

-- 
Kalle Valo
