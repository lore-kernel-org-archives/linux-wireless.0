Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:45088 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932490AbdJ3TCv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 30 Oct 2017 15:02:51 -0400
From: Ganapathi Bhat <gbhat@marvell.com>
To: Brian Norris <briannorris@chromium.org>
CC: "linux-firmware@kernel.org" <linux-firmware@kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        James Cao <jcao@marvell.com>, Cathy Luo <cluo@marvell.com>,
        Mangesh Malusare <mmangesh@marvell.com>,
        Xinming Hu <huxm@marvell.com>,
        Zhiyuan Yang <yangzy@marvell.com>,
        Karthik Doddayennegere Ananthapadmanabha <karthida@marvell.com>
Subject: RE: [EXT] Re: pull-request mwifiex-firmware 2017-10-30
Date: Mon, 30 Oct 2017 19:02:46 +0000
Message-ID: <b2af992abc624cdb8ae5a4c1d2d94090@SC-EXCH02.marvell.com> (sfid-20171030_200254_691973_F0DC73B2)
References: <9370b3238604464b85bf0c4f8ac79c71@SC-EXCH02.marvell.com>
 <20171030170308.GA80479@google.com>
 <fb8d8eece601415c83167c500d80ff2f@SC-EXCH02.marvell.com>
 <20171030185043.GA100626@google.com>
In-Reply-To: <20171030185043.GA100626@google.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Brian,

> On Mon, Oct 30, 2017 at 06:47:58PM +0000, Ganapathi Bhat wrote:
> > > --------------------------------------------------------------------
> > > -- On Mon, Oct 30, 2017 at 02:13:31PM +0000, Ganapathi Bhat wrote:
>
> > > > --- a/WHENCE
> > > > +++ b/WHENCE
> > > > @@ -757,7 +757,7 @@ File: mrvl/pcieuart8997_combo_v4.bin
> > > >  Version: 16.68.1.p70
> > > >
> > > >  File: mrvl/pcieusb8997_combo_v4.bin
> > > > -Version: 16.68.1.p133
> > > > +Version: 16.68.1.p40
> > >
> > > This says .p40, whereas the commit message (and the version tag
> > > within the
> > > firmware) says p140. I think you're missing a "1".
> >  I did miss this.  Will it make sense to trigger another pull request with just
> the version change?
>
> Sure, why not? Email is cheap, and so is git. Either rewrite the commit or add
> another on top to fix it...
Ok, prepared the follow up patch.  Let me also know if we can send a merge request while previous one is pending?
If that is not the case I will send it as soon as the current request is merged.

Thanks,
Ganapathi
