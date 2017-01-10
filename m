Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:34204 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1754157AbdAJI1C (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 10 Jan 2017 03:27:02 -0500
Message-ID: <1484036818.5227.48.camel@coelho.fi> (sfid-20170110_092727_906710_5BF2D3CB)
From: Luca Coelho <luca@coelho.fi>
To: Fabio Coatti <fabio.coatti@gmail.com>
Cc: Andrew Donnellan <andrew.donnellan@au1.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        linuxwifi <linuxwifi@intel.com>
Date: Tue, 10 Jan 2017 10:26:58 +0200
In-Reply-To: <2231220.vMvt4J1trM@calvin>
References: <2029482.jt8IarKZJs@calvin>
         <942b4775-6027-2b99-84c7-37b7cde124b9@au1.ibm.com>
         <1484000511.5227.33.camel@coelho.fi> <2231220.vMvt4J1trM@calvin>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: kernel 4.9 iwlwifi startup error
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2017-01-10 at 09:21 +0100, Fabio Coatti wrote:
> In data martedì 10 gennaio 2017 00:21:51 CET, Luca Coelho ha scritto:
> > On Tue, 2017-01-03 at 13:42 +1100, Andrew Donnellan wrote:
> > > On 02/01/17 21:12, Fabio Coatti wrote:
> > > > Hi all,
> > > > I'm using kernel 4.9 and maybe half of the times I boot my laptop I get
> > > > the
> > > > error reported below, and the wifi does not work. I have to remove
> > > > iwlwifi (like modprobe -r iwldvm iwlwifi) and insert it again to get
> > > > things workig again. This seems a bit random, it does not happens all
> > > > the times so it could be a timing issue or even a flaky hardware
> > > > (unlikely, as I see only this issue with wifi, once it starts it works
> > > > just fine)
> > > > I'm pretty sure to have seen the same behaviour at some point in 4.8.X
> > > > release, but right now I lost the related notes.
> > > > Environment:
> > > > Distro: gentoo
> > > > gcc 5.4.0
> > > > HW: Hewlett-Packard HP EliteBook Folio 9470m/18DF, BIOS 68IBD Ver. F.63
> > > > 04/26/2016
> > > > Intel(R) Core(TM) i5-3427U CPU @ 1.80GHz
> > > > Network controller: Intel Corporation Centrino Advanced-N 6235 (rev 24)
> > > > 
> > > > Of course if more info is needed, just drop me a note.
> > > > 
> > > > I'm not subscribed to mailing lists, so please keep me in CC: for any
> > > > information request.
> > > > 
> > > > Many thanks.
> > > 
> > > I've so far seen this once on my laptop, a Samsung NP540U3C (don't have
> > > it with me right now, so I'm not sure what the wifi chipset is), running
> > > with a Debian 4.9 kernel.
> > 
> > This bug has already been reported in bugzilla:
> > 
> > https://bugzilla.kernel.org/show_bug.cgi?id=190281
> > 
> > Did you have any problems with older kernel versions? If so, would it be
> > possible for you to bisect?
> 
> 
> Well, it happens on a laptop that I use quite intensively, so it will take 
> some time to bisect. However, in the meantime I checked the old logs and the 
> first recorded occurrence happened with 4.8.10 release and firmware version 
> 18.168.6.1

Thanks! Let's continue tracking this in bugzilla.

--
Cheers,
Luca.
