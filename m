Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51251 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753085Ab1KCBPk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Nov 2011 21:15:40 -0400
Subject: Re: [PATCH] ieee80211: Define cipher suite selector for WPI-SMS4
From: Dan Williams <dcbw@redhat.com>
To: Jouni Malinen <jouni@qca.qualcomm.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Date: Wed, 02 Nov 2011 20:15:52 -0500
In-Reply-To: <20111102213456.GA21460@jouni.qca.qualcomm.com>
References: <20111102213456.GA21460@jouni.qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Message-ID: <1320282954.20617.1.camel@dcbw.foobar.com> (sfid-20111103_021545_085394_28C95151)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-11-02 at 23:34 +0200, Jouni Malinen wrote:
> This value is used for WPI-SMS4 in ISO/IEC JTC 1 N 9880.

Does that mean WAPI at some point? :)

> Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
> ---
>  include/linux/ieee80211.h |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
> index 48363c3..80cba03 100644
> --- a/include/linux/ieee80211.h
> +++ b/include/linux/ieee80211.h
> @@ -1552,6 +1552,8 @@ enum ieee80211_sa_query_action {
>  #define WLAN_CIPHER_SUITE_WEP104	0x000FAC05
>  #define WLAN_CIPHER_SUITE_AES_CMAC	0x000FAC06
>  
> +#define WLAN_CIPHER_SUITE_SMS4		0x00147201
> +
>  /* AKM suite selectors */
>  #define WLAN_AKM_SUITE_8021X		0x000FAC01
>  #define WLAN_AKM_SUITE_PSK		0x000FAC02
> -- 
> 1.7.4.1
> 
> 


