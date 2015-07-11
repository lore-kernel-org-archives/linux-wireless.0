Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:51124 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750977AbbGKQvn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 11 Jul 2015 12:51:43 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: ath9k: DFS - consider ext_channel pulses only in HT40 mode
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1434448002-4409-1-git-send-email-zefir.kurtisi@neratec.com>
To: Zefir Kurtisi <zefir.kurtisi@neratec.com>
Cc: linux-wireless@vger.kernel.org, poh@qca.qualcomm.com,
	ath9k-devel@venema.h4ckr.net,
	Zefir Kurtisi <zefir.kurtisi@neratec.com>
Message-Id: <20150711165142.794C013F5E6@smtp.codeaurora.org> (sfid-20150711_185145_259323_8F5651BD)
Date: Sat, 11 Jul 2015 16:51:42 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> The chip reports radar pulses on extension channel
> even if operating in HT20 mode. This patch adds a
> sanity check for HT40 mode before it feeds pulses
> on extension channel to the pattern detector.
> 
> Signed-off-by: Zefir Kurtisi <zefir.kurtisi@neratec.com>

Thanks, applied to wireless-drivers-next.git.

Kalle Valo
