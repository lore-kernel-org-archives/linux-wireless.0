Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f221.google.com ([209.85.220.221]:59244 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752811AbZKLThj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Nov 2009 14:37:39 -0500
Received: by fxm21 with SMTP id 21so2630257fxm.21
        for <linux-wireless@vger.kernel.org>; Thu, 12 Nov 2009 11:37:44 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: tim.gardner@canonical.com
Subject: Re: Prism54/p54pci
Date: Thu, 12 Nov 2009 20:37:38 +0100
Cc: James Grossmann <cctsurf@gmail.com>, linux-wireless@vger.kernel.org
References: <167ae39b0910071400n218d3d9ey7711b1011f290a73@mail.gmail.com> <200911121717.36906.chunkeey@googlemail.com> <4AFC5A5E.1050405@canonical.com>
In-Reply-To: <4AFC5A5E.1050405@canonical.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <200911122037.39145.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 12 November 2009 19:56:30 Tim Gardner wrote:
> Christian Lamparter wrote:
> > On Friday 06 November 2009 21:52:42 James Grossmann wrote:
> >> my caps lock & scroll lock leds are not blinking, and yet the computer
> >> is frozen.  (I'm not the best at terminology, I guess that might not
> >> be defined as a hard lock.)  I get no odd messages in my syslog.  I am
> >> using Ubuntu right now, so I'm guessing that they have all the
> >> prettyness going that they can, covering the important messages, but
> >> as it's not an actual oops, I'm not certain that's hurting us.
> > just a update:
> > 
> > I can confirm the freeze with ubuntu 9.10 (2.6.31-14 & 2.6.31-15-generic)
> > + compat-wireless + p54pci (either as backport module or compiled from git).
> > The original modules (shipped with 2.6.31-14/15) are fine though..?!
>
> The Ubuntu Karmic linux-backports-modules package is based on
> compat-wireless-2.6.32-rc4. I'm wondering if its something specific to
> the p54pci driver? I'm using iwlagn (4965) from that package with no
> problems (so far).

I put a ath5k card into the same machine and tried with the same
compat-wireless modules. Surprise, surprise: no problems...

The affected device works fine with the current wireless-testing(pulled today)
and a vanilla 2.6.31.6 + compat-wireless (from today's git).

I've no idea what voodoo is going on here, maybe there is
something wrong in compat-wireless pci glue code (if there's any?!)

> Its not clear what version of stable compat-wireless you've tried.
> Does compat-wireless-2.6.32-rc6 exhibit the same problem?
"compiled from git", which should be compat-wireless-2009-11-12.tar.bz2
and therefore -rc6.

Regards,
	Chr
