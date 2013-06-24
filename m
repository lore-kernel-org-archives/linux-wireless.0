Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:48005 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751486Ab3FXTI6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Jun 2013 15:08:58 -0400
Message-ID: <51C8994E.4040809@openwrt.org> (sfid-20130624_210901_088299_BAE362C0)
Date: Mon, 24 Jun 2013 21:09:02 +0200
From: Gabor Juhos <juhosg@openwrt.org>
MIME-Version: 1.0
To: Stanislaw Gruszka <stf_xl@wp.pl>
CC: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Subject: Re: [rt2x00-users] [PATCH 0/3] rt2x00: rt2800: prepare for three-chain
 device support
References: <1371915734-13966-1-git-send-email-juhosg@openwrt.org> <20130624160031.GD2460@localhost.localdomain>
In-Reply-To: <20130624160031.GD2460@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> On Sat, Jun 22, 2013 at 05:42:11PM +0200, Gabor Juhos wrote:
>> Gabor Juhos (3):
>>   rt2x00: rt2800: increase EEPROM_SIZE to 512 bytes
>>   rt2x00: rt2800lib: turn on secondary PAs/LNAs for 3T/3R devices
>>   rt2x00: rt2800lib: turn on tertiary PAs/LNAs for 3T/3R devices
>>
>>  drivers/net/wireless/rt2x00/rt2800.h    |    2 +-
>>  drivers/net/wireless/rt2x00/rt2800lib.c |   22 ++++++++++++++++++----
>>  2 files changed, 19 insertions(+), 5 deletions(-)
> 
> This series also looks good to me.
> 
> Acked-by: Stanislaw Gruszka <stf_xl@wp.pl>

Thanks!

> BTW: Do you plan to create more 3T/3R patches soon ? 

Yes, I have more patches in the queue.

> I plan to work on adding support for RT3573 usb device (but stuck on other
> work so far unfortunetly). Anyway I don't want to duplicate efforts, so would
> like to know about your plans.

I'm testing these patches on a Linksys AE3000 device which also uses the RT3573
chip. I have an almost complete patch-set which allows me to use the device in
STA and in AP mode, however I still have to resolve a few problems.

-Gabor
