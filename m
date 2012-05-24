Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:45428 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933652Ab2EXRK5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 May 2012 13:10:57 -0400
Received: by eeit10 with SMTP id t10so3994eei.19
        for <linux-wireless@vger.kernel.org>; Thu, 24 May 2012 10:10:56 -0700 (PDT)
Date: Thu, 24 May 2012 19:10:37 +0200
From: Anisse Astier <anisse@astier.eu>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: rtl8192ce : freeze after connecting to network with FW Power
 Save on
Message-ID: <20120524191037.19e10917@destiny.ordissimo> (sfid-20120524_191111_945628_AFA23B05)
In-Reply-To: <4FB3D348.2010700@lwfinger.net>
References: <20120515152951.7cc4f84b@destiny.ordissimo>
	<4FB26D6B.2030005@lwfinger.net>
	<20120515170405.7f6510f2@destiny.ordissimo>
	<4FB28834.4000803@lwfinger.net>
	<20120516124133.69f57311@destiny.ordissimo>
	<4FB3D348.2010700@lwfinger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

(sorry for the delay, I got caught up in other things, and forgot to send
answer email)

On Wed, 16 May 2012 11:18:16 -0500, Larry Finger <Larry.Finger@lwfinger.net> wrote :

> On 05/16/2012 05:41 AM, Anisse Astier wrote:
> > I enabled the following options:
> > CONFIG_LOCKDEP_SUPPORT=y
> > CONFIG_LOCKDEP=y
> > CONFIG_DEBUG_LOCKDEP=y
> > CONFIG_DEBUG_SPINLOCK=y
> > CONFIG_DEBUG_MUTEXES=y
> > But it didn't detect any lockup yet, and machine still hangs. I'll try
> > CONFIG_PROVE_LOCKING.
> >
> > Enabling CONFIG_DEBUG_INFO seems to make the problem go away...
> 
> That may explain why I never see the problem. I do not think I have ever 
> generated a kernel with that parameter disabled, and my distro's kernels have it 
> enabled. Does anything new get logged (dmesg output) when that parameter is enabled?
> 

There's no zero difference in dmesg output. Have you tried with
debug_info disabled?

Unfortunately, I've lost access to this hardware, so I won't be able to
do more test for quite some time.
