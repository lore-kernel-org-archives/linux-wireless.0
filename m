Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38030 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751600AbdLUOUa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 21 Dec 2017 09:20:30 -0500
Date: Thu, 21 Dec 2017 15:20:27 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Enrico Mioso <mrkiko.rs@gmail.com>
Cc: linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Daniel Golle <daniel@makrotopia.org>,
        Arnd Bergmann <arnd@arndb.de>, John Crispin <john@phrozen.org>,
        nbd@nbd.name
Subject: Re: MT7630 support
Message-ID: <20171221142026.GA4655@redhat.com> (sfid-20171221_152034_182755_EDEB1BF8)
References: <alpine.LNX.2.21.99.1712201832120.21664@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <alpine.LNX.2.21.99.1712201832120.21664@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 20, 2017 at 06:39:34PM +0100, Enrico Mioso wrote:
> Hello guys.
> So, at some point I felt crazy enough to try to add support for the MT7630 chipset to the rt2xx ralink wireless drivers.
> I expected this to be a little bit of a challenge.
> I did begin adding some code paths around, reading from the mixed-up drivers here:
> https://github.com/neurobin/MT7630E
> (thanks a lot to the guys who are working on this, and who worked on this).
> and working on the kernel's git rt2xx tree. I am sending a raw diff that will for sure not compile. I am asking for guidance and help in going on.

I think better way to add support for MT7630 chip to mailine kernel
would be via new Felix's mt76 driver, because there are less diffrence
between MT7630 and MT76x2 than between MT7630 and the old Ralink chips.

Cheers
Stanislaw 
