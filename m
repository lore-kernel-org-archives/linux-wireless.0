Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:36892 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751377AbeA0E3Y (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 Jan 2018 23:29:24 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Krzysztof Mazur <krzysiek@podlesie.net>
Cc: Michael Buesch <m@bues.ch>, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org, James Hogan <jhogan@kernel.org>,
        Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH] ssb: Reenable PCI host on !MIPS
References: <20180126235849.3177-1-krzysiek@podlesie.net>
Date: Sat, 27 Jan 2018 06:29:18 +0200
In-Reply-To: <20180126235849.3177-1-krzysiek@podlesie.net> (Krzysztof Mazur's
        message of "Sat, 27 Jan 2018 00:58:49 +0100")
Message-ID: <87inbnsz4x.fsf@kamboji.qca.qualcomm.com> (sfid-20180127_052940_714775_12BD2C43)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Krzysztof Mazur <krzysiek@podlesie.net> writes:

> The commit 58eae1416b804d900014d84feadda7195007cc30
> ("ssb: Disable PCI host for PCI_DRIVERS_GENERIC") disabled
> CONFIG_SSB_PCIHOST and CONFIG_SSB_B43_PCI_BRIDGE, which are
> required for SSB-based b43 PCI cards, on everything except MIPS
> with PCI_DRIVERS_LEGACY, including x86 (only MIPS defines
> that config option). Reenable it.
>
> Signed-off-by: Krzysztof Mazur <krzysiek@podlesie.net>

I have already applied an identical patch but missed the deadline for
final 4.15:

https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers.git/commit/?id=a9e6d44ddeccd3522670e641f1ed9b068e746ff7

That patch will go to 4.16 and from there to 4.15 via the stable tree.

-- 
Kalle Valo
