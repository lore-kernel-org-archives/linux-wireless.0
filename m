Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:30276 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754087AbbCLMca (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Mar 2015 08:32:30 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: fix CAC regression
References: <1425907255-14083-1-git-send-email-michal.kazior@tieto.com>
Date: Thu, 12 Mar 2015 14:32:20 +0200
In-Reply-To: <1425907255-14083-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Mon, 9 Mar 2015 14:20:55 +0100")
Message-ID: <87y4n2v1kb.fsf@kamboji.qca.qualcomm.com> (sfid-20150312_133234_631101_81B5253C)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> Patch `ath10k: fix interrupt storm` introduced a
> regression. The condition responsible for bringing
> up monitor vdev was broken and it was never
> started for CAC so effectivelly CAC would not
> detect radar pulses.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

Thanks, applied. I just added the commit id to the commit log.

-- 
Kalle Valo
