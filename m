Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:23176 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752788Ab3HGHHy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Aug 2013 03:07:54 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Bartosz Markowski <bartosz.markowski@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2] ath10k: add SoC power save option to PCI features map
References: <1375430329-23352-1-git-send-email-bartosz.markowski@tieto.com>
Date: Wed, 7 Aug 2013 10:07:47 +0300
In-Reply-To: <1375430329-23352-1-git-send-email-bartosz.markowski@tieto.com>
	(Bartosz Markowski's message of "Fri, 2 Aug 2013 09:58:49 +0200")
Message-ID: <87haf26ksc.fsf@kamboji.qca.qualcomm.com> (sfid-20130807_090757_825108_E953D0E3)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bartosz Markowski <bartosz.markowski@tieto.com> writes:

> Unify the PCI options location.
>
> By default the SoC PS option is disabled to boost the
> performance and due to poor stability on early HW revisions.
> In future we can remove the module parameter and turn on/off
> the PS for given hardware.
>
> This change also makes the pci module parameter for SoC PS static.
>
> Signed-off-by: Bartosz Markowski <bartosz.markowski@tieto.com>

Thanks, applied. But there were conflicts, please double check that I
didn't break anything.

-- 
Kalle Valo
