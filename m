Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:8036 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752855AbbA0OUs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Jan 2015 09:20:48 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: fix nullfunc workaround
References: <1421673177-2245-1-git-send-email-michal.kazior@tieto.com>
Date: Tue, 27 Jan 2015 16:20:39 +0200
In-Reply-To: <1421673177-2245-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Mon, 19 Jan 2015 14:12:57 +0100")
Message-ID: <87iofsb8zs.fsf@kamboji.qca.qualcomm.com> (sfid-20150127_152051_367251_40180CA8)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> The workaround couldn't work correctly because the
> 802.11 header wasn't properly stripped of QoS Data
> bit so it wasn't recognized in the later parts of
> tx path as NullFunc frame and ended up in HTT Tx
> instead of HTT Mgmt Tx.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

Thanks, applied to ath.git.

-- 
Kalle Valo
