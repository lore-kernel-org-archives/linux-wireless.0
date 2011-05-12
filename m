Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog104.obsmtp.com ([74.125.149.73]:35803 "EHLO
	na3sys009aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758705Ab1ELVSQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 May 2011 17:18:16 -0400
Received: by eya28 with SMTP id 28so807353eya.21
        for <linux-wireless@vger.kernel.org>; Thu, 12 May 2011 14:18:13 -0700 (PDT)
Subject: Re: [PATCH] wl12xx: Add Notification to 80211h support
From: Luciano Coelho <coelho@ti.com>
To: Shahar Levi <shahar_levi@ti.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1305105176-12427-1-git-send-email-shahar_levi@ti.com>
References: <1305105176-12427-1-git-send-email-shahar_levi@ti.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 13 May 2011 00:18:08 +0300
Message-ID: <1305235089.12586.1058.camel@cumari> (sfid-20110512_231819_436339_B9D40487)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-05-11 at 12:12 +0300, Shahar Levi wrote:
> Set Spectrum Management Bit in association request in
> order to support 80211h spec
> 
> Signed-off-by: Shahar Levi <shahar_levi@ti.com>
> ---
>  drivers/net/wireless/wl12xx/main.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
> index 7126506..2618a57 100644
> --- a/drivers/net/wireless/wl12xx/main.c
> +++ b/drivers/net/wireless/wl12xx/main.c
> @@ -3536,6 +3536,7 @@ int wl1271_init_ieee80211(struct wl1271 *wl)
>  		IEEE80211_HW_CONNECTION_MONITOR |
>  		IEEE80211_HW_SUPPORTS_CQM_RSSI |
>  		IEEE80211_HW_REPORTS_TX_ACK_STATUS |
> +		IEEE80211_HW_SPECTRUM_MGMT |
>  		IEEE80211_HW_AP_LINK_PS;
>  
>  	wl->hw->wiphy->cipher_suites = cipher_suites;

Modified commit subject and message and applied.  Thanks, Shahar!

-- 
Cheers,
Luca.

