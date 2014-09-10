Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:27910 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751283AbaIJLRd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Sep 2014 07:17:33 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: use proper service bitmap size
References: <1409818712-7493-1-git-send-email-michal.kazior@tieto.com>
Date: Wed, 10 Sep 2014 14:17:27 +0300
In-Reply-To: <1409818712-7493-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Thu, 4 Sep 2014 10:18:32 +0200")
Message-ID: <874mwf912w.fsf@kamboji.qca.qualcomm.com> (sfid-20140910_131736_693086_72676BFB)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> On 32bit systems the bitmap was too small and it
> was overwritten partially by the stat completion
> structure. This was visible with 10.2 firmware
> only due to it using a few of the last service
> ids.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

Thanks, applied.

-- 
Kalle Valo
