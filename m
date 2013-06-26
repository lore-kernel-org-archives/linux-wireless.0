Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:60869 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751309Ab3FZGiA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Jun 2013 02:38:00 -0400
Date: Tue, 25 Jun 2013 23:37:58 -0700
From: Tony Lindgren <tony@atomide.com>
To: Luciano Coelho <coelho@ti.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/5] wl1251: split wl251 platform data to a separate
 structure
Message-ID: <20130626063758.GM5523@atomide.com> (sfid-20130626_083805_893301_68E2FA89)
References: <1372192406-29430-1-git-send-email-coelho@ti.com>
 <1372192406-29430-2-git-send-email-coelho@ti.com>
 <1372227318.18889.23.camel@cumari.coelho.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1372227318.18889.23.camel@cumari.coelho.fi>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

* Luciano Coelho <coelho@ti.com> [130625 23:21]:
> On Tue, 2013-06-25 at 23:33 +0300, Luciano Coelho wrote:
> > Move the wl1251 part of the wl12xx platform data structure into a new
> > structure specifically for wl1251.  Change the platform data built-in
> > block and board files accordingly.
> > 
> > Cc: Tony Lindgren <tony@atomide.com>
> > Signed-off-by: Luciano Coelho <coelho@ti.com>
> > ---
> 
> Hey Tony,
> 
> Is it okay if I send this patch via my tree? There are a couple of tiny
> changes in a couple of OMAP board files...

Yes that's fine, those should not conflict with anything else. For
the arch/arm/*omap* parts:

Acked-by: Tony Lindgren <tony@atomide.com>
