Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:57447 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751764AbaKZGcQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Nov 2014 01:32:16 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/3] ath10k: fix offchan reliability
References: <1416837513-13386-1-git-send-email-michal.kazior@tieto.com>
Date: Wed, 26 Nov 2014 08:32:06 +0200
In-Reply-To: <1416837513-13386-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Mon, 24 Nov 2014 14:58:31 +0100")
Message-ID: <87y4qyxyjd.fsf@kamboji.qca.qualcomm.com> (sfid-20141126_073219_047738_B8B47EE5)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> New firmware revisions don't need peer creation
> when doing offchannel tx. Earlier revisions would
> queue and never release frames without a peer.
>
> This prevent new firmware revisions from stopping
> replenishing wmi-htc tx credits and improves
> reliability of offchannel tx which would sometimes
> silently fail.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

Thanks, all three patches applied.

-- 
Kalle Valo
