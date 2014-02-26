Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:45466 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751333AbaBZQiX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Feb 2014 11:38:23 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: fix 4addr rx
References: <1392796345-14272-1-git-send-email-michal.kazior@tieto.com>
Date: Wed, 26 Feb 2014 18:38:18 +0200
In-Reply-To: <1392796345-14272-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Wed, 19 Feb 2014 08:52:25 +0100")
Message-ID: <87zjldlthh.fsf@kamboji.qca.qualcomm.com> (sfid-20140226_173826_624596_EC0E30DC)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> The nwifi header is padded to 4 bytes. This wasn't
> a problem until one tried to (at least) rx 4addr
> frames.
>
> This finally allows managed iface to be used in a
> bridge.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

Thanks, applied.

-- 
Kalle Valo
