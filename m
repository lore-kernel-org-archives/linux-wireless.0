Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:33448 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752685AbbAWRBY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jan 2015 12:01:24 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: [1/5] ath9k: Fix no-ack frame status
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1418951039-12309-2-git-send-email-sujith@msujith.org>
To: Sujith Manoharan <sujith@msujith.org>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
Message-Id: <20150123170124.4638B1411FD@smtp.codeaurora.org> (sfid-20150123_180127_640055_B4237542)
Date: Fri, 23 Jan 2015 17:01:24 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
> 
> Check if the frame has been completed without any
> error and use IEEE80211_TX_STAT_NOACK_TRANSMITTED to
> indicate successful transmission of no-ack frames.
> 
> Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Thanks, applied to wireless-drivers-next.git.

Kalle Valo
