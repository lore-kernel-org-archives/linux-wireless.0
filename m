Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.131]:61912 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751286AbbHYNsO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Aug 2015 09:48:14 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	Anish Tondwalkar <twilightrook@gmail.com>,
	Victor van Poppelen <vvanpo@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Oscar Rydberg <oscarrydberg@gmail.com>,
	Joseph Salisbury <joseph.salisbury@canonical.com>
Subject: Re: [PATCH/RFT 0/2] ath10k: add qca6164 support
Date: Tue, 25 Aug 2015 15:47:45 +0200
Message-ID: <1901727.3ECHUBE5WW@wuerfel> (sfid-20150825_154817_795224_F9A4CE48)
In-Reply-To: <CA+BoTQ=STQ2jpMCjP7V=soPk=e4BMuq+3bO_F0UXK_EuJFqxfQ@mail.gmail.com>
References: <1439469147-9408-1-git-send-email-michal.kazior@tieto.com> <1889302.bvZ6s0xNZC@wuerfel> <CA+BoTQ=STQ2jpMCjP7V=soPk=e4BMuq+3bO_F0UXK_EuJFqxfQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 25 August 2015 15:09:45 Michal Kazior wrote:
> 
> This is some weird regression with MSI ranges and we still haven't
> figured this out.
> 
> For the time being add "irq_mode=1" parameter when loading ath10k_pci
> module, please.

Ok, that gets the device to show up without errors. I have no
time to test whether I can actually use it at the moment, will
report back later.

Thanks!

	Arnd
