Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 9pmail.ess.barracuda.com ([64.235.154.210]:41241 "EHLO
        9pmail.ess.barracuda.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751516AbeA0JSl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 27 Jan 2018 04:18:41 -0500
Date: Sat, 27 Jan 2018 09:15:40 +0000
From: James Hogan <james.hogan@mips.com>
To: Andreas Schwab <schwab@linux-m68k.org>
CC: Kalle Valo <kvalo@codeaurora.org>, Michael Buesch <m@bues.ch>,
        <linux-wireless@vger.kernel.org>, <linux-mips@linux-mips.org>,
        Ralf Baechle <ralf@linux-mips.org>,
        Paul Burton <paul.burton@mips.com>,
        Matt Redfearn <matt.redfearn@imgtec.com>,
        Guenter Roeck <linux@roeck-us.net>
Subject: Re: [for-4.15] ssb: Disable PCI host for PCI_DRIVERS_GENERIC
Message-ID: <20180127091540.GB21356@jhogan-linux.mipstec.com> (sfid-20180127_101849_424419_5FC3FC3A)
References: <20180115211714.24009-1-jhogan@kernel.org>
 <20180116191636.6B3E5605A4@smtp.codeaurora.org>
 <m2bmhfsm6v.fsf@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
In-Reply-To: <m2bmhfsm6v.fsf@linux-m68k.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jan 27, 2018 at 10:08:56AM +0100, Andreas Schwab wrote:
> On Jan 16 2018, Kalle Valo <kvalo@codeaurora.org> wrote:
> 
> > 58eae1416b80 ssb: Disable PCI host for PCI_DRIVERS_GENERIC
> 
> That breaks wireless on PowerMac!  There is nothing MIPS-specific about
> SSB.

Yes, really sorry about that. There is a patch here:
https://patchwork.kernel.org/patch/10185397/

Cheers
James
