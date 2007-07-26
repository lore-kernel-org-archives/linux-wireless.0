Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from deine-taler.de ([217.160.107.63]:64049 "EHLO deine-taler.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936617AbXGZU6X (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jul 2007 16:58:23 -0400
Date: Thu, 26 Jul 2007 22:58:22 +0200
From: Ulrich Kunitz <kune@deine-taler.de>
To: Andy Green <andy@warmcat.com>
Cc: Michael Wu <flamingice@sourmilk.net>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, Jiri Benc <jbenc@suse.cz>
Subject: Re: [PATCH] mac80211: revert some GFP_ATOMIC -> GFP_KERNEL changes
Message-ID: <20070726205822.GA32223@deine-taler.de>
References: <200707261053.44771.flamingice@sourmilk.net> <46A8E602.9090406@warmcat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <46A8E602.9090406@warmcat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Andy Green wrote:

> Somebody in the thread at some point said:
> 
> > Some of the allocations made with GFP_ATOMIC really were necessary.
> 
> I tested it: this makes the BUG stuff in dmesg go away, thanks :-)

Confirmed, patch should definitely go into wireless-dev.

-- 
Uli Kunitz
