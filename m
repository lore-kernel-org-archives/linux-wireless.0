Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:51719 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933952Ab0HLQUS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Aug 2010 12:20:18 -0400
Date: Thu, 12 Aug 2010 09:19:07 -0700
From: Greg KH <gregkh@suse.de>
To: Gauss Frank <gaussfrank@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	linux-wireless@vger.kernel.org,
	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
	Jerry chuang <wlanfae@realtek.com>,
	Florian Schilhabel <florian.c.schilhabel@googlemail.com>
Subject: Re: Hi,Linus Torvalds. There's a problem in r8192u driver in Linux
 new kernel.
Message-ID: <20100812161907.GA25082@suse.de>
References: <AANLkTi=1NaRKc8QrQBGwU+c_17D86_Cqu9MopR_rso0H@mail.gmail.com>
 <AANLkTin3qXSbuWejTGJzz6cO6fycK4HqU4gn4gF1wEdp@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <AANLkTin3qXSbuWejTGJzz6cO6fycK4HqU4gn4gF1wEdp@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 12, 2010 at 09:06:07AM -0700, Linus Torvalds wrote:
> On Thu, Aug 12, 2010 at 3:24 AM, Gauss Frank <gaussfrank@gmail.com> wrote:
> > I'm using Debian and Ubuntu.
> >
> > In Ubuntu, I compiled Linux 2.6.35-1,which contains RealTek 8192U Wireless
> > Driver. I'd installed firmware for r8192u, and I tried to connect to
> > wireless.

Can you try a kernel.org kernel release, and not a Ubuntu kernel?  If
not, you're going to have to report this to the Ubuntu developers, not
much we can do here.

If so, can you see if the in-kernel version of the driver has ever
worked for your system?  Try an older release, like 2.6.34 or 2.6.32 and
see if that works.

thanks,

greg k-h
