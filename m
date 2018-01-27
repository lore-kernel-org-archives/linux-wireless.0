Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shrek-s3.podlesie.net ([85.14.110.209]:42409 "EHLO
        shrek.podlesie.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751446AbeA0Hi6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 27 Jan 2018 02:38:58 -0500
Date: Sat, 27 Jan 2018 08:38:56 +0100
From: Krzysztof Mazur <krzysiek@podlesie.net>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Michael Buesch <m@bues.ch>, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org, James Hogan <jhogan@kernel.org>,
        Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH] ssb: Reenable PCI host on !MIPS
Message-ID: <20180127073856.GA14071@shrek.podlesie.net> (sfid-20180127_083925_206826_6E8209B3)
References: <20180126235849.3177-1-krzysiek@podlesie.net>
 <87inbnsz4x.fsf@kamboji.qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <87inbnsz4x.fsf@kamboji.qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jan 27, 2018 at 06:29:18AM +0200, Kalle Valo wrote:
> Krzysztof Mazur <krzysiek@podlesie.net> writes:
> 
> > The commit 58eae1416b804d900014d84feadda7195007cc30
> > ("ssb: Disable PCI host for PCI_DRIVERS_GENERIC") disabled
> > CONFIG_SSB_PCIHOST and CONFIG_SSB_B43_PCI_BRIDGE, which are
> > required for SSB-based b43 PCI cards, on everything except MIPS
> > with PCI_DRIVERS_LEGACY, including x86 (only MIPS defines
> > that config option). Reenable it.
> >
> > Signed-off-by: Krzysztof Mazur <krzysiek@podlesie.net>
> 
> I have already applied an identical patch but missed the deadline for
> final 4.15:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers.git/commit/?id=a9e6d44ddeccd3522670e641f1ed9b068e746ff7
> 
> That patch will go to 4.16 and from there to 4.15 via the stable tree.

Thanks,

Krzysiek
