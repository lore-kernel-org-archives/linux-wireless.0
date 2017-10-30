Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f180.google.com ([209.85.223.180]:55808 "EHLO
        mail-io0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751804AbdJ3Sur (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 30 Oct 2017 14:50:47 -0400
Received: by mail-io0-f180.google.com with SMTP id p186so29467534ioe.12
        for <linux-wireless@vger.kernel.org>; Mon, 30 Oct 2017 11:50:46 -0700 (PDT)
Date: Mon, 30 Oct 2017 11:50:43 -0700
From: Brian Norris <briannorris@chromium.org>
To: Ganapathi Bhat <gbhat@marvell.com>
Cc: "linux-firmware@kernel.org" <linux-firmware@kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        James Cao <jcao@marvell.com>, Cathy Luo <cluo@marvell.com>,
        Mangesh Malusare <mmangesh@marvell.com>,
        Xinming Hu <huxm@marvell.com>,
        Zhiyuan Yang <yangzy@marvell.com>,
        Karthik Doddayennegere Ananthapadmanabha <karthida@marvell.com>
Subject: Re: [EXT] Re: pull-request mwifiex-firmware 2017-10-30
Message-ID: <20171030185043.GA100626@google.com> (sfid-20171030_195050_513125_EFE05DAB)
References: <9370b3238604464b85bf0c4f8ac79c71@SC-EXCH02.marvell.com>
 <20171030170308.GA80479@google.com>
 <fb8d8eece601415c83167c500d80ff2f@SC-EXCH02.marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <fb8d8eece601415c83167c500d80ff2f@SC-EXCH02.marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 30, 2017 at 06:47:58PM +0000, Ganapathi Bhat wrote:
> > ----------------------------------------------------------------------
> > On Mon, Oct 30, 2017 at 02:13:31PM +0000, Ganapathi Bhat wrote:

> > > --- a/WHENCE
> > > +++ b/WHENCE
> > > @@ -757,7 +757,7 @@ File: mrvl/pcieuart8997_combo_v4.bin
> > >  Version: 16.68.1.p70
> > >
> > >  File: mrvl/pcieusb8997_combo_v4.bin
> > > -Version: 16.68.1.p133
> > > +Version: 16.68.1.p40
> >
> > This says .p40, whereas the commit message (and the version tag within the
> > firmware) says p140. I think you're missing a "1".
>  I did miss this.  Will it make sense to trigger another pull request with just the version change?

Sure, why not? Email is cheap, and so is git. Either rewrite the commit
or add another on top to fix it...
