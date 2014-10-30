Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dedo.coelho.fi ([88.198.205.34]:51177 "EHLO dedo.coelho.fi"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758611AbaJ3LIr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Oct 2014 07:08:47 -0400
Message-ID: <1414667312.27833.22.camel@coelho.fi> (sfid-20141030_120850_842704_3141D8F2)
From: Luca Coelho <luca@coelho.fi>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org,
	Murilo Opsfelder Araujo <mopsfelder@gmail.com>
Date: Thu, 30 Oct 2014 13:08:32 +0200
In-Reply-To: <1414642633-3700-1-git-send-email-Larry.Finger@lwfinger.net>
References: <1414642633-3700-1-git-send-email-Larry.Finger@lwfinger.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: [PATCH 0/6 3.18] Fixes for iwlwifi drivers
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The cover-letter subject is wrong. :) I guess you meant
s/iwlwifi/rtlwifi/ ;)

--
Luca.

On Wed, 2014-10-29 at 23:17 -0500, Larry Finger wrote:
> Some late changes to rtlwifi made some of the older drivers not start correctly.
> These patches should be applied to 3.18.
> 
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> Cc: Murilo Opsfelder Araujo <mopsfelder@gmail.com>
> 
> Larry Finger (6):
>   rtlwifi: rtl8192ce: rtl8192de: rtl8192se: Fix handling for missing
>     get_btc_status
>   rtlwifi: rtl8192se: Fix duplicate calls to ieee80211_register_hw()
>   rtlwifi: rtl8192se: Add missing section to read descriptor setting
>   rtlwifi: rtl8192ce: Add missing section to read descriptor setting
>   rtlwifi: rtl8821ae: Remove extra semicolons
>   rtlwifi: rtl8192se: Fix firmware loading
> 
>  drivers/net/wireless/rtlwifi/core.c          |  6 ++++++
>  drivers/net/wireless/rtlwifi/core.h          |  1 +
>  drivers/net/wireless/rtlwifi/rtl8192ce/def.h |  2 ++
>  drivers/net/wireless/rtlwifi/rtl8192ce/sw.c  |  1 +
>  drivers/net/wireless/rtlwifi/rtl8192ce/trx.c |  3 +++
>  drivers/net/wireless/rtlwifi/rtl8192de/sw.c  |  1 +
>  drivers/net/wireless/rtlwifi/rtl8192se/def.h |  2 ++
>  drivers/net/wireless/rtlwifi/rtl8192se/sw.c  | 22 +++-------------------
>  drivers/net/wireless/rtlwifi/rtl8192se/trx.c |  3 +++
>  drivers/net/wireless/rtlwifi/rtl8821ae/phy.c | 12 ++++++------
>  10 files changed, 28 insertions(+), 25 deletions(-)
> 


