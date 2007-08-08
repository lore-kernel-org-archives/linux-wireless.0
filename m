Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50088 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760378AbXHHX7w (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Aug 2007 19:59:52 -0400
Date: Wed, 8 Aug 2007 16:58:21 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Aurelien Jarno <aurelien@aurel32.net>,
	Michael Buesch <mb@bu3sch.de>,
	John Linville <linville@tuxdriver.com>,
	Felix Fietkau <nbd@openwrt.org>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ssb: Make extif driver compilation depend on extif  config
Message-Id: <20070808165821.c2a6f290.akpm@linux-foundation.org>
In-Reply-To: <20070808164327.45803a64.akpm@linux-foundation.org>
References: <200708071744.40287.mb@bu3sch.de>
	<20070808154813.abf55801.akpm@linux-foundation.org>
	<46BA4E24.3060400@aurel32.net>
	<20070808164327.45803a64.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 8 Aug 2007 16:43:27 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> I'm hopelessly confused by the ssb stuff.  I'm not sure if I have all the
> right stuff, all the latest stuff and I don't understand why some is going
> into git-wireless and some is not.

So I dropped the duplicated patch, then a few other things which appeared to depend
on it and now...

drivers/ssb/main.c: In function 'ssb_clockspeed':
drivers/ssb/main.c:823: error: implicit declaration of function 'ssb_extif_get_clockcontrol'

So I shall now drop use-ssb-extif-in-ssb-mips-core-driver.patch

But the confidence level is really low.  Michael, I think it's time to
do a reset, drop everything and start again.   I trust you have a copy
of everything.  You'll be cc'ed as they drop..
