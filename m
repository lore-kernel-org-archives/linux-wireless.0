Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:65051 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751363AbaDXGVl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Apr 2014 02:21:41 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCHv2 0/3] ath10k: improve recovery speed
References: <1397038028-7665-1-git-send-email-michal.kazior@tieto.com>
	<1397460146-19450-1-git-send-email-michal.kazior@tieto.com>
Date: Thu, 24 Apr 2014 09:21:32 +0300
In-Reply-To: <1397460146-19450-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Mon, 14 Apr 2014 09:22:23 +0200")
Message-ID: <871twnnt77.fsf@kamboji.qca.qualcomm.com> (sfid-20140424_082144_978302_F3D9BFFA)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> Hi,
>
> Patch 1/3 is just a cleanup I wanted to keep
> separate from 2/3 which actually improves recovery
> speed.
>
> With this I'm able to recover from a `hard`
> simualtion crash in ~3 seconds instead of ~10.
>
> This should decrease the chance of CQM kicking in
> on connected clients (due to beacon loss) when
> ath10k is acting as AP.
>
> v2:
>  * add a comment in the code
>
>
> Michal Kazior (3):
>   ath10k: differentiate between target init failures
>   ath10k: don't wait for device init if it crashed
>   ath10k: skip suspending when recovering

Thanks, all patches applied.

-- 
Kalle Valo
