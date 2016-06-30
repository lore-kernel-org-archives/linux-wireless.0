Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:27055 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751547AbcF3LO1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jun 2016 07:14:27 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ath9k: Fix programming of minCCA power threshold
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1466157500-30791-1-git-send-email-sven@narfation.org>
To: Sven Eckelmann <sven@narfation.org>
CC: <ath9k-devel@lists.ath9k.org>, <linux-wireless@vger.kernel.org>,
	<ath9k-devel@qca.qualcomm.com>,
	Sven Eckelmann <sven@narfation.org>,
	"Simon Wunderlich" <sw@simonwunderlich.de>,
	Sujith Manoharan <c_manoha@qca.qualcomm.com>
Message-ID: <f91bc6ba3f164efe8935d8c7400dc19e@euamsexm01a.eu.qualcomm.com> (sfid-20160630_131430_034150_03ABEB1F)
Date: Thu, 30 Jun 2016 13:14:16 +0200
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sven Eckelmann <sven@narfation.org> wrote:
> The function ar9003_hw_apply_minccapwr_thresh takes as second parameter not
> a pointer to the channel but a boolean value describing whether the channel
> is 2.4GHz or not. This broke (according to the origin commit) the ETSI
> regulatory compliance on 5GHz channels.
> 
> Fixes: 3533bf6b15a0 ("ath9k: Fix regulatory compliance")
> Signed-off-by: Sven Eckelmann <sven@narfation.org>
> Cc: Simon Wunderlich <sw@simonwunderlich.de>
> Cc: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Thanks, 1 patch applied to ath-next branch of ath.git:

aaab50fcea78 ath9k: Fix programming of minCCA power threshold

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/9183173/

