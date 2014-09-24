Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:33706 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752384AbaIXSAN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Sep 2014 14:00:13 -0400
Date: Wed, 24 Sep 2014 13:51:35 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Luca Olivetti <luca@ventoso.org>
Cc: linux-wireless@vger.kernel.org
Subject: Re: Mediatek MT7601U big endian fixes
Message-ID: <20140924175135.GB31690@tuxdriver.com> (sfid-20140924_200018_970105_17C86309)
References: <5422FD0B.3060806@ventoso.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5422FD0B.3060806@ventoso.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 24, 2014 at 07:19:07PM +0200, Luca Olivetti wrote:
> Hello,
> 
> apart from the general brokenness of the vendor supplied driver (see
> http://www.spinics.net/lists/linux-wireless/msg126291.html and
> http://www.arnelborja.com/compiling-rt2870-wifi-driver-in-fedora/), it
> doesn't work in big endian mode.
> 
> Without this patch:
> 
> https://code.google.com/p/mt7601-openwrt/source/browse/patches/007-big-endian-fix.patch
> 
> it doesn't even compile, and this one
> 
> https://code.google.com/p/mt7601-openwrt/source/browse/patches/008-more-big-endiand-fixes.patch
> 
> makes it functional.
> 
> Before finding the fix myself I contacted mediatek support with no reply
> so far.
> 
> Do you know if is there somebody (at ralink/mediatek or elsewhere)
> working on integrating this chipset in the in-kernel driver?
> 
> Bye
> -- 
> Luca

I don't know of anyone from Ralink/MediaTek or otherwise working
on that.  I sent some emails to MediaTek on this issue recently,
but I made the mistake of including someone from the community who
actively undermind my attempts to reach-out to MediaTek...

If you (or anyone else) want to work on integrating device support
from that driver with the in-kernel drivers then I encourage you to
do so.  If you happen to have better contacts with MediaTek than I
have, then please feel free to reach out to them and/or to put them
in contact with me.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
