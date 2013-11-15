Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:13169 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753494Ab3KOJHE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Nov 2013 04:07:04 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Bartosz Markowski <bartosz.markowski@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: expand the wmi mgmt queue limit to 128
References: <1384416075-13751-1-git-send-email-bartosz.markowski@tieto.com>
Date: Fri, 15 Nov 2013 11:01:50 +0200
In-Reply-To: <1384416075-13751-1-git-send-email-bartosz.markowski@tieto.com>
	(Bartosz Markowski's message of "Thu, 14 Nov 2013 09:01:15 +0100")
Message-ID: <87iovu3uo1.fsf@kamboji.qca.qualcomm.com> (sfid-20131115_100712_705484_C440CDFA)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bartosz Markowski <bartosz.markowski@tieto.com> writes:

> It was obseverd many times the short queue limit can be
> easily exceeded in case of AP multiple BSSID scenarios.
>
> "ath10k: wmi mgmt_tx queue limit reached."
>
> This was leading to TX packets drops.
>
> This patch expands the queue limit to 128. After many stress
> experiments (high traffic and lot of management frames in
> the air) the new value seems to fix the problem on platforms
> with limited resources.
>
> Reported-By: Tomasz Skapski <tomasz.skapski@tieto.com>
> Signed-off-by: Bartosz Markowski <bartosz.markowski@tieto.com>

Thanks, applied.

-- 
Kalle Valo
