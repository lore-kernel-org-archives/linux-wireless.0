Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ymail02.netvigator.com ([218.102.23.141]:18442 "EHLO
	ymail02dat.netvigator.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750754Ab0IEFFA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 5 Sep 2010 01:05:00 -0400
Received: from ocmas08.netvigator.com ([219.76.94.12])
          by ymail04dat.netvigator.com
          (InterMail vM.6.01.03.02 201-2131-111-104-20040324) with ESMTP
          id <20100905042559.MKJT23015.ymail04dat.netvigator.com@ocmas08.netvigator.com>
          for <linux-wireless@vger.kernel.org>;
          Sun, 5 Sep 2010 12:25:59 +0800
Subject: undefined reference to `ar71xx_add_device_dsa'  ???
From: Robert Chan <robert.chan.list@gmail.com>
To: linux-wireless@vger.kernel.org
In-Reply-To: <AANLkTimq7nB-ea1XmORprBiS2B-OBNtEiiQXAZLzZfA2@mail.gmail.com>
References: <AANLkTimq7nB-ea1XmORprBiS2B-OBNtEiiQXAZLzZfA2@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 05 Sep 2010 12:25:58 +0800
Message-ID: <1283660758.18358.8.camel@patrick-olevia>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dear all,

I am trying to compile backfire with virtually the default config I
downloaded, except that:

1.  Changed the default platform to ar71xx/TP-Link TL-WR741ND v1;
2.  Enabled mesh networking (pre-802.11s) support (in Networking
Support).

And nothing else.  Then I got the following error:

....................
arch/mips/ar71xx/built-in.o: In function `ap91_eth_init':
(.init.text+0x13b8): undefined reference to `ar71xx_add_device_dsa'
arch/mips/ar71xx/built-in.o: In function `ap91_eth_init':
(.init.text+0x13b8): relocation truncated to fit: R_MIPS_26 against
`ar71xx_add_device_dsa'
make[5]: *** [vmlinux] Error 1
......................

Can anyone please give me some pointer?

Thanks very much in advance.

Regards,

Robert

