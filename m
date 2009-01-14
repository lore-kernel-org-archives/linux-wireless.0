Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:44685 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753918AbZANVcl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Jan 2009 16:32:41 -0500
Date: Wed, 14 Jan 2009 16:32:34 -0500
From: Kyle McMartin <kyle@infradead.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Lorenzo Nava <navalorenx@gmail.com>,
	bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org,
	Francesco Gringoli <francesco.gringoli@ing.unibs.it>,
	kyle@infradead.org
Subject: Re: [b43] opensource firmware
Message-ID: <20090114213234.GB25473@bombadil.infradead.org> (sfid-20090114_223246_442611_904E421A)
References: <9FB118DA-845D-4708-84F3-4D51837D8C68@gmail.com> <1231965922.20309.0.camel@johannes> <20090114210902.GD3643@tuxdriver.com> <1231968050.21021.3.camel@johannes>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1231968050.21021.3.camel@johannes>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jan 14, 2009 at 10:20:50PM +0100, Johannes Berg wrote:
> On Wed, 2009-01-14 at 16:09 -0500, John W. Linville wrote:
> > On Wed, Jan 14, 2009 at 09:45:22PM +0100, Johannes Berg wrote:
> > > 
> > > > Initvals and new firmware version can be found at http://www.ing.unibs.it/openfwwf
> > > 
> > > I suggest that before this is packaged, we change it so b43 can
> > > recognise it and automatically disable qos and hwcrypto.
> > 
> > That's a good idea.  Is that simply a driver patch?
> 
> Should be fairly simple, yeah.
> 

Testing a patch now, I'll fire it off to the list when I've made
sure it works alright. (Damn, my cardbus b43 card appears to have bought
the farm recently. Oh well. I'll figure something out)

regards, Kyle
