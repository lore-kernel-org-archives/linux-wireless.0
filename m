Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-sn1nam01on0086.outbound.protection.outlook.com ([104.47.32.86]:32780
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751625AbdJBPek (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 2 Oct 2017 11:34:40 -0400
Date: Mon, 2 Oct 2017 18:34:29 +0300
From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] nl80211: look for HT/VHT capabilities in beacon's tail
Message-ID: <20171002153428.dhh47qlza7agrru4@bars> (sfid-20171002_173451_505508_D23935DF)
References: <20170830205225.17228-1-igor.mitsyanko.os@quantenna.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170830205225.17228-1-igor.mitsyanko.os@quantenna.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 30, 2017 at 01:52:25PM -0700, igor.mitsyanko.os@quantenna.com wrote:

> There are no HT/VHT capabilities in cfg80211_ap_settings::beacon_ies,
> these should be looked for in beacon's tail instead.
> 
> Signed-off-by: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
> ---
> 
> This is true for hostapd (at least the one in mainline): it does not
> include HT/VHT caps and WLAN_EID_SUPP_RATES into beacon_ies.
> But worth noting that there is no clear documentation that I could find
> on what IEs could and could not be included into beacon_ies.
> 
>  net/wireless/nl80211.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Hello Johannes,

Any comments on this change ?

Regards,
Sergey
