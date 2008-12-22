Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.174]:60291 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754372AbYLVWhN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Dec 2008 17:37:13 -0500
Subject: Re: [ath5k-devel] ath5k_pci: gain calibration timeout / unable to
 reset hardware -11
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Bob Copeland <bcopeland@gmail.com>
Cc: Jiri Slaby <jirislaby@gmail.com>,
	Soeren Sonnenburg <kernel@nn7.de>, ath5k-devel@lists.ath5k.org,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <b6c5339f0812221348o411c4fabse2d0138acfb4f87f@mail.gmail.com>
References: <1229923913.3886.7.camel@localhost>
	 <20081222125819.7353d172.akpm@linux-foundation.org>
	 <4950087E.3080505@gmail.com> <49500906.70309@gmail.com>
	 <b6c5339f0812221348o411c4fabse2d0138acfb4f87f@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 23 Dec 2008 00:37:05 +0200
Message-Id: <1229985425.17866.0.camel@maxim-laptop> (sfid-20081222_233719_377178_09570094)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2008-12-22 at 16:48 -0500, Bob Copeland wrote:
> On Mon, Dec 22, 2008 at 4:39 PM, Jiri Slaby <jirislaby@gmail.com> wrote:
> >>
> >> Does the _HW lockup_ happen even with 2.6.28? The lockup should be gone there
> >> (with the messages still present).
> >
> > I see Bob already replied, ignore me, he knows better.
> 
> I thought Felix's patch had gone into .28, but in fact it hasn't.
> We should probably get it in or queue it for .28.1 -- it's a two
> liner that will fix a lot of people's setups.
> 
> John, if you're reading, that's 23c401574b16cb2b6d2231ba405ebf85b8c87de5
> in wireless-testing.
> 
> The lockup can still occur, but it's a lot less frequent with his patch.
> 

Happens about 1 in 10 times on resume from ram.

Best regards,
	Maxim Levitsky

