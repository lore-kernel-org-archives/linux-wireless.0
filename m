Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:12515 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751824AbaBMP4l (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Feb 2014 10:56:41 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: pass frames with invalid peer status to upper layer
References: <1392107579-4289-1-git-send-email-janusz.dziedzic@tieto.com>
Date: Thu, 13 Feb 2014 17:56:34 +0200
In-Reply-To: <1392107579-4289-1-git-send-email-janusz.dziedzic@tieto.com>
	(Janusz Dziedzic's message of "Tue, 11 Feb 2014 09:32:59 +0100")
Message-ID: <87zjlv6m6l.fsf@kamboji.qca.qualcomm.com> (sfid-20140213_165649_976134_4B590716)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Janusz Dziedzic <janusz.dziedzic@tieto.com> writes:

> Pass frames with invalid peer status to upper layer.
> Next mac80211 will validate frames and drop if required.
> This is required to detect spurious frames and pass
> this info to user mode (detect CLASS2 CLASS3 frames from
> nonauthenticated/nonassociated stations).
>
> Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>

Thanks, applied.

-- 
Kalle Valo
