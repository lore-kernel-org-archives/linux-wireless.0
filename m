Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36968 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933425AbeBMPlY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 13 Feb 2018 10:41:24 -0500
Date: Tue, 13 Feb 2018 16:41:25 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: James Hogan <james.hogan@mips.com>
Cc: stable@vger.kernel.org, Kalle Valo <kvalo@codeaurora.org>,
        Adric Blake <promarbler14@gmail.com>, m@bues.ch,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: B43 driver no longer works in Linux 4.15 (bisected)
Message-ID: <20180213154125.GC5919@kroah.com> (sfid-20180213_164139_772474_A2926286)
References: <CAE1jjefE1qjgcHMik36Na0OYoFON+kCi5cEDSq=y11HdsyPn0Q@mail.gmail.com>
 <20180205183324.GD8479@saruman>
 <87sha68cv9.fsf@kamboji.qca.qualcomm.com>
 <20180212152231.GK11819@jhogan-linux.mipstec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180212152231.GK11819@jhogan-linux.mipstec.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 12, 2018 at 03:22:32PM +0000, James Hogan wrote:
> On Mon, Feb 12, 2018 at 05:08:10PM +0200, Kalle Valo wrote:
> > James Hogan <jhogan@kernel.org> writes:
> > > On Mon, Feb 05, 2018 at 01:23:31PM -0500, Adric Blake wrote:
> > >> I bisected to this "first bad commit:"
> > >> 
> > >> commit 58eae1416b804d900014d84feadda7195007cc30
> > >> Author: James Hogan <jhogan@kernel.org>
> > >> Date:   Mon Jan 15 21:17:14 2018 +0000
> > >> 
> > >>     ssb: Disable PCI host for PCI_DRIVERS_GENERIC
> > >
> > > Yes, really sorry about that and thanks for going to the effort of
> > > bisecting. There is a patch here:
> > > https://patchwork.kernel.org/patch/10185397/
> > >
> > > which is applied to linux-next as commit
> > > a9e6d44ddeccd3522670e641f1ed9b068e746ff7, and is tagged for stable,
> > > though I've just noticed the stable email address is incorrect... I'll
> > > make sure it gets applied to the 4.15 stable branch though as soon as
> > > I notice its merged.
> > 
> > The commit is now in v4.16-rc1.
> 
> Yes, thanks,
> 
> Greg: Please can commit a9e6d44ddeccd3522670e641f1ed9b068e746ff7 ("ssb:
> Do not disable PCI host on non-Mips") be applied to 4.15 stable (the
> wrong stable email address was Cc'd in the commit message).

Now applied, thanks.

greg k-h
