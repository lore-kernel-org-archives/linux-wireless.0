Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:46091 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751659Ab2H2PGq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Aug 2012 11:06:46 -0400
Received: by eaac11 with SMTP id c11so216393eaa.19
        for <linux-wireless@vger.kernel.org>; Wed, 29 Aug 2012 08:06:45 -0700 (PDT)
Date: Wed, 29 Aug 2012 17:06:27 +0200
From: Anisse Astier <anisse@astier.eu>
To: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
Subject: Re: rtl8192ce : freeze after connecting to network with FW Power
 Save on
Message-ID: <20120829170627.5b15ec9c@destiny.ordissimo> (sfid-20120829_170650_521613_A1047E2F)
In-Reply-To: <20120524191037.19e10917@destiny.ordissimo>
References: <20120515152951.7cc4f84b@destiny.ordissimo>
	<4FB26D6B.2030005@lwfinger.net>
	<20120515170405.7f6510f2@destiny.ordissimo>
	<4FB28834.4000803@lwfinger.net>
	<20120516124133.69f57311@destiny.ordissimo>
	<4FB3D348.2010700@lwfinger.net>
	<20120524191037.19e10917@destiny.ordissimo>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Thu, 24 May 2012 19:10:37 +0200, Anisse Astier <anisse@astier.eu> wrote :

> (sorry for the delay, I got caught up in other things, and forgot to send
> answer email)
> 
> On Wed, 16 May 2012 11:18:16 -0500, Larry Finger <Larry.Finger@lwfinger.net> wrote :
> 
> > On 05/16/2012 05:41 AM, Anisse Astier wrote:
> > > I enabled the following options:
> > > CONFIG_LOCKDEP_SUPPORT=y
> > > CONFIG_LOCKDEP=y
> > > CONFIG_DEBUG_LOCKDEP=y
> > > CONFIG_DEBUG_SPINLOCK=y
> > > CONFIG_DEBUG_MUTEXES=y
> > > But it didn't detect any lockup yet, and machine still hangs. I'll try
> > > CONFIG_PROVE_LOCKING.
> > >
> > > Enabling CONFIG_DEBUG_INFO seems to make the problem go away...
> > 
> > That may explain why I never see the problem. I do not think I have ever 
> > generated a kernel with that parameter disabled, and my distro's kernels have it 
> > enabled. Does anything new get logged (dmesg output) when that parameter is enabled?
> > 
> 
> There's no zero difference in dmesg output. Have you tried with
> debug_info disabled?
> 
> Unfortunately, I've lost access to this hardware, so I won't be able to
> do more test for quite some time.


I got hold of the hardware again. Problem is still here with today's
wireless-next (a4881cc45a3fab).
PROVE_LOCKING doesn't find any discrepancy.
I tried the new firmware files as well, no change.

Regards,

Anisse
