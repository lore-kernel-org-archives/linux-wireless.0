Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:32263 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751228AbaKCXGb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Nov 2014 18:06:31 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Bartosz Markowski <bartosz.markowski@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v3] ath10k: fix pm resume after suspend
References: <1414742623-308-1-git-send-email-bartosz.markowski@tieto.com>
Date: Tue, 4 Nov 2014 01:06:06 +0200
In-Reply-To: <1414742623-308-1-git-send-email-bartosz.markowski@tieto.com>
	(Bartosz Markowski's message of "Fri, 31 Oct 2014 09:03:43 +0100")
Message-ID: <87d2937uld.fsf@kamboji.qca.qualcomm.com> (sfid-20141104_000634_756907_9E00D28A)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bartosz Markowski <bartosz.markowski@tieto.com> writes:

> Firmware was crashing when we were trying to warm reset it
> after suspend. This was due to the fact that target registeres
> can be accessed only if the hardware is awaken.
>
> This patch makes sure to awake the device also on the hif up,
> not only in case of probe call.
>
> Signed-off-by: Bartosz Markowski <bartosz.markowski@tieto.com>

Thanks, applied.

-- 
Kalle Valo
