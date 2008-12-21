Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:49429 "EHLO ds10.mine.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751349AbYLUMBi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Dec 2008 07:01:38 -0500
Message-ID: <494E301B.7090906@openwrt.org> (sfid-20081221_130209_364170_DDD4B4A2)
Date: Sun, 21 Dec 2008 13:01:31 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, jirislaby@gmail.com, mcgrof@gmail.com,
	me@bobcopeland.com, nbd@openwrt.org
Subject: Re: [PATCH] ath5k: Update EEPROM code
References: <20081221024739.GA13665@makis>
In-Reply-To: <20081221024739.GA13665@makis>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Nick Kossifidis wrote:
>  *Read misc2...6 values from eeprom since we want to use them (fixes wrong power calibration info offset on RF2413+ chips)
>  *Initialize num_piers to 0 for RF2413 chips (note that we read 2GHz frequency piers while
>   reading mode sections, we have to ignore them -usualy they are 0xff anyway but during
>   my tests i got a 1 on b mode with no data- and use the newer eemap.
>  *Add some more comments (please forgive my poor English ;-( ) and some minor code cleanup
>  *Tested on 2425 and 2112 and has the same data with ath_info (i wrote some debug code
>   on debug.c to print everything like ath_info but i haven't tested it yet on 5111 and it's
>   full of > 80 col lines, if anyone wants to play with it let me know).
> 
>  Signed-Off-by: Nick Kossifidis <mickflemm@gmail.com>
Acked-by: Felix Fietkau <nbd@openwrt.org>
