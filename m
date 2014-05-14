Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:13617 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751899AbaENMqn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 May 2014 08:46:43 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Bartosz Markowski <bartosz.markowski@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: get rid of pci_assign_resource() call from pci_probe
References: <1400068627-4076-1-git-send-email-bartosz.markowski@tieto.com>
Date: Wed, 14 May 2014 15:46:35 +0300
In-Reply-To: <1400068627-4076-1-git-send-email-bartosz.markowski@tieto.com>
	(Bartosz Markowski's message of "Wed, 14 May 2014 13:57:07 +0200")
Message-ID: <87fvkch6j8.fsf@kamboji.qca.qualcomm.com> (sfid-20140514_144646_168631_B889CA03)
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

Typo, it should be "completely". I have fixed this up in ath-next-test.

-- 
Kalle Valo
