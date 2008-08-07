Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx03.syneticon.net ([87.79.32.166]:4549 "EHLO
	mx03.syneticon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751424AbYHGIfQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Aug 2008 04:35:16 -0400
Message-ID: <489AB3A8.1000208@wpkg.org> (sfid-20080807_103522_865340_6B8C9EC5)
Date: Thu, 07 Aug 2008 10:34:48 +0200
From: Tomasz Chmielewski <mangoo@wpkg.org>
MIME-Version: 1.0
To: Chr <chunkeey@web.de>
CC: Johannes Berg <johannes@sipsolutions.net>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless@vger.kernel.org,
	OpenWrt Development List <openwrt-devel@lists.openwrt.org>
Subject: Re: kernel panic on p54pci insertion on mipsel
References: <4898B018.5050202@wpkg.org> <1218053763.23048.67.camel@johannes.berg> <489A0970.9030104@wpkg.org> <200808062250.49495.chunkeey@web.de>
In-Reply-To: <200808062250.49495.chunkeey@web.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Chr schrieb:

(...)

>> Kernel panic - not syncing: Fatal exception in interrupt
>>
> 
> Ouch?! Are you sure your hardware isn't damaged?
> Can you please try another wifi card in your mips,
> or "test" the wifi card in a x86?

Yes, this prism54 card works on x86 (with 2.6.24 kernel).

Also, this mipsel router works with another mini-pci card (Broadcom, b43), so the hardware (both the router and prism card) looks fine.


-- 
Tomasz Chmielewski
http://wpkg.org
