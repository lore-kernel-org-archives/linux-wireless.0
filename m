Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:44768 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753565AbaARInx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Jan 2014 03:43:53 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: bitrate_mask add force_sgi support
References: <1389985454-3997-1-git-send-email-janusz.dziedzic@tieto.com>
Date: Sat, 18 Jan 2014 10:43:48 +0200
In-Reply-To: <1389985454-3997-1-git-send-email-janusz.dziedzic@tieto.com>
	(Janusz Dziedzic's message of "Fri, 17 Jan 2014 20:04:14 +0100")
Message-ID: <87r485ptmj.fsf@kamboji.qca.qualcomm.com> (sfid-20140118_094357_969953_4AED0B1C)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Janusz Dziedzic <janusz.dziedzic@tieto.com> writes:

> Add force SGI support.
>
> Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>

Thanks, the patch looks good.

> depends on, nl80211: add Guard Interval support for set_bitrate_mask

But I can only apply this only once the dependency patch goes to
wireless-next, so I'll keep this in my pending queue until that happens.
Most likely we need to wait for the merge window to close.

-- 
Kalle Valo
