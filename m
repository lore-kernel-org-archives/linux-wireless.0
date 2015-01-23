Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:46642 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755895AbbAWUGm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jan 2015 15:06:42 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org, Troy Tan <troy_tan@realsil.com.cn>,
	netdev@vger.kernel.org
Subject: Re: [PATCH 3/6] rtlwifi: btcoexist: Add routines for RTL8812AE with single antenna
References: <1422033044-7461-1-git-send-email-Larry.Finger@lwfinger.net>
	<1422033044-7461-4-git-send-email-Larry.Finger@lwfinger.net>
Date: Fri, 23 Jan 2015 22:06:35 +0200
In-Reply-To: <1422033044-7461-4-git-send-email-Larry.Finger@lwfinger.net>
	(Larry Finger's message of "Fri, 23 Jan 2015 11:10:41 -0600")
Message-ID: <87r3uljm7o.fsf@kamboji.qca.qualcomm.com> (sfid-20150123_210649_507648_E7F1B89F)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger <Larry.Finger@lwfinger.net> writes:

> From: Troy Tan <troy_tan@realsil.com.cn>
>
> The RTL8812AE needs different BT coexistence routines than does the
> RTL8821AE. This patch adds the necessary routines for devices with a
> single antenna.
>
> Signed-off-by: Troy Tan <troy_tan@realsil.com.cn>
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> ---
>  .../wireless/rtlwifi/btcoexist/halbtc8812a1ant.c   | 2073 ++++++++++++++++++++
>  .../wireless/rtlwifi/btcoexist/halbtc8812a1ant.h   |  152 ++
>  2 files changed, 2225 insertions(+)
>  create mode 100644 drivers/net/wireless/rtlwifi/btcoexist/halbtc8812a1ant.c
>  create mode 100644 drivers/net/wireless/rtlwifi/btcoexist/halbtc8812a1ant.h
>
> diff --git a/drivers/net/wireless/rtlwifi/btcoexist/halbtc8812a1ant.c b/drivers/net/wireless/rtlwifi/btcoexist/halbtc8812a1ant.c
> new file mode 100644
> index 0000000..11ae66b
> --- /dev/null
> +++ b/drivers/net/wireless/rtlwifi/btcoexist/halbtc8812a1ant.c
> @@ -0,0 +1,2073 @@
> +/*  */
> +/*  Description: */
> +/*  */
> +/*  This file is for 8812a1ant Co-exist mechanism */
> +/*  */
> +/*  History */
> +/*  2012/11/15 Cosa first check in. */
> +/*  */
> +/*  */
> +
> +/*  */
> +/*  include files */
> +/*  */

One problem I see is that there's no license on either of the files. It
would be much better if the files had that.

-- 
Kalle Valo
