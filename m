Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from phoenix3.szarvasnet.hu ([87.101.127.16]:33158 "EHLO
	mail.szarvasnet.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752283Ab3HQJ5G (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Aug 2013 05:57:06 -0400
Message-ID: <520F476D.7040809@openwrt.org> (sfid-20130817_115712_488440_6F8CECF5)
Date: Sat, 17 Aug 2013 11:50:37 +0200
From: Gabor Juhos <juhosg@openwrt.org>
MIME-Version: 1.0
To: Gabor Juhos <juhosg@openwrt.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Subject: Re: [PATCH 0/5] rt2x00: rt2800lib: frequency offset adjustment fixes
References: <1376685498-5167-1-git-send-email-juhosg@openwrt.org>
In-Reply-To: <1376685498-5167-1-git-send-email-juhosg@openwrt.org>
Content-Type: text/plain; charset=ISO-8859-2
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2013.08.16. 22:38 keltezéssel, Gabor Juhos írta:
> The patch-set contain small fixes for the frequency adjustment 
> code of the rt2800 driver.
> 
> Gabor Juhos (5):
>   rt2x00: rt2800lib: fix frequency offset boundary calculation
>   rt2x00: rt2800lib: optimize frequency offset adjustment
>   rt2x00: rt2800lib: use a MCU command for frequency adjustment on USB
>     devices
>   rt2x00: rt2800lib: move rt2800_adjust_freq_offset function
>   rt2x00: rt2800lib: adjust frequency offset for RF3053
> 
>  drivers/net/wireless/rt2x00/rt2800lib.c |   38 +++++++++++++++++++------------
>  1 file changed, 24 insertions(+), 14 deletions(-)
> 

John,

Please ignore this set. I will send a slightly improved version.

-Gabor
