Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:23222 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966015AbcCPKWn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Mar 2016 06:22:43 -0400
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: "Shajakhan, Mohammed Shafi (Mohammed Shafi)"
	<mohammed@qti.qualcomm.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	"mohammed@codeaurora.org" <mohammed@codeaurora.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 2/2] ath10k: Enable parsing per station rx duration for
 10.4
Date: Wed, 16 Mar 2016 10:22:22 +0000
Message-ID: <87d1qulo2r.fsf@kamboji.qca.qualcomm.com> (sfid-20160316_112246_523255_E77EE822)
References: <1458052250-2529-1-git-send-email-mohammed@qca.qualcomm.com>
	<1458052250-2529-3-git-send-email-mohammed@qca.qualcomm.com>
In-Reply-To: <1458052250-2529-3-git-send-email-mohammed@qca.qualcomm.com>
	(Mohammed Shafi Shajakhan's message of "Tue, 15 Mar 2016 20:00:50	+0530")
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com> writes:

> From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
>
> Rx duration support for per station is part of extended peer
> stats, enable provision to parse the same and provide backward
> compatibility based on the 'stats_id' event
>
> Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>

After fixing patch 1 this doesn't compile either. Please fix and resend
both patches.

drivers/net/wireless/ath/ath10k/core.c: In function 'ath10k_core_start':
drivers/net/wireless/ath/ath10k/core.c:1787:3: error: implicit
declaration of function 'ath10k_peer_stats_enabled'
[-Werror=implicit-function-declaration]
cc1: some warnings being treated as errors

-- 
Kalle Valo