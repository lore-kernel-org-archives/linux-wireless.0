Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f47.google.com ([74.125.82.47]:46858 "EHLO
        mail-wm0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750727AbdLWH2Z (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 23 Dec 2017 02:28:25 -0500
Received: by mail-wm0-f47.google.com with SMTP id r78so25335978wme.5
        for <linux-wireless@vger.kernel.org>; Fri, 22 Dec 2017 23:28:24 -0800 (PST)
Date: Sat, 23 Dec 2017 08:28:22 +0100 (CET)
From: Hans Ulli Kroll <ulli.kroll@googlemail.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
cc: Enrico Mioso <mrkiko.rs@gmail.com>, linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Daniel Golle <daniel@makrotopia.org>,
        Arnd Bergmann <arnd@arndb.de>, John Crispin <john@phrozen.org>,
        nbd@nbd.name
Subject: Re: MT7630 support
In-Reply-To: <20171221142026.GA4655@redhat.com>
Message-ID: <alpine.LNX.2.00.1712230819270.14868@Nettop> (sfid-20171223_082832_277117_99799313)
References: <alpine.LNX.2.21.99.1712201832120.21664@localhost.localdomain> <20171221142026.GA4655@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi

On Thu, 21 Dec 2017, Stanislaw Gruszka wrote:

> On Wed, Dec 20, 2017 at 06:39:34PM +0100, Enrico Mioso wrote:
> > Hello guys.
> > So, at some point I felt crazy enough to try to add support for the MT7630 chipset to the rt2xx ralink wireless drivers.
> > I expected this to be a little bit of a challenge.
> > I did begin adding some code paths around, reading from the mixed-up drivers here:
> > https://github.com/neurobin/MT7630E
> > (thanks a lot to the guys who are working on this, and who worked on this).
> > and working on the kernel's git rt2xx tree. I am sending a raw diff that will for sure not compile. I am asking for guidance and help in going on.
> 
> I think better way to add support for MT7630 chip to mailine kernel
> would be via new Felix's mt76 driver, because there are less diffrence
> between MT7630 and MT76x2 than between MT7630 and the old Ralink chips.
> 

MT7630e is part of the MT76x0 family
Felix's driver is missing the baseband/rf tables for MT76x0.

The full driver for MT7610E is here
https://github.com/i80s/mtk-sources

/me now reading Felix code to adapot MT76x2 for mt7612u ...

Greetings
Ulli
