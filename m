Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:13888 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750823AbaHZQHu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Aug 2014 12:07:50 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2] ath10k: improve logging to include dev id
References: <1408961378-1390-1-git-send-email-michal.kazior@tieto.com>
Date: Tue, 26 Aug 2014 19:07:44 +0300
In-Reply-To: <1408961378-1390-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Mon, 25 Aug 2014 12:09:38 +0200")
Message-ID: <87ha0z1bfz.fsf@kamboji.qca.qualcomm.com> (sfid-20140826_180757_531872_2F9D29DD)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> This makes it a lot easier to log and debug
> messages if there's more than 1 ath10k device on a
> system.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
> ---
>
> Notes:
>     v2:
>      * rebased on latest master branch
>      * move "pci probe" debug print after core is allocated [Kalle]

Thanks, applied. I just folded the patch to fix the smatch warning about
ret variable.

-- 
Kalle Valo
