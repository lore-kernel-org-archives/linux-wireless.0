Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:59592 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751248AbcCAM6T convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Mar 2016 07:58:19 -0500
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: "miaoqing@codeaurora.org" <miaoqing@codeaurora.org>
CC: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	ath9k-devel <ath9k-devel@qca.qualcomm.com>
Subject: Re: [PATCH v2 2/8] ath9k: make GPIO API to support both of WMAC and
 SOC
Date: Tue, 1 Mar 2016 12:58:02 +0000
Message-ID: <87bn6y73tz.fsf@kamboji.qca.qualcomm.com> (sfid-20160301_135822_365783_23F58784)
References: <1456813784-21218-1-git-send-email-miaoqing@codeaurora.org>
	<1456813784-21218-3-git-send-email-miaoqing@codeaurora.org>
In-Reply-To: <1456813784-21218-3-git-send-email-miaoqing@codeaurora.org>
	(miaoqing@codeaurora.org's message of "Tue, 1 Mar 2016 14:29:38	+0800")
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

<miaoqing@codeaurora.org> writes:

> From: Miaoqing Pan <miaoqing@codeaurora.org>
>
> commit 61b559dea40e ("ath9k: add extra GPIO led support")
> added ath9k to support access SOC's GPIOs, but implemented
> in a separated API: ath9k_hw_request_gpio().
>
> So this patch make the APIs more common, to support both
> of WMAC and SOC GPIOs. The new APIs as below,
>
> void ath9k_hw_gpio_request_in();
> void ath9k_hw_gpio_request_out();
> void ath9k_hw_gpio_free();
>
> NOTE, the BSP of the SOC chips(AR9340, AR9531, AR9550, AR9561)
> should set the corresponding MUX registers correctly.
>
> Signed-off-by: Miaoqing Pan <miaoqing@codeaurora.org>
>
> Notes:
>     v2: fix build warning
> ---

The changelog needs to be after "---" line, or even better if it's in
the cover letter.

-- 
Kalle Valo