Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:46140 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752072AbZCGIE0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Mar 2009 03:04:26 -0500
Date: Sat, 7 Mar 2009 08:04:22 +0000
From: Sitsofe Wheeler <sitsofe@yahoo.com>
To: Bob Copeland <me@bobcopeland.com>
Cc: Jiri Slaby <jirislaby@gmail.com>,
	Nick Kossifidis <mickflemm@gmail.com>,
	Frederic Weisbecker <fweisbec@gmail.com>,
	linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
	ath5k-devel@venema.h4ckr.net,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: Re: [TIP] BUG kmalloc-4096: Poison overwritten (ath5k_rx_skb_alloc)
Message-ID: <20090307080422.GA29341@silver.sucs.org> (sfid-20090307_090432_826481_4D11A823)
References: <20090224135817.GB6019@hash.localnet> <49A46AD4.3060007@gmail.com> <20090225140139.GA18694@silver.sucs.org> <20090226135938.GA12182@hash.localnet> <20090226170338.GA1745@silver.sucs.org> <20090303041222.GA1238@hash.localnet> <20090303200352.GA8343@silver.sucs.org> <20090304120759.GA6519@hash.localnet> <20090306094249.GA10236@silver.sucs.org> <20090307044732.GA13663@hash.localnet>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20090307044732.GA13663@hash.localnet>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Mar 06, 2009 at 11:47:32PM -0500, Bob Copeland wrote:
>
> Well, this is great so far!  It'll take some time to dig through it
> but it looks useful.
> 
> I saw _get_tsf64 in the trace; were you using ad-hoc/ibss mode, or 
> is that just a weird artifact?

Sounds like a werid artifact - I only (intentionally) connect to access
points.

-- 
Sitsofe | http://sucs.org/~sits/
