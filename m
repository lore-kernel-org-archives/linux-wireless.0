Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:49878 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753580Ab3EDGz4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 4 May 2013 02:55:56 -0400
Received: from mailout-de.gmx.net ([10.1.76.28]) by mrigmx.server.lan
 (mrigmx001) with ESMTP (Nemesis) id 0MZic4-1Urqz70Vqw-00LXx1 for
 <linux-wireless@vger.kernel.org>; Sat, 04 May 2013 08:55:55 +0200
Message-ID: <5184B0F6.9020705@rempel-privat.de> (sfid-20130504_085558_997595_C7CB383E)
Date: Sat, 04 May 2013 08:55:50 +0200
From: Oleksij Rempel <linux@rempel-privat.de>
MIME-Version: 1.0
To: Adrian Chadd <adrian@freebsd.org>
CC: ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org
Subject: Re: [ath9k-devel] [PATCH 1/2] ath9k_htc: add STBC TX support
References: <1367482308-9882-1-git-send-email-linux@rempel-privat.de> <1367482308-9882-2-git-send-email-linux@rempel-privat.de> <CAJ-Vmo=rZrHmXD0Os-Mb40jSEywbO-7GHSqL=7iMbkzAfS=+UQ@mail.gmail.com> <5182A341.8050704@rempel-privat.de> <5182A9DC.6030203@openwrt.org> <CAJ-Vmo=XYK=Jkc40U_vJO03n+tiA_LDpw8e1QKYRX6-+E9o4fA@mail.gmail.com> <5184AFC2.8060101@rempel-privat.de>
In-Reply-To: <5184AFC2.8060101@rempel-privat.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am 04.05.2013 08:50, schrieb Oleksij Rempel:
> Am 02.05.2013 22:15, schrieb Adrian Chadd:
>> Well, let's dig into the firmware a bit more and tidy up how STBC is handled.
>
> Does it mean, i should change this patch and provide a patch for
> firmware too?
> I still do not think, changing peer caps i a good idea in any case.
> I mena this part of patch:
> +               if (sta->ht_cap.cap & IEEE80211_HT_CAP_TX_STBC)
> +                       caps |= WLAN_RC_TX_STBC_FLAG;
>

oops... my error. I see the problem now.
I do not pass flags provided by peer.


-- 
Regards,
Oleksij
