Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:55828 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751018AbeCTWpU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 20 Mar 2018 18:45:20 -0400
Message-ID: <1521585916.19123.3.camel@sipsolutions.net> (sfid-20180320_234523_432290_260E3B0D)
Subject: Re: [PATCH] mt76: enable MAC80211_LEDS by default
From: Johannes Berg <johannes@sipsolutions.net>
To: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>, nbd@nbd.name
Cc: linux-wireless@vger.kernel.org, arnd@arndb.de
Date: Tue, 20 Mar 2018 23:45:16 +0100
In-Reply-To: <a159566d0970fb5c43da7758d8281b594b6ca48e.1521209538.git.lorenzo.bianconi@redhat.com> (sfid-20180316_154622_034123_84A96CF1)
References: <cover.1521209538.git.lorenzo.bianconi@redhat.com>
         <a159566d0970fb5c43da7758d8281b594b6ca48e.1521209538.git.lorenzo.bianconi@redhat.com>
         (sfid-20180316_154622_034123_84A96CF1)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2018-03-16 at 15:45 +0100, Lorenzo Bianconi wrote:
> --- a/drivers/net/wireless/mediatek/mt76/Kconfig
> +++ b/drivers/net/wireless/mediatek/mt76/Kconfig
> @@ -1,5 +1,8 @@
>  config MT76_CORE
>  	tristate
> +	select MAC80211_LEDS

Should drivers really mess with mac80211's configuration that way? I
believe this is a user-visible config, no?

johannes
