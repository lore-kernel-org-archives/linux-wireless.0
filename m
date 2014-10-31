Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:22730 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161369AbaJaArV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Oct 2014 20:47:21 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Bartosz Markowski <bartosz.markowski@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2] ath10k: fix pm resume after suspend
References: <1414399436-7047-1-git-send-email-bartosz.markowski@tieto.com>
Date: Fri, 31 Oct 2014 02:47:14 +0200
In-Reply-To: <1414399436-7047-1-git-send-email-bartosz.markowski@tieto.com>
	(Bartosz Markowski's message of "Mon, 27 Oct 2014 09:43:56 +0100")
Message-ID: <87d299dq0d.fsf@kamboji.qca.qualcomm.com> (sfid-20141031_014724_806003_BAB3B676)
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

Unfortunately this still does not apply, most likely because of Michal's
warm reset fixes I just applied. Can you rebase one more time, please?

-- 
Kalle Valo
