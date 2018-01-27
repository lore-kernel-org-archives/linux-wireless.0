Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.10]:49611 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751516AbeA0JJI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 27 Jan 2018 04:09:08 -0500
From: Andreas Schwab <schwab@linux-m68k.org>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: James Hogan <jhogan@kernel.org>, Michael Buesch <m@bues.ch>,
        linux-wireless@vger.kernel.org, linux-mips@linux-mips.org,
        Ralf Baechle <ralf@linux-mips.org>,
        Paul Burton <paul.burton@mips.com>,
        Matt Redfearn <matt.redfearn@imgtec.com>,
        Guenter Roeck <linux@roeck-us.net>
Subject: Re: [for-4.15] ssb: Disable PCI host for PCI_DRIVERS_GENERIC
References: <20180115211714.24009-1-jhogan@kernel.org>
        <20180116191636.6B3E5605A4@smtp.codeaurora.org>
Date: Sat, 27 Jan 2018 10:08:56 +0100
In-Reply-To: <20180116191636.6B3E5605A4@smtp.codeaurora.org> (Kalle Valo's
        message of "Tue, 16 Jan 2018 19:16:36 +0000 (UTC)")
Message-ID: <m2bmhfsm6v.fsf@linux-m68k.org> (sfid-20180127_100926_088810_D45812A5)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Jan 16 2018, Kalle Valo <kvalo@codeaurora.org> wrote:

> 58eae1416b80 ssb: Disable PCI host for PCI_DRIVERS_GENERIC

That breaks wireless on PowerMac!  There is nothing MIPS-specific about
SSB.

Andreas.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
