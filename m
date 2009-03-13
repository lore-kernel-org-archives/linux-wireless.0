Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f176.google.com ([209.85.220.176]:56202 "EHLO
	mail-fx0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752339AbZCMKog (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Mar 2009 06:44:36 -0400
Received: by fxm24 with SMTP id 24so2589272fxm.37
        for <linux-wireless@vger.kernel.org>; Fri, 13 Mar 2009 03:44:33 -0700 (PDT)
Subject: Re: [ath5k-devel] Thanks for TX power patch
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Bob Copeland <me@bobcopeland.com>
Cc: ath5k-devel <ath5k-devel@lists.ath5k.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Nick Kossifidis <mick@madwifi-project.org>
In-Reply-To: <1236895489.17849.3.camel@maxim-laptop>
References: <1236728344.26432.26.camel@maxim-laptop>
	 <d94c510d0903110115s620c7851g391fcf00e644a113@mail.gmail.com>
	 <b6c5339f0903120714rda8ec3ev2c2fbfaaf0b21351@mail.gmail.com>
	 <1236893111.30325.10.camel@maxim-laptop>
	 <b6c5339f0903121432h26d71d6nd901f12d0c10e7bc@mail.gmail.com>
	 <b6c5339f0903121433r7bbf2dd8l484d15446241dccd@mail.gmail.com>
	 <1236895489.17849.3.camel@maxim-laptop>
Content-Type: text/plain
Date: Fri, 13 Mar 2009 12:38:28 +0200
Message-Id: <1236940708.4708.14.camel@maxim-laptop> (sfid-20090313_114438_559441_0DD4EA18)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2009-03-13 at 00:04 +0200, Maxim Levitsky wrote:
> On Thu, 2009-03-12 at 17:33 -0400, Bob Copeland wrote:
> > On Thu, Mar 12, 2009 at 5:32 PM, Bob Copeland <me@bobcopeland.com> wrote:
> > > On Thu, Mar 12, 2009 at 5:25 PM, Maxim Levitsky <maximlevitsky@gmail.com> wrote:
> > >> Just to be clear, I got oopses, and hangs after resume from disk by just
> > >> using compat-wireless-2009-03-10 _without_ Nick's patches.
> > >
> > > Interesting, I thought you said that, but I tried the same stuff on
> > > plain wireless testing and didn't have any problems.
> > 
> > Oh, and you said compat-wireless -- can you try wireless-testing just
> > to make sure it's not some structure definition build conflict with
> > compat-wireless?
> > 
> 
> Will do, soon.
> 
> Best regards,
> 	Maxim Levitsky
> 

Just compiled and installed latest wireless-testing with Nick's patches,
and your patch.

System is rock solid, module reload/s2disk/s2ram/long transfers work
just fine.

(I tested against my laptop, and got 1.5 Mbytes/s in both directions.
which is maximum speed possible - yes I know that everything goes
through AP...)

Now my both wifi device are supported almost perfectly:
still small issues with rate control on iwl3945, and
not that great led on ath5k - both issues are pure software issues, and
when I have time I will look at improving led algorithm.


Big thanks,
	Best regards,
		Maxim Levitsky

