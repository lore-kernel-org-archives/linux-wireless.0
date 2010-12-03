Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:35433 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752689Ab0LCGfs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Dec 2010 01:35:48 -0500
Received: by qyk12 with SMTP id 12so11299364qyk.19
        for <linux-wireless@vger.kernel.org>; Thu, 02 Dec 2010 22:35:48 -0800 (PST)
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <20101203041109.GE2988@makis.mantri>
References: <20101203041109.GE2988@makis.mantri>
Date: Fri, 3 Dec 2010 07:35:46 +0100
Message-ID: <AANLkTi=pUHsMqGppFKJRSmci8FGQQeFaH2Lj0Cyr2CQ9@mail.gmail.com>
Subject: Re: [PATCH 5/6] ath5k: Update version string
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, me@bobcopeland.com, mcgrof@gmail.com,
	jirislaby@gmail.com, nbd@openwrt.org, br1@einfach.org,
	sedat.dilek@googlemail.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Tested-by: Sedat Dilek <sedat.dilek@gmail.com>

On Fri, Dec 3, 2010 at 5:11 AM, Nick Kossifidis <mickflemm@gmail.com> wrote:
>  * Change version number, we've added various new features lately.
>  We need to find a way to maintain this, maybe on each kernel release
>  or something. Also remove "EXPERIMENTAL", we aren't experimental any
>  more I think ;-)
>
>  Signed-off-by: Nick Kossifidis <mickflemm@gmail.com>
>
> ---
>  drivers/net/wireless/ath/ath5k/base.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
> index 6edfa9f..835ab3a 100644
> --- a/drivers/net/wireless/ath/ath5k/base.c
> +++ b/drivers/net/wireless/ath/ath5k/base.c
> @@ -78,7 +78,7 @@ MODULE_AUTHOR("Nick Kossifidis");
>  MODULE_DESCRIPTION("Support for 5xxx series of Atheros 802.11 wireless LAN cards.");
>  MODULE_SUPPORTED_DEVICE("Atheros 5xxx WLAN cards");
>  MODULE_LICENSE("Dual BSD/GPL");
> -MODULE_VERSION("0.6.0 (EXPERIMENTAL)");
> +MODULE_VERSION("0.7.0");
>
>  static int ath5k_reset(struct ath5k_softc *sc, struct ieee80211_channel *chan,
>                                                                bool skip_pcu);
>
