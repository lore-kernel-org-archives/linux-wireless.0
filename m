Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:40075 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753032AbZEONpK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 May 2009 09:45:10 -0400
Date: Fri, 15 May 2009 09:38:26 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Yousef Alhashemi <yousef.alhashemi@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: Any clean-up work?
Message-ID: <20090515133826.GC2773@tuxdriver.com>
References: <cbd616c00905150614sa13ba93y88a1297b10a69d8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <cbd616c00905150614sa13ba93y88a1297b10a69d8@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, May 15, 2009 at 06:14:23AM -0700, Yousef Alhashemi wrote:

> Now I understand that networking (or the networking subsystem) is
> fairly complicated, but I was wondering if the there is any clean up
> work that I can help with (that will hopefully get me familiarized
> with the kernel in general, and the networking stuff in particular).
> I'm also wondering if anyone here would be willing to give me a little
> bit of hand-holding with the more advanced stuff (if help is needed in
> a particular area but that area is too difficult for a starter like me
> to undertake).

drivers/staging has an embarassingly large number of wireless drivers
in it.  They are there for various reasons, mostly centering around
either attrocious style/maintainability issues or flagrant duplication
of functionality with mainline kernel infrastructure (i.e. should be
using mac80211 instead of their internal stack).  If you have (or
can get) access to any of the covered wireless hardware, anything
you can do to correct style/maintainability issues, keep up-to-date
with changing kernel APIs, and (especially) porting to the mac80211
infrastructure would be most useful.

Hth!

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
