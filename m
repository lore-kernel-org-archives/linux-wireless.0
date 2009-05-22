Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:4096 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751319AbZEVMf6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 May 2009 08:35:58 -0400
Date: Fri, 22 May 2009 08:35:12 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Tobias Doerffel <tobias.doerffel@gmail.com>
Cc: Jiri Slaby <jirislaby@gmail.com>, linville@tuxdriver.com,
	mickflemm@gmail.com, lrodriguez@atheros.com,
	linux-wireless@vger.kernel.org, ath5k-devel@venema.h4ckr.net
Subject: Re: [PATCH 1/3] ath5k: add support for radio LED
Message-ID: <20090522123512.GB24949@hash.localnet>
References: <1242850139-25438-1-git-send-email-jirislaby@gmail.com> <200905202216.43996.tobias.doerffel@gmail.com> <20090520202124.M71221@bobcopeland.com> <200905202233.56608.tobias.doerffel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200905202233.56608.tobias.doerffel@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 20, 2009 at 10:33:54PM +0200, Tobias Doerffel wrote:
> Am Mittwoch, 20. Mai 2009 22:29:42 schrieb Bob Copeland:
> > On Wed, 20 May 2009 22:16:42 +0200, Tobias Doerffel wrote
> >
> > > If there's interest, I'll  prepare a new patch which represents the
> > > current state.
> >
> > I'm definitely interested in seeing rfkill gpio support getting in,
> > it's overdue.  So I say repost it and we can fasttrack that.

By the way, it's a good idea to work against Johannes Berg's new
patchset for rfkill which should simplify a lot of the details in
the driver.  Patches are at:

http://johannes.sipsolutions.net/patches/kernel/all/LATEST/

-- 
Bob Copeland %% www.bobcopeland.com

