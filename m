Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:32970 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755845AbaJHKU2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Oct 2014 06:20:28 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: warn on unhandled htt events
References: <1412249575-22387-1-git-send-email-michal.kazior@tieto.com>
Date: Wed, 8 Oct 2014 13:20:16 +0300
In-Reply-To: <1412249575-22387-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Thu, 2 Oct 2014 13:32:55 +0200")
Message-ID: <871tqihnhb.fsf@kamboji.qca.qualcomm.com> (sfid-20141008_122033_805659_C6755269)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> It makes a lot more sense to print these kinds of
> problems as a warning instead of a debug.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

Thanks, applied.

-- 
Kalle Valo
