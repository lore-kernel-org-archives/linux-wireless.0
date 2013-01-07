Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:13983 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751195Ab3AGLIJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Jan 2013 06:08:09 -0500
Date: Mon, 7 Jan 2013 12:08:00 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Tino Keitel <tino.keitel@tikei.de>
Cc: linux-wireless@vger.kernel.org
Subject: Re: Power saving features for iwl4965
Message-ID: <20130107110759.GC6931@redhat.com> (sfid-20130107_120815_075244_EA3662A1)
References: <20120418203543.GA16000@x61.home>
 <20120425122554.GD2466@redhat.com>
 <20120503182853.GA12461@mac.home>
 <20121226185425.GA12627@x61.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20121226185425.GA12627@x61.home>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi

On Wed, Dec 26, 2012 at 07:54:25PM +0100, Tino Keitel wrote:
> On Thu, May 03, 2012 at 20:28:53 +0200, Tino Keitel wrote:
> > On Wed, Apr 25, 2012 at 14:25:55 +0200, Stanislaw Gruszka wrote:
> > > On Wed, Apr 18, 2012 at 10:35:43PM +0200, Tino Keitel wrote:
> > > > up to 2.6.38, the iwl4965 driver was able to use power saving features
> > > > by invoking "iwconfig <interface> power on", at least when unsetting
> > > > the broken_powersave variable.
> > > > 
> > > > 2.6.39 introduced a new iwlegacy driver for iwl4965 hardware, which was
> > > > missing power saving.  I was able to port the 2.6.38 driver up to
> > > > kernel 3.1, but it got too complicated for me with 3.2. 
> > > > 
> > > > Are there any plans to fix this power usage regression at some point in
> > > > the iwlegacy driver? I think there are still a lot of iwl4965 users out
> > > > there.
> > > Yes, adding PS support is on my iwlegacy TODO list.
> > 
> > Thanks, I'd be glad if I could help, testing etc.
> 
> Hi Stanislaw,
> 
> is there any progress regarding this? If not, I could try to implement
> it in the current kernel.  However, I don't have any knowlegde about
> hardware related features.  If you have, maybe I could use your
> knowledge to do it myself.

I posted patch here
http://marc.info/?l=linux-wireless&m=135601033021616&w=2

But I did not review code regarding power save to catch possible
problems. Testing are bug reporting are welcome ...

Thanks
Stanislaw
