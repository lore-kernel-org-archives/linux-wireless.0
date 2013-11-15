Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:48052 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753514Ab3KOJKE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Nov 2013 04:10:04 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: allow dynamic bandwidth in hw rate control
References: <1384337110-9417-1-git-send-email-michal.kazior@tieto.com>
Date: Fri, 15 Nov 2013 10:59:57 +0200
In-Reply-To: <1384337110-9417-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Wed, 13 Nov 2013 11:05:10 +0100")
Message-ID: <87r4ai3ur6.fsf@kamboji.qca.qualcomm.com> (sfid-20131115_101011_696513_48910ACE)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> Frames were never retransmitted with
> different/lower bandwidths, e.g. only 80MHz
> bandwidth was used when dealing with a VHT80
> peer.
>
> Allow HW rate control to try out different
> bandwidths when retransmitting. This increases
> robustness.
>
> Also, document the parameter properly.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

Thanks, applied.

-- 
Kalle Valo
