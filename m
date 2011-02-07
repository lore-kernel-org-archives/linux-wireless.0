Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:11253 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753345Ab1BGPK6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Feb 2011 10:10:58 -0500
Date: Mon, 7 Feb 2011 16:09:55 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: John W Linville <linville@tuxdriver.com>, george0505@realtek.com,
	chaoming_li@realsil.com.cn, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 5/6] rtlwifi: rtl8192ce: Rework rtl8192ce/phy.c
Message-ID: <20110207150954.GF2319@redhat.com>
References: <4d4eec14.NZEFs/idkaNYco3C%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4d4eec14.NZEFs/idkaNYco3C%Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Feb 06, 2011 at 12:44:36PM -0600, Larry Finger wrote:
> Make the phy.c codes for rtl8192ce and rtl8192cu be as alike as possible.
> 
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> ---
> 
> Index: wireless-testing/drivers/net/wireless/rtlwifi/rtl8192ce/phy.c
> ===================================================================
> --- wireless-testing.orig/drivers/net/wireless/rtlwifi/rtl8192ce/phy.c
> +++ wireless-testing/drivers/net/wireless/rtlwifi/rtl8192ce/phy.c
> @@ -37,6 +37,9 @@
>  #include "dm.h"
>  #include "table.h"
>  
> +/* Define macro to shorten lines */
> +#define MCS_TXPWR	mcs_txpwrlevel_origoffset

Uhh, I did not expect that. But ok. In the future, maybe
we could change struct field name?
