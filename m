Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from electric-eye.fr.zoreil.com ([213.41.134.224]:33749 "EHLO
	fr.zoreil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754050AbXEZRDh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 May 2007 13:03:37 -0400
Date: Sat, 26 May 2007 18:46:31 +0200
From: Francois Romieu <romieu@fr.zoreil.com>
To: Uwe Bugla <uwe.bugla@gmx.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Michael Buesch <mb@bu3sch.de>,
	Maximilian Engelhardt <maxi@daemonizer.de>,
	linux-wireless@vger.kernel.org,
	linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: BUG in 2.6.22-rc2-mm1: NIC module b44.c broken (Broadcom 4400)
Message-ID: <20070526164631.GA2176@electric-eye.fr.zoreil.com>
References: <20070524195616.234280@gmx.net> <200705261750.48816.mb@bu3sch.de> <20070526091309.0af20971.akpm@linux-foundation.org> <200705261820.52240.uwe.bugla@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200705261820.52240.uwe.bugla@gmx.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Uwe Bugla <uwe.bugla@gmx.de> :
> Am Samstag, 26. Mai 2007 18:13 schrieben Sie:
[...]
> > Uwe, http://userweb.kernel.org/~akpm/git-wireless.patch.gz is the current
> > wireless tree.  That's a patch against 2.6.22-rc3.  Could you please test
> > that?  If that works then we know that the bug probably lies outside the
> > b44 driver (or it was subsequently fixed).
> 
> Thank you, Andrew, just wait for a while. I am gonna try.....

Please post the .config and the dmesg for the kernels that you try too.

-- 
Ueimor
