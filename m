Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:58545 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751446Ab1H3JBg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Aug 2011 05:01:36 -0400
Received: by wwf5 with SMTP id 5so6575479wwf.1
        for <linux-wireless@vger.kernel.org>; Tue, 30 Aug 2011 02:01:35 -0700 (PDT)
From: Florian Fainelli <florian@openwrt.org>
To: "Luis R. Rodriguez" <lrodriguez@qca.qualcomm.com>
Subject: Re: [PATCH] ath9k: add missing AR9340 in ath_mac_bb_names
Date: Tue, 30 Aug 2011 11:01:27 +0200
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	nbd@openwrt.org
References: <201108252133.48605.florian@openwrt.org>
In-Reply-To: <201108252133.48605.florian@openwrt.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201108301101.27843.florian@openwrt.org> (sfid-20110830_110146_413653_AF21BEAB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luis, John,

On Thursday 25 August 2011 21:33:48 Florian Fainelli wrote:
> AR9340 is not listed in ath_mac_bb_names, which leads to such a message:
> ieee80211 phy0: Atheros AR???? Rev:0 mem=0xb8100000, irq=2
> 
> Signed-off-by: Florian Fainelli <florian@openwrt.org>

Can you pick this up? Thanks.

> ---
> diff --git a/drivers/net/wireless/ath/ath9k/hw.c
> b/drivers/net/wireless/ath/ath9k/hw.c index 88100cc..18394d1 100644
> --- a/drivers/net/wireless/ath/ath9k/hw.c
> +++ b/drivers/net/wireless/ath/ath9k/hw.c
> @@ -2753,6 +2753,7 @@ static struct {
>  	{ AR_SREV_VERSION_9271,         "9271" },
>  	{ AR_SREV_VERSION_9300,         "9300" },
>  	{ AR_SREV_VERSION_9330,         "9330" },
> +	{ AR_SREV_VERSION_9340,		"9340" },
>  	{ AR_SREV_VERSION_9485,         "9485" },
>  };

-- 
Florian
