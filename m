Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:59279 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750746AbaG2Jow (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jul 2014 05:44:52 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>,
	Vu Hai NGUYEN <vh.nguyen@actiasodielec.fr>,
	<linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: fix aggregated 4addr Rx
References: <1406205374-24858-1-git-send-email-michal.kazior@tieto.com>
Date: Tue, 29 Jul 2014 12:44:36 +0300
In-Reply-To: <1406205374-24858-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Thu, 24 Jul 2014 14:36:14 +0200")
Message-ID: <8761igijnf.fsf@kamboji.qca.qualcomm.com> (sfid-20140729_114455_464477_A6293E3E)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> A-MSDU 4addr frames weren't reconstructed properly
> and in some cases this resulted in a warning:
>
>  br0: received packet on wlan0.sta1 with own address as source address
>
> Since this was only related to A-MSDU it would
> trigger when more intense traffic was generated.
>
> Reported-by: Vu Hai NGUYEN <vh.nguyen@actiasodielec.fr>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

Thanks, applied.

-- 
Kalle Valo
