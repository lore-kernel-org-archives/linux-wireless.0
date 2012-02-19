Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bues.ch ([80.190.117.144]:49369 "EHLO bues.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753431Ab2BSStx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Feb 2012 13:49:53 -0500
Date: Sun, 19 Feb 2012 19:49:23 +0100
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linville@tuxdriver.com, zajec5@gmail.com,
	b43-dev@lists.infradead.org, linux-mips@linux-mips.org,
	linux-wireless@vger.kernel.org, arend@broadcom.com
Subject: Re: [PATCH 04/11] ssb: add ccode
Message-ID: <20120219194923.566f3fe8@milhouse> (sfid-20120219_194956_338861_6501704F)
In-Reply-To: <1329676345-15856-5-git-send-email-hauke@hauke-m.de>
References: <1329676345-15856-1-git-send-email-hauke@hauke-m.de>
	<1329676345-15856-5-git-send-email-hauke@hauke-m.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 19 Feb 2012 19:32:18 +0100
Hauke Mehrtens <hauke@hauke-m.de> wrote:

> This member contains the country code encoded with two chars
> 
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
> ---
>  include/linux/ssb/ssb.h |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/ssb/ssb.h b/include/linux/ssb/ssb.h
> index 4928419..44e486e 100644
> --- a/include/linux/ssb/ssb.h
> +++ b/include/linux/ssb/ssb.h
> @@ -33,6 +33,7 @@ struct ssb_sprom {
>  	u8 et1mdcport;		/* MDIO for enet1 */
>  	u16 board_rev;		/* Board revision number from SPROM. */
>  	u8 country_code;	/* Country Code */
> +	char ccode[2];		/* Country Code as two chars like EU or US */

This usually is referred to as "alpha2". So we should name it like that, too.

>  	u8 leddc_on_time;	/* LED Powersave Duty Cycle On Count */
>  	u8 leddc_off_time;	/* LED Powersave Duty Cycle Off Count */
>  	u8 ant_available_a;	/* 2GHz antenna available bits (up to 4) */



-- 
Greetings, Michael.
