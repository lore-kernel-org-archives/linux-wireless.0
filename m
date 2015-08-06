Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:51333 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752956AbbHFHLy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Aug 2015 03:11:54 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: [v3,1/4] ath9k: advertise p2p dev support when chanctx
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1437469903-32362-1-git-send-email-janusz.dziedzic@tieto.com>
To: Janusz.Dziedzic@tieto.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	nbd@openwrt.org, sujith@msujith.org,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Message-Id: <20150806071154.5BF26141F57@smtp.codeaurora.org> (sfid-20150806_091157_059444_3F40C915)
Date: Thu,  6 Aug 2015 07:11:54 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> Advertise p2p device support when ath9k loaded with
> use_chanctx=1.
> 
> This will fix problem, when first interface is an AP
> and next we would like to run p2p_find.
> Before p2p find (scan phase) failed with EOPNOTSUPP.
> 
> Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>

Thanks, 4 patches applied to wireless-drivers-next.git:

eb61f9f623f7 ath9k: advertise p2p dev support when chanctx
d83520b7cd6e ath9k: handle RoC cancel correctly
f3771c08282a ath9k: setup rxfilter for all chanctx
1738203ee729 ath9k: setup rxfilter when offchannel

Kalle Valo
