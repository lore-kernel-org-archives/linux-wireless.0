Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vk0-f41.google.com ([209.85.213.41]:34613 "EHLO
        mail-vk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932996AbcILO1o (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 12 Sep 2016 10:27:44 -0400
Received: by mail-vk0-f41.google.com with SMTP id v189so136471053vkv.1
        for <linux-wireless@vger.kernel.org>; Mon, 12 Sep 2016 07:27:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1473683031.2930.3.camel@hadess.net>
References: <688574b6-1141-f408-d397-535f1f69999e@hanno.de> <1473683031.2930.3.camel@hadess.net>
From: Anthony Wong <anthony.wong@canonical.com>
Date: Mon, 12 Sep 2016 22:27:00 +0800
Message-ID: <CAE7LaDBnTfmW+W04xukjabxgVYcqVSCa5Lfu+zO-vJc8RgXcng@mail.gmail.com> (sfid-20160912_162804_479395_4A6E6F2E)
Subject: Re: Support of rtl8723bs
To: Bastien Nocera <hadess@hadess.net>
Cc: Hanno Zulla <abos@hanno.de>, linux-wireless@vger.kernel.org,
        Jes.Sorensen@redhat.com, Larry Finger <Larry.Finger@lwfinger.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12 September 2016 at 20:23, Bastien Nocera <hadess@hadess.net> wrote:
>
> On Mon, 2016-09-12 at 11:20 +0200, Hanno Zulla wrote:
> > Hi Jes,
> > hello linux-wireless,
> >
> > I'd like to know more about the current progress of rtl8723bs support
> > for Linux.
> >
> > Googling and reading the mailing list archives found an older vendor
> > driver
> > https://github.com/hadess/rtl8723bs
>
> This is the canonical location.
>
> > plus patches at
> > https://github.com/lwfinger/rtl8723bs
>
> This is an old tree.
>
> > which both aren't ready for Linux according to
> > https://github.com/hadess/rtl8723bs/issues/96
> >
> > According to
> > https://github.com/hadess/rtl8723bs/issues/98
> >
> > there is a newer vendor driver from Realtek at
> > https://github.com/anthonywong/rtl8723bs
> > which Anthony wants to get ready for inclusion to the Ubuntu kernel.
> >
> > But after reading
> > https://marc.info/?l=linux-wireless&m=146902477024130&w=2
> > it appears that even that newer vendor driver isn't ready for Jes's
> > work.
>
> The "hadess" driver above is an older vendor driver with 2 years of
> cleanups, and lots of code removal:
>  430 files changed, 81387 insertions(+), 254812 deletions(-)
>
> Anthony's repo is just a dump of a newer version of the driver.

Indeed, the code in my git repo is simply the driver source code
extracted from what was provided by the vendor. It's pushed to github
in the hope that it can help anyone who works on supporting this wifi
device and can serve as a reference for future development.

Cheers,
Anthony

>
>
> What would be useful would be to compare the newer vendor driver with
> the last time the "hadess" driver was rebased
> (a2e5bb366f6d6c19dcab6db47b68a944256e8228) and pick out bug fixes.
>
> Anyway, as an owner of such a device, I'd like to help somehow, and
> be
> > it as a guinea pig to test on my hardware. The newer vendor driver
> > crashed on Ubuntu' 4.4 sources and doesn't compile yet on Ubuntu 4.8-
> > rc
> > sources.
> > https://github.com/anthonywong/rtl8723bs/issues/1
>
> I really don't care about the vendor driver. There's no way to track
> changes other than through code dumps.
>
> Longer term, it seems likely that improving Jes' driver is the way to
> go. At least there's 170k less lines of code to read in the rtl8723bs
> driver to get things going.
>
> Cheers
