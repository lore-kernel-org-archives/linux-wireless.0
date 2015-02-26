Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:49406 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752696AbbBZKBO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Feb 2015 05:01:14 -0500
Message-ID: <54EEEEE5.2040305@broadcom.com> (sfid-20150226_110119_452497_AC8DAC2A)
Date: Thu, 26 Feb 2015 11:01:09 +0100
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Jouni Malinen <j@w1.fi>, Felix Fietkau <nbd@openwrt.org>,
	=?UTF-8?B?VGhvbWFzIEjDvGhu?= <thomas@net.t-labs.tu-berlin.de>,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	Andrew McGregor <andrewmcgr@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	Kalle Valo <kvalo@codeaurora.org>
Subject: Re: [ath9k-devel] AR9462 problems connecting again..
References: <CA+55aFyNqdNk5aq17YdqTCjiWpZ9=ifF3ii+Ko=EzUWZgnCGoQ@mail.gmail.com>	<CAJ-Vmo=Tu9vBgm2xwqHWqXhx6df9h5cff5_ivERShJ9QPdwYww@mail.gmail.com>	<20150223224305.GA30228@w1.fi>	<21739.50662.902775.901924@gargle.gargle.HOWL>	<CAA_e5Z4zuDMS+CJvFbw4F5M9OZxgS-NZzL2E3d3GSvpRr_TbQw@mail.gmail.com>	<CAA_e5Z5PqfcYss9fADFewBTgnxrYMy5U6XbRz-J5doEyKgugTg@mail.gmail.com>	<20150224102611.GA30806@w1.fi>	<80AA1103-EBCD-4C18-A950-B03FF516E5AC@net.t-labs.tu-berlin.de>	<20150224181454.GA30859@w1.fi>	<54ED56D8.9030806@openwrt.org>	<20150225144723.GA6903@w1.fi>	<CA+55aFyvhgFMRAg2ftuN_cykGs_3-Oyabhi_N6S-J1daVFFRzw@mail.gmail.com> <CA+55aFxE7_RXc1hBo+e=iCj4KpeMev_WphH+tDHXnYC4HE5YvQ@mail.gmail.com>
In-Reply-To: <CA+55aFxE7_RXc1hBo+e=iCj4KpeMev_WphH+tDHXnYC4HE5YvQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/26/15 06:55, Linus Torvalds wrote:
> Because it looks like the brcmsmac driver has*exactly*  the same
> behavior with this AP (in an Apple Macbook air). I assume brcmsmac
> uses the net/80211/tx.c logic too.

That makes sense as brcmsmac is a mac80211 driver that uses the 
minstrel-ht rate control algorithm. iwlwifi is also a mac80211 driver 
but it uses a different rate control algorithm so if you have that lying 
around it would be interesting to test that (if you did not already do 
that).

Regards,
Arend
