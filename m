Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:52856 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751023Ab1ALKHF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Jan 2011 05:07:05 -0500
Date: Wed, 12 Jan 2011 12:06:53 +0200
From: Jouni Malinen <j@w1.fi>
To: Andy Pyles <andy.pyles@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: packet injection not working on rt2800usb, ath9k
Message-ID: <20110112100653.GA7291@jm.kir.nu>
References: <AANLkTi=2N5A0ZBoULj3d0Bp_GeWQouHGFA_LRWWu1k22@mail.gmail.com>
 <20110111115207.GA28619@jm.kir.nu>
 <AANLkTin0NYnoki8wD-Q4o33KyNhu8jJwr=LBJx-FCnNF@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <AANLkTin0NYnoki8wD-Q4o33KyNhu8jJwr=LBJx-FCnNF@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 11, 2011 at 03:49:06PM -0500, Andy Pyles wrote:
> Thanks for the tip! After some debugging, it turns out that my
> radiotap header is not getting parsed correctly
> in ./net/mac80211/tx.c:__ieee80211_parse_tx_radiotap()
> 
> Would you mind sending me the radiotap header you are using?

http://w1.fi/gitweb/gitweb.cgi?p=hostap.git;a=blob_plain;f=wlantest/inject.c;hb=HEAD

-- 
Jouni Malinen                                            PGP id EFC895FA
