Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:42323 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759387Ab1FQP0P (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Jun 2011 11:26:15 -0400
Received: by vws1 with SMTP id 1so2019559vws.19
        for <linux-wireless@vger.kernel.org>; Fri, 17 Jun 2011 08:26:14 -0700 (PDT)
Message-ID: <4DFB7212.6020505@lwfinger.net> (sfid-20110617_172618_487843_E839C67F)
Date: Fri, 17 Jun 2011 10:26:10 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Mike McCormack <mikem@ring3k.org>
CC: chaoming_li@realsil.com.cn, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 3/4] rtlwifi: rtl8192cu: Remove unused parameter
References: <4DF93ED6.4000208@ring3k.org>
In-Reply-To: <4DF93ED6.4000208@ring3k.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/15/2011 06:23 PM, Mike McCormack wrote:
> rtl_ps_set_rf_state's protect_or_not parameter is not set to
> true anywhere, except for commented out code.
>
> It enables some legacy locking code, which is no longer used,
> so delete the parameter and the old locking code.
>
> Signed-off-by: Mike McCormack<mikem@ring3k.org>
> ---
>   drivers/net/wireless/rtlwifi/ps.c           |   63 ++-------------------------
>   drivers/net/wireless/rtlwifi/ps.h           |    3 +-
>   drivers/net/wireless/rtlwifi/rtl8192se/hw.c |    3 +-
>   3 files changed, 7 insertions(+), 62 deletions(-)

ACKed-by: Larry Finger <Larry.Finger@lwfinger.net>

