Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:54278 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755690Ab3HFKgL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Aug 2013 06:36:11 -0400
Message-ID: <5200D199.8080808@openwrt.org> (sfid-20130806_123614_652205_4E0BC474)
Date: Tue, 06 Aug 2013 12:36:09 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: projekt-wlan@fem.tu-ilmenau.de
CC: Michael Braun <michael.braun@fem.tu-ilmenau.de>,
	linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Subject: Re: ath9k AR9380 packets take long to be sent
References: <e86f61ba4c0540d1d22be989362cbeb1@fami-braun.de>
In-Reply-To: <e86f61ba4c0540d1d22be989362cbeb1@fami-braun.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2013-08-06 10:52 AM, Michael Braun wrote:
> Hi,
> 
> I've upgraded my OpenWRT based AP firmware from kernel 3.8 to kernel 
> 3.10.5 with compat-wireless 2013-06-27.
> Since then I started to notice that some packets take very long to be 
> actually sent from AP to STA.
Which specific OpenWrt revision are you using? Also, can you please test
with the latest one (I just committed some more fixes).

- Felix
