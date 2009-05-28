Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from www.tglx.de ([62.245.132.106]:54591 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755468AbZE1JJA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 May 2009 05:09:00 -0400
Date: Thu, 28 May 2009 11:07:56 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-wireless@vger.kernel.org,
	Steven Rostedt <rostedt@goodmis.org>,
	bugzilla-daemon@bugzilla.kernel.org,
	bugme-daemon@bugzilla.kernel.org, dandart@googlemail.com
Subject: Re: [Bugme-new] [Bug 13317] New: No rt2x00 modules in RT kernels.
In-Reply-To: <20090528000253.c731179c.akpm@linux-foundation.org>
Message-ID: <alpine.LFD.2.00.0905281103310.3397@localhost.localdomain>
References: <bug-13317-10286@http.bugzilla.kernel.org/> <20090528000253.c731179c.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 28 May 2009, Andrew Morton wrote:
> > Is there a problem with using rt2x00 kernel modules with realtime kernels?
> > In the info page it says that they need the symbol "BROKEN" which is probably
> > to tell us that we can't use it. I can't compile it into kernels with an RT
> > patch.
> > Why? What's wrong with this mix of module and tree? Is there any way to make
> > them happily coexist?
> > 
> 
> Good question, but bugzilla isn't a good place to ask it.
> 
> Presumably there's some bustage in the rt2x00 driver which makes it not
> work with -rt kernels.
> 
> Did the -rt guys tell the wireless guys about this?

There was some build failure which got fixed in meantime, but I forgot
to remove the broken flag.

Will do with the next release.

Thanks,

	tglx

