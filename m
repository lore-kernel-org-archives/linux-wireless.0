Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:51145 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750830AbbGKQwh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 11 Jul 2015 12:52:37 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: ath9k: DFS - add pulse chirp detection for FCC
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1434451936-8545-1-git-send-email-zefir.kurtisi@neratec.com>
To: Zefir Kurtisi <zefir.kurtisi@neratec.com>
Cc: linux-wireless@vger.kernel.org, poh@qca.qualcomm.com,
	ath9k-devel@venema.h4ckr.net,
	Zefir Kurtisi <zefir.kurtisi@neratec.com>
Message-Id: <20150711165237.57D4513F6AC@smtp.codeaurora.org> (sfid-20150711_185240_332944_01D051BD)
Date: Sat, 11 Jul 2015 16:52:37 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> FCC long pulse radar (type 5) requires pulses to be
> checked for chirping. This patch implements chirp
> detection based on the FFT data provided for long
> pulses.
> 
> A chirp is detected when a set of criteria defined
> by FCC pulse characteristics is met, including
> * have at least 4 FFT samples
> * max_bin index moves equidistantly between samples
> * the gradient is within defined range
> 
> The chirp detection has been tested with reference
> radar generating devices and proved to work reliably.
> 
> Signed-off-by: Zefir Kurtisi <zefir.kurtisi@neratec.com>

Thanks, applied to wireless-drivers-next.git.

Kalle Valo
