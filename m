Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:50760 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753138Ab0AGSKZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jan 2010 13:10:25 -0500
Date: Thu, 7 Jan 2010 10:09:42 -0800
From: Greg KH <gregkh@suse.de>
To: Alexander Huemer <alexander.huemer@sbg.ac.at>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Re: removal of strip driver from the linux kernel
Message-ID: <20100107180942.GA17642@suse.de>
References: <4B45E5B1.2040901@sbg.ac.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4B45E5B1.2040901@sbg.ac.at>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jan 07, 2010 at 02:46:25PM +0100, Alexander Huemer wrote:
> hi,
> 
> i read in your blog that the driver "strip" for the metricom radios is
> going to be removed from the linux kernel.
> as you suggested, i am "speaking up" now, because i am using the driver.
> the driver should not be removed and could even be improved, actually
> in a very significant way.
> the current version (1.3) does not work for the last hardware revision
> of the radios which were the ones circulated in larger quantities.
> that may be the reason why the driver does (or did) have a quite small
> user base.
> these radios are available on eBay from time to time, very cheap.
> the difference in the hardware is mostly a different length of the
> hardware address.
> 
> there is already a patch and documentation from alex belitis [1] for
> that, for linux-2.4.1.  i also found a different patch [2] that might
> be of interest, for 2.5.46.

Are you able to refresh these patches for the latest kernel version and
send them to me so that we can help bring the code up-to-date?

> since the driver is quite small and the starmode concept is quite
> unique in wireless networking, i am planning to do some academic work
> on the concept during an OS and networking class at the university of
> salzburg.
> i am not (yet) an experienced kernel programmer and because of that
> have problems porting the patch from alex belitis to the current
> kernel versions. who could help me with this ?

What problems are you having?

> the git log lists a lot people plumbing on strip.c, so i am unsure
> whom to contact.

The linux-wireless mailing list (on the CC:), and the driverdevel list
are the best ones.

Anyone want to help out here?

> [1] http://phobos.illtel.denver.co.us/~abelits/metricom/
> [2] http://www.stillhq.com/linux/patches/2.5.46/cli_sti_removal-001

thanks,

greg k-h
