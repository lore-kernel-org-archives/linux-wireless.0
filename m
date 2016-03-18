Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:18563 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751229AbcCRHyv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Mar 2016 03:54:51 -0400
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: Raja Mani <rmani@qti.qualcomm.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: free cached fw bin contents when get board id
 fails
Date: Fri, 18 Mar 2016 07:54:46 +0000
Message-ID: <87a8lwi5kq.fsf@kamboji.qca.qualcomm.com> (sfid-20160318_085454_562798_4A469D79)
References: <1457585707-11344-1-git-send-email-rmani@qti.qualcomm.com>
In-Reply-To: <1457585707-11344-1-git-send-email-rmani@qti.qualcomm.com> (Raja
	Mani's message of "Thu, 10 Mar 2016 10:25:07 +0530")
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Raja Mani <rmani@qti.qualcomm.com> writes:

> ath10k_core_probe_fw() simply returns error without freeing
> cached firmware file content when get board id operation fails.
> Free cached fw bin data in failure case to avoid memory leak.
>
> Fixes: db0984e51a18 ("ath10k: select board data based on BMI chip id and board id")
> Signed-off-by: Raja Mani <rmani@qti.qualcomm.com>

Applied, thanks.

-- 
Kalle Valo