Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hpsmtp-eml13.kpnxchange.com ([213.75.38.113]:29833 "EHLO
	hpsmtp-eml13.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752026AbXJVQsg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Oct 2007 12:48:36 -0400
From: Frans Pop <elendil@planet.nl>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: [ath5k] Help needed for Trust Speedshare Turbo Pro (PCMCIA)
Date: Mon, 22 Oct 2007 18:48:27 +0200
Cc: linux-wireless@vger.kernel.org
References: <200710211316.06772.elendil@planet.nl> <43e72e890710220827k2aa7a8d9m3653ec51ff461b32@mail.gmail.com>
In-Reply-To: <43e72e890710220827k2aa7a8d9m3653ec51ff461b32@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200710221848.27985.elendil@planet.nl> (sfid-20071022_174839_945840_A56884F4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 22 October 2007, Luis R. Rodriguez wrote:
> Get this line again from lspci, and for example if its 30000000 again
> run from madwifi:
>
> ./tools/ath_info 0x30000000

That results in:

 -==Device Information==-
MAC Version:  5212 (0x50)
MAC Revision: 5213A(0x59)
PHY Revision: 5110 (0x0)
PHY Revision: 5110 (0x0)
 -==EEPROM Information==-
EEPROM Version:     4.6
EEPROM Size:        16K
Regulatory Domain:  0x30
 -==== Capabilities ====-
|  802.11a Support: no   |
|  802.11b Support: yes  |
|  802.11g Support: yes  |
|  RFKill  Support: no   |
|  32KHz   Crystal: yes  |
 ========================
GPIO registers: CR 00000000 DO 00000000 DI 00000000
