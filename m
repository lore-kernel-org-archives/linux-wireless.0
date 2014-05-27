Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:60524 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751684AbaE0J31 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 May 2014 05:29:27 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 0/5] ath10k: recovery fixes 2014-05-09
References: <1399637749-13489-1-git-send-email-michal.kazior@tieto.com>
	<1400143324-14911-1-git-send-email-michal.kazior@tieto.com>
Date: Tue, 27 May 2014 12:29:19 +0300
In-Reply-To: <1400143324-14911-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Thu, 15 May 2014 10:41:59 +0200")
Message-ID: <87sinvbmds.fsf@kamboji.qca.qualcomm.com> (sfid-20140527_112930_743111_0050105A)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> Hi,
>
> Here's is a bunch of fixes for recovery/hw
> restart. This notably fixes a bug Ben has hit some
> time ago.
>
> I also have some improvements for recovery code as
> well in a follow up patchset that I'll be sending
> separately.
>
> v2:
>  * minor code style adjustments
>  * extra comment
>  * sanity check in wep key worker
>
>
> Michal Kazior (5):
>   ath10k: clean up start() callback
>   ath10k: perform hw restart lazily
>   ath10k: drain tx before restarting hw
>   ath10k: protect wep tx key setup
>   ath10k: dont configure bssid for ap mode

Thanks, all five patches applied.

-- 
Kalle Valo
