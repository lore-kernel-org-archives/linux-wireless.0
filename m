Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:51666 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753753AbaJWPKj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Oct 2014 11:10:39 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Bartosz Markowski <bartosz.markowski@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: fix pm resume after suspend
References: <1414073150-11593-1-git-send-email-bartosz.markowski@tieto.com>
Date: Thu, 23 Oct 2014 18:10:27 +0300
In-Reply-To: <1414073150-11593-1-git-send-email-bartosz.markowski@tieto.com>
	(Bartosz Markowski's message of "Thu, 23 Oct 2014 16:05:49 +0200")
Message-ID: <87siieom8s.fsf@kamboji.qca.qualcomm.com> (sfid-20141023_171043_351156_A64CF6C1)
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
> not only in case of probe call path.
>
> Signed-off-by: Bartosz Markowski <bartosz.markowski@tieto.com>

This one has non-trivial conflicts. Can you rebase, please?

-- 
Kalle Valo
