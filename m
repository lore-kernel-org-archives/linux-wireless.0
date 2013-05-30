Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:61089 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967933Ab3E3I5c (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 May 2013 04:57:32 -0400
Received: from mailout-de.gmx.net ([10.1.76.31]) by mrigmx.server.lan
 (mrigmx001) with ESMTP (Nemesis) id 0MOmOu-1Ukhxd0cIY-0064KH for
 <linux-wireless@vger.kernel.org>; Thu, 30 May 2013 10:57:31 +0200
Message-ID: <51A71476.9070001@rempel-privat.de> (sfid-20130530_105737_792825_44A8CC6D)
Date: Thu, 30 May 2013 10:57:26 +0200
From: Oleksij Rempel <linux@rempel-privat.de>
MIME-Version: 1.0
To: Oleksij Rempel <linux@rempel-privat.de>
CC: ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org,
	Felix Fietkau <nbd@openwrt.org>
Subject: Re: [PATCH 0/3] Work on STBC Rx monitoring
References: <1368949136-6079-1-git-send-email-linux@rempel-privat.de>
In-Reply-To: <1368949136-6079-1-git-send-email-linux@rempel-privat.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Any updates here? can some one please apply last two patches?
Felix?

Am 19.05.2013 09:38, schrieb Oleksij Rempel:
> This patch set will pass RxSTBC flags from ath9k to ieee80211
> and to radiotap.
> This field is now a part of radiotap specification:
> http://www.radiotap.org/defined-fields/MCS
>
> Oleksij Rempel (3):
>    mac80211: add STBC flag for radiotap
>    ath9k: remove useless flag conversation.
>    ath9k: check for Rx-STBC flag and pass it to ieee80211
>
>   drivers/net/wireless/ath/ath9k/ar9003_mac.c |  5 +++--
>   drivers/net/wireless/ath/ath9k/mac.c        | 16 ++++++++++++----
>   drivers/net/wireless/ath/ath9k/mac.h        |  4 +++-
>   drivers/net/wireless/ath/ath9k/recv.c       |  5 +----
>   include/net/ieee80211_radiotap.h            |  7 +++++++
>   include/net/mac80211.h                      |  4 ++++
>   net/mac80211/main.c                         |  3 ++-
>   net/mac80211/rx.c                           |  4 ++++
>   net/mac80211/status.c                       |  3 ++-
>   9 files changed, 38 insertions(+), 13 deletions(-)
>


-- 
Regards,
Oleksij
