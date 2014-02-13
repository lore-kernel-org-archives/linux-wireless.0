Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:39649 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903AbaBMOsN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Feb 2014 09:48:13 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Bartosz Markowski <bartosz.markowski@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: remove excessive rx msdu len check
References: <1392104226-12096-1-git-send-email-bartosz.markowski@tieto.com>
Date: Thu, 13 Feb 2014 16:48:08 +0200
In-Reply-To: <1392104226-12096-1-git-send-email-bartosz.markowski@tieto.com>
	(Bartosz Markowski's message of "Tue, 11 Feb 2014 08:37:06 +0100")
Message-ID: <87y51f83x3.fsf@kamboji.qca.qualcomm.com> (sfid-20140213_154816_279771_35CFD600)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bartosz Markowski <bartosz.markowski@tieto.com> writes:

> This throw a lot of pointless warnings in case of DFS (radar
> detection) and PHYERR events from firmware, when firmware may
> actually insert more data, than we assume.
>
> Besides of being noisy this debug does not protect or check
> anything usefull currently. It was introduced long time ago
> while debugging aggregations. So just removing it.
>
> Signed-off-by: Bartosz Markowski <bartosz.markowski@tieto.com>

Thanks, applied.

-- 
Kalle Valo
