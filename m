Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:54574 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751549AbbDOMIf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Apr 2015 08:08:35 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/2] ath10k: fix hw roc expiration
References: <1427799828-9539-1-git-send-email-michal.kazior@tieto.com>
Date: Wed, 15 Apr 2015 15:08:26 +0300
In-Reply-To: <1427799828-9539-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Tue, 31 Mar 2015 11:03:47 +0000")
Message-ID: <87oamp7fwl.fsf@kamboji.qca.qualcomm.com> (sfid-20150415_140838_914833_9C93BC6F)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> It is not guaranteed firmware will switch to
> foreign channel immediately after starting scan
> sequence. To account for that don't use duration
> parameter for scan time. Instead request insanely
> long scan and use timeout worker to cancel it from
> driver.
>
> This should improve P2P reliability a bit.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

Thanks, applied.

-- 
Kalle Valo
