Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:40582 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751535AbbCCM5x (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Mar 2015 07:57:53 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: [1/9] ath9k: Move MCI registers to reg_mci.h
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1424064001-7009-2-git-send-email-sujith@msujith.org>
To: Sujith Manoharan <sujith@msujith.org>
Cc: linux-wireless@vger.kernel.org
Message-Id: <20150303125752.94EE61407AE@smtp.codeaurora.org> (sfid-20150303_135757_522337_83D71854)
Date: Tue,  3 Mar 2015 12:57:52 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
> 
> Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Thanks, 9 patches applied to wireless-drivers-next.git:

ae55099f5b6f ath9k: Move MCI registers to reg_mci.h
7d1805e194dc ath9k: Remove useless check in MCI reset
d1d07813bb3e ath9k: Add new MCI configuration parameters
e18e164e9af5 ath9k: Handle 2-ANT AR9565 in MCI reset
d808ecd8743c ath9k: Fix MCI TX control
4d9f7c68b78d ath9k: Setup MCI statistics properly
bc80d526d302 ath9k: Prepare MCI interface correctly
ad1dc638725d ath9k: Fix GPM initialization
2f890caba6dd ath9k: Mute BT properly

Kalle Valo
