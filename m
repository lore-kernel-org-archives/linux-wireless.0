Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:61582 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752215AbcCKMTl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Mar 2016 07:19:41 -0500
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: "miaoqing@codeaurora.org" <miaoqing@codeaurora.org>
CC: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	ath9k-devel <ath9k-devel@qca.qualcomm.com>
Subject: Re: [PATCH v4 0/8] ath9k GPIO & BT-Coex bug fixes
Date: Fri, 11 Mar 2016 12:19:35 +0000
Message-ID: <87vb4tmcko.fsf@kamboji.qca.qualcomm.com> (sfid-20160311_131944_345686_89A41F1E)
References: <1457318301-27701-1-git-send-email-miaoqing@codeaurora.org>
In-Reply-To: <1457318301-27701-1-git-send-email-miaoqing@codeaurora.org>
	(miaoqing@codeaurora.org's message of "Mon, 7 Mar 2016 10:38:13	+0800")
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

miaoqing@codeaurora.org writes:

> From: Miaoqing Pan <miaoqing@codeaurora.org>
>
> ath9k GPIO & BT-Coex bug fixes.
>
> Notes:
>     v2: fix build warning
>     v3: move changelog to cover letter
>     v4: fix [5/8] comments
>
> Miaoqing Pan (8):
>   ath9k: define correct GPIO numbers and bits mask
>   ath9k: make GPIO API to support both of WMAC and SOC
>   ath9k: free GPIO resource for SOC GPIOs
>   ath9k: cleanup led_pin initial
>   ath9k: Allow platform override BTCoex pin
>   ath9k: add bits definition of BTCoex MODE2/3 for SOC chips
>   ath9k: fix BTCoex access invalid registers for SOC chips
>   ath9k: fix BTCoex configuration for SOC chips

Applied to ath.git, thanks.

-- 
Kalle Valo