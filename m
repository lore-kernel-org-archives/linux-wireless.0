Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:33773 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755831AbZANVPt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Jan 2009 16:15:49 -0500
Date: Wed, 14 Jan 2009 16:09:02 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Lorenzo Nava <navalorenx@gmail.com>, bcm43xx-dev@lists.berlios.de,
	linux-wireless@vger.kernel.org,
	Francesco Gringoli <francesco.gringoli@ing.unibs.it>,
	kyle@infradead.org
Subject: Re: [b43] opensource firmware
Message-ID: <20090114210902.GD3643@tuxdriver.com> (sfid-20090114_221600_229128_E27928EF)
References: <9FB118DA-845D-4708-84F3-4D51837D8C68@gmail.com> <1231965922.20309.0.camel@johannes>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1231965922.20309.0.camel@johannes>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jan 14, 2009 at 09:45:22PM +0100, Johannes Berg wrote:
> 
> > Initvals and new firmware version can be found at http://www.ing.unibs.it/openfwwf
> 
> I suggest that before this is packaged, we change it so b43 can
> recognise it and automatically disable qos and hwcrypto.

That's a good idea.  Is that simply a driver patch?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
