Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mfe1.polimi.it ([131.175.12.23]:43820 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754433AbXDTHDZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Apr 2007 03:03:25 -0400
Date: Fri, 20 Apr 2007 09:02:18 +0200
From: Stefano Brivio <stefano.brivio@polimi.it>
To: Michael Wu <flamingice@sourmilk.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Andrea Merello <andreamrl@tiscali.it>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] rtl818x-mac80211: fix coding style
Message-ID: <20070420090218.5a51d363@localhost>
In-Reply-To: <200704191923.31674.flamingice@sourmilk.net>
References: <20070420004258.23848470@localhost>
	<200704191923.31674.flamingice@sourmilk.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 19 Apr 2007 19:23:26 -0400
Michael Wu <flamingice@sourmilk.net> wrote:

> On Thursday 19 April 2007 18:42, Stefano Brivio wrote:
> > Fix coding style.
> >
> Looks mostly good except for..
> 
> > -	// ehh?
> > +	// XXX: ehh?
> Use FIXME if you want to put in a prefix.

"XXX:" means we don't know if it's a FIXME, a TODO or just correct code.
It's quite used. Unless this is a clear FIXME, I'd keep it.

> > -} __attribute__ ((packed));
> > +} __attribute__((packed));
> I prefer the space here.

Please see CodingStyle.


-- 
Ciao
Stefano
