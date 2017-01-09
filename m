Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:34126 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751838AbdAIWVz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 9 Jan 2017 17:21:55 -0500
Message-ID: <1484000511.5227.33.camel@coelho.fi> (sfid-20170109_232216_287193_E5704B17)
From: Luca Coelho <luca@coelho.fi>
To: Andrew Donnellan <andrew.donnellan@au1.ibm.com>,
        Fabio Coatti <fabio.coatti@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Cc: linuxwifi <linuxwifi@intel.com>
Date: Tue, 10 Jan 2017 00:21:51 +0200
In-Reply-To: <942b4775-6027-2b99-84c7-37b7cde124b9@au1.ibm.com>
References: <2029482.jt8IarKZJs@calvin>
         <942b4775-6027-2b99-84c7-37b7cde124b9@au1.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: kernel 4.9 iwlwifi startup error
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2017-01-03 at 13:42 +1100, Andrew Donnellan wrote:
> On 02/01/17 21:12, Fabio Coatti wrote:
> > Hi all,
> > I'm using kernel 4.9 and maybe half of the times I boot my laptop I get the
> > error reported below, and the wifi does not work. I have to remove iwlwifi (like
> > modprobe -r iwldvm iwlwifi) and insert it again to get things workig again.
> > This seems a bit random, it does not happens all the times so it could be a
> > timing issue or even a flaky hardware (unlikely, as I see only this issue with
> > wifi, once it starts it works just fine)
> > I'm pretty sure to have seen the same behaviour at some point in 4.8.X
> > release, but right now I lost the related notes.
> > Environment:
> > Distro: gentoo
> > gcc 5.4.0
> > HW: Hewlett-Packard HP EliteBook Folio 9470m/18DF, BIOS 68IBD Ver. F.63
> > 04/26/2016
> > Intel(R) Core(TM) i5-3427U CPU @ 1.80GHz
> > Network controller: Intel Corporation Centrino Advanced-N 6235 (rev 24)
> > 
> > Of course if more info is needed, just drop me a note.
> > 
> > I'm not subscribed to mailing lists, so please keep me in CC: for any
> > information request.
> > 
> > Many thanks.
> 
> I've so far seen this once on my laptop, a Samsung NP540U3C (don't have 
> it with me right now, so I'm not sure what the wifi chipset is), running 
> with a Debian 4.9 kernel.

This bug has already been reported in bugzilla:

https://bugzilla.kernel.org/show_bug.cgi?id=190281

Did you have any problems with older kernel versions? If so, would it be
possible for you to bisect?

--
Cheers,
Luca.
