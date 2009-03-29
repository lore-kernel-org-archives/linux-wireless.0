Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:4704 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756169AbZC2POO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 29 Mar 2009 11:14:14 -0400
Date: Sun, 29 Mar 2009 11:14:01 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Sitsofe Wheeler <sitsofe@yahoo.com>
Cc: Jiri Slaby <jirislaby@gmail.com>,
	Nick Kossifidis <mickflemm@gmail.com>,
	Frederic Weisbecker <fweisbec@gmail.com>,
	linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
	ath5k-devel@venema.h4ckr.net,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: Re: [TIP] BUG kmalloc-4096: Poison overwritten (ath5k_rx_skb_alloc)
Message-ID: <20090329151401.GA26510@hash.localnet> (sfid-20090329_171418_243064_F8BC4824)
References: <20090303200352.GA8343@silver.sucs.org> <20090304120759.GA6519@hash.localnet> <20090306094249.GA10236@silver.sucs.org> <20090308030928.GB14966@hash.localnet> <49B38FB7.3000002@gmail.com> <20090310004344.GA23466@hash.localnet> <20090312061047.GA13401@silver.sucs.org> <20090313095213.GA14250@silver.sucs.org> <20090320131437.GA30120@hash.localnet> <20090329142432.GA15578@sucs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20090329142432.GA15578@sucs.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Mar 29, 2009 at 03:24:32PM +0100, Sitsofe Wheeler wrote:
> I've been away travelling for the past week and I move house on the 1st
> April (which will make testing this much harder from then on) but I'll
> try to get one final test in before the move.
> 
> Do you need an ftrace in addition to dmesg for this? If so is it better
> to leave ieee calls out of the ftrace?

No, thanks - the debug output will be plenty verbose already and should
tell everything we need to know.

-- 
Bob Copeland %% www.bobcopeland.com

