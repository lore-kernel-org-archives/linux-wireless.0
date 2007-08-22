Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.185]:20658 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753635AbXHVTXo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Aug 2007 15:23:44 -0400
Received: by nf-out-0910.google.com with SMTP id g13so200798nfb
        for <linux-wireless@vger.kernel.org>; Wed, 22 Aug 2007 12:23:43 -0700 (PDT)
To: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Subject: Re: 2.6.23-rc3-mm1: net/wireless/rt2x00mac.c build failure
Date: Wed, 22 Aug 2007 21:31:24 +0200
Cc: John Linville <linville@tuxdriver.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
References: <20070822020648.5ea3a612.akpm@linux-foundation.org> <200708222116.22386.m.kozlowski@tuxland.pl>
In-Reply-To: <200708222116.22386.m.kozlowski@tuxland.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200708222131.24882.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

>   CC [M]  drivers/net/wireless/rt2x00mac.o
> drivers/net/wireless/rt2x00mac.c: In function `rt2x00mac_tx_rts_cts':
> drivers/net/wireless/rt2x00mac.c:61: warning: passing arg 2 of `ieee80211_ctstoself_get' makes pointer from integer without a cast
> drivers/net/wireless/rt2x00mac.c:61: warning: passing arg 3 of `ieee80211_ctstoself_get' makes integer from pointer without a cast
> drivers/net/wireless/rt2x00mac.c:61: warning: passing arg 4 of `ieee80211_ctstoself_get' makes pointer from integer without a cast
> drivers/net/wireless/rt2x00mac.c:61: warning: passing arg 5 of `ieee80211_ctstoself_get' from incompatible pointer type
> drivers/net/wireless/rt2x00mac.c:61: error: too many arguments to function `ieee80211_ctstoself_get'
> drivers/net/wireless/rt2x00mac.c:65: warning: passing arg 2 of `ieee80211_rts_get' makes pointer from integer without a cast
> drivers/net/wireless/rt2x00mac.c:65: warning: passing arg 3 of `ieee80211_rts_get' makes integer from pointer without a cast
> drivers/net/wireless/rt2x00mac.c:65: warning: passing arg 4 of `ieee80211_rts_get' makes pointer from integer without a cast
> drivers/net/wireless/rt2x00mac.c:65: warning: passing arg 5 of `ieee80211_rts_get' from incompatible pointer type
> drivers/net/wireless/rt2x00mac.c:65: error: too many arguments to function `ieee80211_rts_get'
> make[3]: *** [drivers/net/wireless/rt2x00mac.o] Error 1
> make[2]: *** [drivers/net/wireless] Error 2
> make[1]: *** [drivers/net] Error 2
> make: *** [drivers] Error 2

This has been fixed for quite some time already.
John, I can't check this myself now, but which rt2x00
patches have gone into the -mm tree? Since I believe
the patch that changed ieee80211_ctstoself_get was
followed by a patch to fix rt2x00 within the same series...

Ivo
