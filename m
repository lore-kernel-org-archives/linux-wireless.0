Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:59016 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1759059AbdEXIZt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 24 May 2017 04:25:49 -0400
Message-ID: <1495614342.24885.69.camel@coelho.fi> (sfid-20170524_102651_479210_8877FAE8)
From: Luca Coelho <luca@coelho.fi>
To: sedat.dilek@gmail.com
Cc: linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>
Date: Wed, 24 May 2017 11:25:42 +0300
In-Reply-To: <CA+icZUUO72+epsLDFmXWpRWQV7_vkR0LVyqitoZ1XLEbxr+ATw@mail.gmail.com>
References: <CA+icZUU3TwPOnABirE+0kT1tjr=fWLXPJFeCprsCSvXmqiiC+A@mail.gmail.com>
         <1495612648.24885.62.camel@coelho.fi>
         <CA+icZUUO72+epsLDFmXWpRWQV7_vkR0LVyqitoZ1XLEbxr+ATw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: [Linux-4.9.28] iwlwifi 6230 AGN: Microcode SW error detected
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2017-05-24 at 10:15 +0200, Sedat Dilek wrote:
> On Wed, May 24, 2017 at 9:57 AM, Luca Coelho <luca@coelho.fi> wrote:
> > On Wed, 2017-05-24 at 09:41 +0200, Sedat Dilek wrote:
> > > Hi,
> > 
> > Hi Sedat,
> > 
> > 
> > > I am seeing the below/following in my logs today.
> > > My AP is a Lenovo Moto-Z with LTE support.
> > > 
> > > Can you comment on this?
> > > Is this a "buggy" firmware and a new firmware around?
> > 
> > Looks like a buggy firmware, but unfortunately we don't have a newer
> > firmware with a fix for this.
> > 
> > 
> > > My kernel-config and full dmesg are attached.
> > > 
> > > If you need further informations, please let me know.
> > > 
> > > Hope this helps.
> > > 
> > > Regards,
> > > - Sedat -
> > > 
> > > P.S.: Excerpts from my dmesg-log.
> > > 
> > > [   16.708016] iwlwifi 0000:01:00.0: Detected Intel(R) Centrino(R)
> > > Advanced-N 6230 AGN, REV=0xB0
> > 
> > This is a really old NIC (6+ years old) and unfortunately we can't
> > provide firmware fixes for it anymore.
> > 
> > Hopefully the recovery flow in the driver recovers the connectivity and
> > everything continues working fine.
> > 
> 
> Thanks for the fast reply.
> 
> Intel was(?) a good choice is my conclusion after getting no more
> replies/fixes for my SandyBridge-GPU from intel-gfx guys.
> This Samsung Ultrabook is 5 years young.
> I can understand that fixing a 6 years old NIC is not your prio #1.
> 
> As an example, there is no vulkan support for my GPU, so it's time for a change?
> 
> No glue if other hardware vendors have better support.

We still do our best effort to fix driver bugs for these old NICs, but
unfortunately fixing the FW is a much more complicated issue and there's
nothing we can do. :(

Regarding the GPU stuff, I really can't comment, since I don't know much
about it.

--
Cheers,
Luca.
