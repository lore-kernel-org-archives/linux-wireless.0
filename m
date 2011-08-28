Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:63773 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750836Ab1H1Q7o (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Aug 2011 12:59:44 -0400
Received: by gwaa12 with SMTP id a12so4206252gwa.19
        for <linux-wireless@vger.kernel.org>; Sun, 28 Aug 2011 09:59:44 -0700 (PDT)
Message-ID: <4E5A73FC.4070708@lwfinger.net> (sfid-20110828_185951_144920_F13D85F8)
Date: Sun, 28 Aug 2011 11:59:40 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	b43-dev@lists.infradead.org
Subject: Re: [PATCH 1/2] ssb: use u16 for storing board rev
References: <1314550043-6220-1-git-send-email-zajec5@gmail.com>
In-Reply-To: <1314550043-6220-1-git-send-email-zajec5@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/28/2011 11:47 AM, Rafał Miłecki wrote:
> Specs say about size 2 (u16) and my 14e4:4727 has board rev 0x1211.
>
> Signed-off-by: Rafał Miłecki<zajec5@gmail.com>
> ---

ACKed-by: Larry Finger <Larry.Finger@lwfinger.net>

>   include/linux/ssb/ssb.h |    2 +-
>   1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/include/linux/ssb/ssb.h b/include/linux/ssb/ssb.h
> index 8623217..f10ed7b 100644
> --- a/include/linux/ssb/ssb.h
> +++ b/include/linux/ssb/ssb.h
> @@ -25,7 +25,7 @@ struct ssb_sprom {
>   	u8 et1phyaddr;		/* MII address for enet1 */
>   	u8 et0mdcport;		/* MDIO for enet0 */
>   	u8 et1mdcport;		/* MDIO for enet1 */
> -	u8 board_rev;		/* Board revision number from SPROM. */
> +	u16 board_rev;		/* Board revision number from SPROM. */
>   	u8 country_code;	/* Country Code */
>   	u16 leddc_on_time;	/* LED Powersave Duty Cycle On Count */
>   	u16 leddc_off_time;	/* LED Powersave Duty Cycle Off Count */

