Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr1-f65.google.com ([209.85.221.65]:38572 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727265AbeHaRWv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 31 Aug 2018 13:22:51 -0400
Received: by mail-wr1-f65.google.com with SMTP id w11-v6so11189123wrc.5
        for <linux-wireless@vger.kernel.org>; Fri, 31 Aug 2018 06:15:24 -0700 (PDT)
Date: Fri, 31 Aug 2018 15:15:21 +0200
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To: Kristian Evensen <kristian.evensen@gmail.com>
Cc: arend.vanspriel@broadcom.com, kvalo@codeaurora.org,
        linux-wireless@vger.kernel.org,
        Network Development <netdev@vger.kernel.org>
Subject: Re: [PATCH] mt76: Enable NL80211_EXT_FEATURE_CQM_RSSI_LIST
Message-ID: <20180831131520.GC6236@localhost.localdomain> (sfid-20180831_151533_742026_B25D5C34)
References: <20180812145207.11395-1-kristian.evensen@gmail.com>
 <871sb3zc3v.fsf@kamboji.qca.qualcomm.com>
 <5B708025.4090906@broadcom.com>
 <CAJ0CqmVZNAnHwnU4YqRRv7R8DyHi2MiFJr1bvQDPVszUU5Ez3g@mail.gmail.com>
 <CAKfDRXia3zwW9Q=7RZGqK_DWCsyQzG4KEZHsyHzGcNb70Ge1kA@mail.gmail.com>
 <CAKfDRXjSLpGU6cOBHDdLxoNzaXWmgpYO7E4vjGg-J8AxOZiTyw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAKfDRXjSLpGU6cOBHDdLxoNzaXWmgpYO7E4vjGg-J8AxOZiTyw@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Hi Lorenzo,
> 
> On Mon, Aug 13, 2018 at 4:25 PM Kristian Evensen
> <kristian.evensen@gmail.com> wrote:
> > On Mon, Aug 13, 2018 at 12:55 PM Lorenzo Bianconi
> > <lorenzo.bianconi@redhat.com> wrote:
> > > I am AFK at the moment, I will test that patch when I am back from vacations.
> 
> I hope you enjoyed you vacations. Have you been able to test if any of
> the mt76 USB-dongles support CQM?

I have not tested your patch yet sorry but there are no differences
between pcie and usb devices regarding rx RSSI management (both of them use
shared code for it) so I guess the feature will work on usb devices if
it works on pcie ones.

Regards,
Lorenzo

> 
> BR,
> Kristian
