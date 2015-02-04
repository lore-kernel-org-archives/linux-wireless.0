Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:14205 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751483AbbBDHSM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Feb 2015 02:18:12 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 1/2] ath10k: change dma beacon cmd prototype
References: <1421412811-6387-1-git-send-email-michal.kazior@tieto.com>
	<1422440525-11115-1-git-send-email-michal.kazior@tieto.com>
Date: Wed, 4 Feb 2015 09:18:01 +0200
In-Reply-To: <1422440525-11115-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Wed, 28 Jan 2015 11:22:04 +0100")
Message-ID: <87a90uw3fa.fsf@kamboji.qca.qualcomm.com> (sfid-20150204_081815_598221_C9FA425A)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> The command logic shouldn't really care about
> arvif structure.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

Thanks, both patches applied to ath.git.

-- 
Kalle Valo
