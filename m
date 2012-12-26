Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eazy.amigager.de ([213.239.192.238]:53415 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752113Ab2LZTBj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Dec 2012 14:01:39 -0500
Received: from x61.home (p4FDDDC1A.dip.t-dialin.net [79.221.220.26])
	by eazy.amigager.de (Postfix) with ESMTPA id 4BA44F48026
	for <linux-wireless@vger.kernel.org>; Wed, 26 Dec 2012 19:54:31 +0100 (CET)
Date: Wed, 26 Dec 2012 19:54:25 +0100
From: Tino Keitel <tino.keitel@tikei.de>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: Power saving features for iwl4965
Message-ID: <20121226185425.GA12627@x61.home> (sfid-20121226_200145_036593_8E57594A)
References: <20120418203543.GA16000@x61.home>
 <20120425122554.GD2466@redhat.com>
 <20120503182853.GA12461@mac.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20120503182853.GA12461@mac.home>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 03, 2012 at 20:28:53 +0200, Tino Keitel wrote:
> On Wed, Apr 25, 2012 at 14:25:55 +0200, Stanislaw Gruszka wrote:
> > On Wed, Apr 18, 2012 at 10:35:43PM +0200, Tino Keitel wrote:
> > > up to 2.6.38, the iwl4965 driver was able to use power saving features
> > > by invoking "iwconfig <interface> power on", at least when unsetting
> > > the broken_powersave variable.
> > > 
> > > 2.6.39 introduced a new iwlegacy driver for iwl4965 hardware, which was
> > > missing power saving.  I was able to port the 2.6.38 driver up to
> > > kernel 3.1, but it got too complicated for me with 3.2. 
> > > 
> > > Are there any plans to fix this power usage regression at some point in
> > > the iwlegacy driver? I think there are still a lot of iwl4965 users out
> > > there.
> > Yes, adding PS support is on my iwlegacy TODO list.
> 
> Thanks, I'd be glad if I could help, testing etc.

Hi Stanislaw,

is there any progress regarding this? If not, I could try to implement
it in the current kernel.  However, I don't have any knowlegde about
hardware related features.  If you have, maybe I could use your
knowledge to do it myself.

Regards,
Tino

