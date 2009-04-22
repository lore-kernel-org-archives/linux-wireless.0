Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:40147 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751499AbZDVOPw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Apr 2009 10:15:52 -0400
Date: Wed, 22 Apr 2009 10:01:07 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Zdenek Kabelac <zdenek.kabelac@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-wireless@vger.kernel.org
Subject: Re: regression IWl3945 - doesn't work with recent 2.6.30-rcX
Message-ID: <20090422140107.GD3288@tuxdriver.com> (sfid-20090422_161556_843960_74BE4A70)
References: <c4e36d110904220333u37304c79k6ab528f92b5f3718@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <c4e36d110904220333u37304c79k6ab528f92b5f3718@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Apr 22, 2009 at 12:33:03PM +0200, Zdenek Kabelac wrote:
> Hi
> 
> I'm checking whether -rcX kernel could be usable on my
> T61/4GB/C2D/x86_64 - but wireless seems to be still out of
> functionality:
> I'm getting lots of weird trace-back messages and it looks like
> iwl3945 is not working at all.
> (attached messages from fresh build of -rc3 - but it never worked even in -rc1)

Looks like this one did _not_ make -rc3:

commit df833b1d73680f9f9dc72cbc3215edbbc6ab740d
Author: Reinette Chatre <reinette.chatre@intel.com>
Date:   Tue Apr 21 10:55:48 2009 -0700

    iwlwifi: DMA fixes
    
    A few issues wrt DMA were uncovered when using the driver with swiotlb.
...

It is in wireless-2.6 and should be in net-2.6 -- please try one of those kernels.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
