Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([70.167.247.36]:2788 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751880AbZBFU7K (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Feb 2009 15:59:10 -0500
From: "Bob Copeland" <me@bobcopeland.com>
To: Hugh Dickins <hugh@veritas.com>,
	"John W. Linville" <linville@tuxdriver.com>
Cc: ath5k-devel@venema.h4ckr.net, linux-wireless@vger.kernel.org,
	Jiri Slaby <jirislaby@gmail.com>, maximlevitsky@gmail.com
Subject: Re: [ath5k-devel] ath5k_tasklet_rx BUG_ON(bf->skb == NULL)
Date: Fri, 6 Feb 2009 15:58:38 -0500
Message-Id: <20090206205043.M903@bobcopeland.com> (sfid-20090206_215915_155527_2548182A)
In-Reply-To: <Pine.LNX.4.64.0902061857410.25517@blonde.anvils>
References: <Pine.LNX.4.64.0901081740350.19523@blonde.anvils> <b6c5339f0901081041p3c9669f8ycd461b155da60f94@mail.gmail.com> <b6c5339f0901090541m1ac135bcta91bacb3f048a9ba@mail.gmail.com> <Pine.LNX.4.64.0901091400290.925@blonde.anvils> <20090110164705.GB10865@hash.localnet> <20090110201547.GA11261@hash.localnet> <Pine.LNX.4.64.0901131509080.9571@blonde.anvils> <20090113154204.M52697@bobcopeland.com> <Pine.LNX.4.64.0902061305530.15787@blonde.anvils> <20090206183443.M95991@bobcopeland.com> <20090206184445.GB7526@tuxdriver.com> <Pine.LNX.4.64.0902061857410.25517@blonde.anvils>
MIME-Version: 1.0
Content-Type: text/plain;
	charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 6 Feb 2009 19:01:28 +0000 (GMT), Hugh Dickins wrote
> On Fri, 6 Feb 2009, John W. Linville wrote:
> > Hmmm...well it is a little big, but I guess it is OK.  Do you have
> > an example of the stack trace?  Or a link to a bugzilla or somesuch
> > would be even better...
> 
> Below is my original report: I didn't copy down the stacktrace,
> and the kernel paniced with "Fatal exception in interrupt", so
> nothing I can send you from the logs I'm afraid.

I can generate the panic if you like, but it will need to wait a few
hours until I am back home to the machine with the serial console.
I just forced one of the skb allocations to fail to test it.

-- 
Bob Copeland %% www.bobcopeland.com


