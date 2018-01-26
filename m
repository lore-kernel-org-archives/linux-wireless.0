Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:34818 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751505AbeAZO4r (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 Jan 2018 09:56:47 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ssb: Do not disable PCI host on non-Mips
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <87vafpq7t2.fsf@turtle.gmx.de>
References: <87vafpq7t2.fsf@turtle.gmx.de>
To: Sven Joachim <svenjoac@gmx.de>
Cc: Michael Buesch <m@bues.ch>, linux-wireless@vger.kernel.org,
        James Hogan <jhogan@kernel.org>, linux-mips@linux-mips.org,
        Ralf Baechle <ralf@linux-mips.org>,
        James Hogan <jhogan@kernel.org>,
        Paul Burton <paul.burton@mips.com>,
        Matt Redfearn <matt.redfearn@imgtec.com>,
        Guenter Roeck <linux@roeck-us.net>
Message-Id: <20180126145647.6FD3C6024A@smtp.codeaurora.org> (sfid-20180126_155651_779139_A5217E47)
Date: Fri, 26 Jan 2018 14:56:47 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sven Joachim <svenjoac@gmx.de> wrote:

> After upgrading an old laptop to 4.15-rc9, I found that the eth0 and
> wlan0 interfaces had disappeared.  It turns out that the b43 and b44
> drivers require SSB_PCIHOST_POSSIBLE which depends on
> PCI_DRIVERS_LEGACY, a config option that only exists on Mips.
> 
> Fixes: 58eae1416b80 ("ssb: Disable PCI host for PCI_DRIVERS_GENERIC")
> Cc: stable@vger.org
> Signed-off-by: Sven Joachim <svenjoac@gmx.de>
> Reviewed-by: James Hogan <jhogan@kernel.org>

Patch applied to wireless-drivers.git, thanks.

a9e6d44ddecc ssb: Do not disable PCI host on non-Mips

-- 
https://patchwork.kernel.org/patch/10185397/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
