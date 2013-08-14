Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:27612 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932404Ab3HNPG0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Aug 2013 11:06:26 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Marek Puzyniak <marek.puzyniak@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: fix WEP in AP and IBSS mode
References: <1376387122-18075-1-git-send-email-marek.puzyniak@tieto.com>
Date: Wed, 14 Aug 2013 18:06:11 +0300
In-Reply-To: <1376387122-18075-1-git-send-email-marek.puzyniak@tieto.com>
	(Marek Puzyniak's message of "Tue, 13 Aug 2013 11:45:22 +0200")
Message-ID: <8761v848ij.fsf@kamboji.qca.qualcomm.com> (sfid-20130814_170630_306856_7C60301A)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Marek Puzyniak <marek.puzyniak@tieto.com> writes:

> WEP encoding was not working properly for AP and IBSS mode.
> TX frames were encrypted with default WEP tx key index set
> always to zero, what sometimes was wrong when different
> key index should be used. This patch allows to update
> WEP key index also for AP and IBSS mode.
> Problem detected during automated WEP tests.
>
> Signed-off-by: Marek Puzyniak <marek.puzyniak@tieto.com>

Thanks, applied.

-- 
Kalle Valo
