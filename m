Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:11110 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753424AbaAJJss (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Jan 2014 04:48:48 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Bartosz Markowski <bartosz.markowski@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: track number of existing peers
References: <1388669913-29031-1-git-send-email-bartosz.markowski@tieto.com>
Date: Fri, 10 Jan 2014 11:48:43 +0200
In-Reply-To: <1388669913-29031-1-git-send-email-bartosz.markowski@tieto.com>
	(Bartosz Markowski's message of "Thu, 2 Jan 2014 14:38:33 +0100")
Message-ID: <87sisw9ngk.fsf@kamboji.qca.qualcomm.com> (sfid-20140110_104859_813999_DD907C33)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bartosz Markowski <bartosz.markowski@tieto.com> writes:

> To not exceed number of allowed clients (AP mode), make sure to
> check how many of them are already on the peers list.
>
> 10.X firmware support up to 127 peers, non-AP centric firmwares 16.
>
> Signed-off-by: Bartosz Markowski <bartosz.markowski@tieto.com>

Thanks, applied.

-- 
Kalle Valo
