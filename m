Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:34123 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750935Ab0GJUVt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Jul 2010 16:21:49 -0400
Message-ID: <4C38D657.8060700@openwrt.org>
Date: Sat, 10 Jul 2010 22:21:43 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Norman Henderson <norm.audrey@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: Issues with ath9k dropping connectivity - now no connectivity
References: <AANLkTilq_VFbOPHmMuf1EFmewc_WBBpgvW0t7ogZdbdl@mail.gmail.com>	<4C38BE1D.2020107@openwrt.org> <AANLkTinNmQONdkT_f7aNykH0t4o7Zdybi96hcd4K4UUp@mail.gmail.com>
In-Reply-To: <AANLkTinNmQONdkT_f7aNykH0t4o7Zdybi96hcd4K4UUp@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2010-07-10 9:40 PM, Norman Henderson wrote:
> Thanks very much Felix for the quick comment. I'll follow up on it
> over the next few days as I get time to move to "bleeding edge"
> (something I've sworn from my youth to never do...).
> 
> However I guess I was more concerned about the regression from an
> environment that worked (with disconnections) to one that doesn't
> connect at all - is that just the luck of the draw or did I do
> something stupid? (more precisely, what was it that I did stupid,
> because that's inevitably true :~
No idea if it was a configuration error or if it broke somewhere. To be
honest, I stopped caring about AP mode in old kernels completely,
because of the large number of known bugs that are fixed in newer versions.

- Felix
