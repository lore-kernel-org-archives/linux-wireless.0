Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:4834 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751101AbaK0Mve (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Nov 2014 07:51:34 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/3] ath10k: remove unused callback argument
References: <1417082978-1701-1-git-send-email-michal.kazior@tieto.com>
Date: Thu, 27 Nov 2014 14:51:28 +0200
In-Reply-To: <1417082978-1701-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Thu, 27 Nov 2014 11:09:36 +0100")
Message-ID: <87tx1ku7qn.fsf@kamboji.qca.qualcomm.com> (sfid-20141127_135140_152608_435A16E3)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> This wasn't used since forever and there are no
> plans on using it.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

I modified the title to get it more unique:

ath10k: remove unused callback argument from struct ath10k_hif_cb::rx_completion

-- 
Kalle Valo
