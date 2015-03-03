Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:43466 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751369AbbCCNrs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Mar 2015 08:47:48 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: [1/6] ath9k: Remove useless return value check
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1425191029-13667-2-git-send-email-sujith@msujith.org>
To: Sujith Manoharan <sujith@msujith.org>
Cc: linux-wireless@vger.kernel.org
Message-Id: <20150303134748.44D53140CCF@smtp.codeaurora.org> (sfid-20150303_144752_050923_ED0B716F)
Date: Tue,  3 Mar 2015 13:47:48 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
> 
> ath_init_btcoex_timer() always returns 0, so
> checking for error conditions is not required.
> 
> Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Thanks, 6 patches applied to wireless-drivers-next.git:

44b9b56e5095 ath9k: Remove useless return value check
510baea1e46d ath9k: Initialize MCI state correctly
e1ff147d878a ath9k: Fix MCI scheme initialization
30b818989100 ath9k: Fix wlan-active gpio for the AR9003 family
c7266e99b1b0 ath9k: Handle timers for MCI
6e6dd08dd320 ath9k: Fix issues in the main btcoex timer

Kalle Valo
