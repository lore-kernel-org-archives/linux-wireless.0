Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:60994 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754218AbbHJTWO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Aug 2015 15:22:14 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: [1/1] ath: Make ath_opmode_to_string understand OCB mode
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1438609541-24239-1-git-send-email-bertold.vandenbergh@esat.kuleuven.be>
To: Bertold Van den Bergh <bertold.vandenbergh@esat.kuleuven.be>
Cc: mcgrof@do-not-panic.com, linux-wireless@vger.kernel.org,
	Bertold Van den Bergh <bertold.vandenbergh@esat.kuleuven.be>
Message-Id: <20150810192213.C67FC1411B4@smtp.codeaurora.org> (sfid-20150810_212217_660890_CC338D6A)
Date: Mon, 10 Aug 2015 19:22:13 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> Make ath_opmode_to_string return "OCB" for NL80211_IFTYPE_OCB. Currently
> it will return "UNKNOWN".
> 
> Signed-off-by: Bertold Van den Bergh <bertold.vandenbergh@esat.kuleuven.be>

Thanks, applied to wireless-drivers-next.git.

Kalle Valo
