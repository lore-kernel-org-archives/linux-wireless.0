Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from madara.hpl.hp.com ([192.6.19.124]:51335 "EHLO madara.hpl.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751874AbXKSWgU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Nov 2007 17:36:20 -0500
Date: Mon, 19 Nov 2007 14:35:54 -0800
To: David Miller <davem@davemloft.net>
Cc: johannes@sipsolutions.net, shaddy_baddah@hotmail.com,
	linux-wireless@vger.kernel.org, dsd@gentoo.org
Subject: Re: zd1211rw (2.6.22 sparc64): unaligned access (do_rx)
Message-ID: <20071119223554.GA21844@bougret.hpl.hp.com> (sfid-20071119_223624_515225_EB4D8664)
Reply-To: jt@hpl.hp.com
References: <4740DF47.4040206@hotmail.com> <20071119.002755.77617097.davem@davemloft.net> <1195484582.8642.18.camel@johannes.berg> <20071119.142046.188284555.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20071119.142046.188284555.davem@davemloft.net>
From: Jean Tourrilhes <jt@hpl.hp.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 19, 2007 at 02:20:46PM -0800, David Miller wrote:
> 
> This is an unreasonable requirement, all kernel ABIs should work in
> 32-bit compat tasks.  And when it's very difficult or impossible to
> make it work, there should be a new ABI to transition to that does
> work in compat mode and in particular would work now for the user.

	My personal goal is to fix those problems. I understand that
John and Johannes are not very interested.
	I personally think it's not difficult to fix, so far, every
bug reported was quite easy to fix. The main issue is lack of testing,
I don't have a 64 bit box. Bug reports are *very* difficult to get
because there are very few users of wireless on 64 bits and because
"the box is in production, I can't try this".
	Now, the good news is that many of such bugs have been fixed
in the last few months, actually more that in the few previous
years. Some of the bugs reported *may* be fixed in later versions.
	Have fun...

	Jean

