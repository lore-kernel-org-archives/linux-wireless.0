Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:63272 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757029Ab3FCKOf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Jun 2013 06:14:35 -0400
Received: from mailout-de.gmx.net ([10.1.76.16]) by mrigmx.server.lan
 (mrigmx001) with ESMTP (Nemesis) id 0MISkD-1Ugxk63XZf-0048WY for
 <linux-wireless@vger.kernel.org>; Mon, 03 Jun 2013 12:14:33 +0200
Message-ID: <51AC6C86.9090502@rempel-privat.de> (sfid-20130603_121441_644420_512591A4)
Date: Mon, 03 Jun 2013 12:14:30 +0200
From: Oleksij Rempel <linux@rempel-privat.de>
MIME-Version: 1.0
To: Sujith Manoharan <sujith@msujith.org>
CC: ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 0/2] ath9k: add STBC Rx flags (repost untill some one
 asnwers)
References: <1370246279-6536-1-git-send-email-linux@rempel-privat.de> <20908.26870.629833.926468@gargle.gargle.HOWL>
In-Reply-To: <20908.26870.629833.926468@gargle.gargle.HOWL>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am 03.06.2013 11:59, schrieb Sujith Manoharan:
> Oleksij Rempel wrote:
>> One more repost of old patches. I need, please, at least some kind of answer:
>> "we don't wont patches from you" or "you are doing some thing wrong".
>
> Both the patches have already been merged in wireless-testing.

ah... i didn't noticed that.
thank you ;)

> commit b0a1ae976d6cd40ff90ba87883e17eb2610dae3d
> Author: Oleksij Rempel <linux@rempel-privat.de>
> Date:   Fri May 24 20:30:59 2013 +0200
>
>      ath9k: check for Rx-STBC flag and pass it to ieee80211
>
>      This patch make use of STBC flag in DMA RX descriptor.
>      Only devices after ar9280 can provide this information.
>
>      If card support it we will set HAVE_STBC flag, to show
>      clint programm thet STBC is supported but not received.
>
>      Signed-off-by: Oleksij Rempel <linux@rempel-privat.de>
>      Signed-off-by: John W. Linville <linville@tuxdriver.com>
>
> commit ab276103357637fb26cc851369b5abbdc42afbf4
> Author: Oleksij Rempel <linux@rempel-privat.de>
> Date:   Fri May 24 12:18:30 2013 +0200
>
>      ath9k: remove useless flag conversation.
>
>      some flags used only outside of ath9k - In this case we can use
>      "enum mac80211_rx_flags" and pass it upstream without extra
>      conversation.
>
>      Signed-off-by: Oleksij Rempel <linux@rempel-privat.de>
>      Signed-off-by: John W. Linville <linville@tuxdriver.com>
>
> Sujith
>




-- 
Regards,
Oleksij
