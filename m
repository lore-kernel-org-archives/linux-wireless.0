Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:58809 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932222Ab0HJQxW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Aug 2010 12:53:22 -0400
MIME-Version: 1.0
In-Reply-To: <20100810101521.0dcd4393.sfr@canb.auug.org.au>
References: <20100809164346.6e30cf8c.akpm@linux-foundation.org>
	<20100810101521.0dcd4393.sfr@canb.auug.org.au>
Date: Tue, 10 Aug 2010 18:53:20 +0200
Message-ID: <AANLkTimtZ7H=rT68V6UGC2GBky8z9VJ5m6-pwFHfm7yw@mail.gmail.com>
Subject: Re: i386 allmodconfig, current mainline
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Greg KH <greg@kroah.com>,
	David Woodhouse <dwmw2@infradead.org>,
	Mike Frysinger <vapier@gentoo.org>,
	Jesse Barnes <jbarnes@virtuousgeek.org>,
	Kevin Curtis <kevin.curtis@farsite.co.uk>,
	Phillip Lougher <phillip@lougher.demon.co.uk>,
	Faisal Latif <faisal.latif@intel.com>,
	Chien Tung <chien.tin.tung@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Samuel Ortiz <samuel.ortiz@intel.com>,
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org, x86@kernel.org,
	linux-rdma@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 10, 2010 at 02:15, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> On Mon, 9 Aug 2010 16:43:46 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:
>>
>> Guys.  What's goin' on out there?
>
> I guess we are all so up to date that noone does 32 bit builds any
> more ...  Also noone is bothering to look at the build logs:
>
> linus tree: http://kisskb.ellerman.id.au/kisskb/branch/3/
> linux-next: http://kisskb.ellerman.id.au/kisskb/branch/9/

Yeah, we have build failures migrating from -next to -linus :-(

BTW, still no one has commented on http://lkml.org/lkml/2010/7/13/378?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
