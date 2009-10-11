Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:4552 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754350AbZJKNbN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 Oct 2009 09:31:13 -0400
Date: Sun, 11 Oct 2009 09:30:10 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Richard Zidlicky <rz@linux-m68k.org>
Cc: linux-wireless@vger.kernel.org
Subject: Re: 2.6.31.[12] ath5k regression
Message-ID: <20091011133010.GA21494@hash.localnet>
References: <20090621134954.GA31505@linux-m68k.org> <20090621180447.GA29469@hash.localnet> <20090623174616.GA3914@linux-m68k.org> <20090623202541.GA3635@hash.localnet> <20090625083636.GA6323@linux-m68k.org> <20090705123105.GE2132@hash.localnet> <20091009143922.GA7848@linux-m68k.org> <20091010125824.GA18841@hash.localnet> <20091011122616.GA27105@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20091011122616.GA27105@linux-m68k.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Oct 11, 2009 at 02:26:16PM +0200, Richard Zidlicky wrote:
> thanks, compiling it right now. Not quite sure - which version of this
> > > -       ret = ath5k_hw_reset(ah, sc->opmode, sc->curchan, true);
> > > +       ret = ath5k_hw_reset(ah, sc->opmode, sc->curchan, chan != NULL);
> 
> is it supposed to be tested with?

The "chan != NULL" case.  The patch should apply against latest
wireless-testing (but will probably work with linus-2.6).

-- 
Bob Copeland %% www.bobcopeland.com

