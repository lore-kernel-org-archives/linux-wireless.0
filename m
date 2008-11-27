Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:60911 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750797AbYK0COL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Nov 2008 21:14:11 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 26 Nov 2008 18:14:11 -0800
Date: Wed, 26 Nov 2008 18:14:08 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: c4linux c4linux <c4linux@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: one VAP's WEP key overwrites another's
Message-ID: <20081127021408.GE13226@tesla> (sfid-20081127_031416_411071_1AAC190D)
References: <14c249940811261657l37d9855btc5280cd0e76e4525@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <14c249940811261657l37d9855btc5280cd0e76e4525@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 26, 2008 at 04:57:49PM -0800, c4linux c4linux wrote:
> there is a question about AR2413 and madwifi driver.
> 
> madwifi can support VAP, so I setup 2 VAPs, one is ath0, another is
> ath1.both of them are set SharedKey authentication and use WEP
> encrypthion. I type the command below to set each of them a password:
> 
> iwconfig ath0 key [1] s:1111111111111
> iwconfig ath1 key [1] s:2222222222222
> 
> two VAPs have the same mac address and their ssid are different.
> 
> the strange thing happens, It seems that ath1's password overwrite the
> ath0's, so if I set my sta the ath1's password and select ath0 to
> connect, I connect the ath0 successfully. Why? are the 4 slots for WEP
> Key is shared by all VAPs?  or VAP is not stable?

Please use madwifi-devel for this, linux-wireless is only for drivers
upstream, so ath5k and ath9k. We don't care about MadWifi.

  Luis
