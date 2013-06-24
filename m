Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3.wp.pl ([212.77.101.7]:17653 "EHLO mx3.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750829Ab3FXP6G (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Jun 2013 11:58:06 -0400
Date: Mon, 24 Jun 2013 18:00:31 +0200
From: Stanislaw Gruszka <stf_xl@wp.pl>
To: Gabor Juhos <juhosg@openwrt.org>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Subject: Re: [rt2x00-users] [PATCH 0/3] rt2x00: rt2800: prepare for
 three-chain device support
Message-ID: <20130624160031.GD2460@localhost.localdomain> (sfid-20130624_175810_604531_E8D6EC8D)
References: <1371915734-13966-1-git-send-email-juhosg@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1371915734-13966-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jun 22, 2013 at 05:42:11PM +0200, Gabor Juhos wrote:
> Gabor Juhos (3):
>   rt2x00: rt2800: increase EEPROM_SIZE to 512 bytes
>   rt2x00: rt2800lib: turn on secondary PAs/LNAs for 3T/3R devices
>   rt2x00: rt2800lib: turn on tertiary PAs/LNAs for 3T/3R devices
> 
>  drivers/net/wireless/rt2x00/rt2800.h    |    2 +-
>  drivers/net/wireless/rt2x00/rt2800lib.c |   22 ++++++++++++++++++----
>  2 files changed, 19 insertions(+), 5 deletions(-)

This series also looks good to me.

Acked-by: Stanislaw Gruszka <stf_xl@wp.pl>

BTW: Do you plan to create more 3T/3R patches soon ? I plan to work on
adding support for RT3573 usb device (but stuck on other work so far
unfortunetly). Anyway I don't want to duplicate efforts, so would like
to know about your plans.

Thanks
Stanislaw

