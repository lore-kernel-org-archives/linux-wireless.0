Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:53423 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753710AbaIBN3n (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Sep 2014 09:29:43 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: don't access tx_info while overwriting it
References: <1409303943-1452-1-git-send-email-michal.kazior@tieto.com>
Date: Tue, 2 Sep 2014 16:19:37 +0300
In-Reply-To: <1409303943-1452-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Fri, 29 Aug 2014 11:19:03 +0200")
Message-ID: <877g1mma6u.fsf@kamboji.qca.qualcomm.com> (sfid-20140902_152946_837352_E8D6EF11)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> Nothing important was being overwritten so it
> didn't yield any bugs yet.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

Thanks, applied.

-- 
Kalle Valo
