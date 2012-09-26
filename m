Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from tee.schottelius.org ([77.109.138.222]:44564 "EHLO
	mx3.schottelius.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752505Ab2IZHmM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Sep 2012 03:42:12 -0400
Date: Wed, 26 Sep 2012 08:06:53 +0200
From: Nico Schottelius <nico-kernel20120920@schottelius.org>
To: David Rientjes <rientjes@google.com>
Cc: Nico Schottelius <nico-kernel20120920@schottelius.org>,
	Arend van Spriel <arend@broadcom.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Dave Kleikamp <shaggy@kernel.org>,
	jfs-discussion@lists.sourceforge.net
Subject: Re: Out of memory on 3.5 kernels
Message-ID: <20120926060653.GD16575@schottelius.org> (sfid-20120926_094241_536344_E843CBC7)
References: <505B1FA0.6030100@broadcom.com>
 <20120921194931.GA732@schottelius.org>
 <alpine.DEB.2.00.1209241538310.6356@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <alpine.DEB.2.00.1209241538310.6356@chino.kir.corp.google.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



David Rientjes [Mon, Sep 24, 2012 at 03:43:27PM -0700]:
>  [...]
> 
> And those objects are consuming ~2.3GB of slab on your 4GB machine and 
> seems to only have occurred between v3.4.2 to v3.5.3.
> 
> It would be interesting to see what kmemleak would tell us.

As the Archlinux kernel does not support kmemleak:

[8:04] brief:android-apk% zgrep -i meml /proc/config.gz                
CONFIG_INPUT_FF_MEMLESS=m
# CONFIG_DEBUG_KMEMLEAK is not set

I'll give the latest kernel tree from Linus a try this evening and if it
is in there. If not, I'll go back to 3.5.4 in Linus tree and try again.

Cheers,

Nico

-- 
PGP key: 7ED9 F7D3 6B10 81D7 0EC5  5C09 D7DC C8E4 3187 7DF0
