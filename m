Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.10]:59524 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751865AbbHYSZD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Aug 2015 14:25:03 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	Anish Tondwalkar <twilightrook@gmail.com>,
	Victor van Poppelen <vvanpo@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Oscar Rydberg <oscarrydberg@gmail.com>,
	Joseph Salisbury <joseph.salisbury@canonical.com>
Subject: Re: [PATCH/RFT 0/2] ath10k: add qca6164 support
Date: Tue, 25 Aug 2015 20:24:57 +0200
Message-ID: <1523365.YtEF2Ft7XC@wuerfel> (sfid-20150825_202508_896405_198C9F6B)
In-Reply-To: <1901727.3ECHUBE5WW@wuerfel>
References: <1439469147-9408-1-git-send-email-michal.kazior@tieto.com> <CA+BoTQ=STQ2jpMCjP7V=soPk=e4BMuq+3bO_F0UXK_EuJFqxfQ@mail.gmail.com> <1901727.3ECHUBE5WW@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 25 August 2015 15:47:45 Arnd Bergmann wrote:
> On Tuesday 25 August 2015 15:09:45 Michal Kazior wrote:
> > 
> > This is some weird regression with MSI ranges and we still haven't
> > figured this out.
> > 
> > For the time being add "irq_mode=1" parameter when loading ath10k_pci
> > module, please.
> 
> Ok, that gets the device to show up without errors. I have no
> time to test whether I can actually use it at the moment, will
> report back later.

I tested some more and everything seems fine now when using legacy
interrupts. Thanks for all the work that went into this, I hope
the patch can make it into 4.3.

	Arnd
