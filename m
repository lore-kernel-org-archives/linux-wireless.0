Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:2733 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756198AbbE2Onp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 May 2015 10:43:45 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: add missing firmware declarations
References: <1432638562-12954-1-git-send-email-michal.kazior@tieto.com>
Date: Fri, 29 May 2015 17:43:32 +0300
In-Reply-To: <1432638562-12954-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Tue, 26 May 2015 13:09:22 +0200")
Message-ID: <87r3pzwijv.fsf@kamboji.qca.qualcomm.com> (sfid-20150529_164359_599284_DE33A9EA)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> This could lead userspace initram images getting
> built without necessary firmware files included
> leading to probing failures of ath10k on boot with
> QCA61X4.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

Thanks, applied.

-- 
Kalle Valo
