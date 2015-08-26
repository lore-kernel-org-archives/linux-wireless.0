Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:37096 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755219AbbHZJoe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Aug 2015 05:44:34 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Arnd Bergmann <arnd@arndb.de>
CC: Michal Kazior <michal.kazior@tieto.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Anish Tondwalkar <twilightrook@gmail.com>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	Oscar Rydberg <oscarrydberg@gmail.com>,
	Victor van Poppelen <vvanpo@gmail.com>,
	Joseph Salisbury <joseph.salisbury@canonical.com>
Subject: Re: [PATCH/RFT 0/2] ath10k: add qca6164 support
References: <1439469147-9408-1-git-send-email-michal.kazior@tieto.com>
	<CA+BoTQ=STQ2jpMCjP7V=soPk=e4BMuq+3bO_F0UXK_EuJFqxfQ@mail.gmail.com>
	<1901727.3ECHUBE5WW@wuerfel> <1523365.YtEF2Ft7XC@wuerfel>
Date: Wed, 26 Aug 2015 12:44:25 +0300
In-Reply-To: <1523365.YtEF2Ft7XC@wuerfel> (Arnd Bergmann's message of "Tue, 25
	Aug 2015 20:24:57 +0200")
Message-ID: <87bndu1j0m.fsf@kamboji.qca.qualcomm.com> (sfid-20150826_114451_313323_93EDE7C2)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arnd Bergmann <arnd@arndb.de> writes:

> On Tuesday 25 August 2015 15:47:45 Arnd Bergmann wrote:
>> On Tuesday 25 August 2015 15:09:45 Michal Kazior wrote:
>> > 
>> > This is some weird regression with MSI ranges and we still haven't
>> > figured this out.
>> > 
>> > For the time being add "irq_mode=1" parameter when loading ath10k_pci
>> > module, please.
>> 
>> Ok, that gets the device to show up without errors. I have no
>> time to test whether I can actually use it at the moment, will
>> report back later.
>
> I tested some more and everything seems fine now when using legacy
> interrupts. Thanks for all the work that went into this, I hope
> the patch can make it into 4.3.

I'm planning to send a pull request to Dave later today so this patch
should make it to 4.3. Sorry for taking so long to fix this.

-- 
Kalle Valo
