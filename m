Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:4067 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756280AbXJJVi4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Oct 2007 17:38:56 -0400
Date: Wed, 10 Oct 2007 17:01:17 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Markus Feldmann <feldmann_markus@gmx.de>
Cc: linux-wireless@vger.kernel.org
Subject: Re: Patch for Kernel and Ath5k
Message-ID: <20071010210117.GP5962@tuxdriver.com> (sfid-20071010_223900_421044_D6BFEAA1)
References: <feieb9$nvg$1@sea.gmane.org> <200710102132.21790.bruno@thinktube.com> <feih2c$21f$1@sea.gmane.org> <200710101502.20202.hs4233@mail.mn-solutions.de> <feike5$fod$1@sea.gmane.org> <feisop$i4m$1@sea.gmane.org> <20071010173343.GI5962@tuxdriver.com> <470D17F2.7020906@gmx.de> <20071010192709.GL5962@tuxdriver.com> <470D3438.7060206@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <470D3438.7060206@gmx.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Please respond on the list...

On Wed, Oct 10, 2007 at 10:21:12PM +0200, Markus Feldmann wrote:
> John W. Linville schrieb:
> >Please respond on the list...
> >
> >On Wed, Oct 10, 2007 at 08:20:34PM +0200, Markus Feldmann wrote:
> >>
> >>John W. Linville schrieb:
> >>>On Wed, Oct 10, 2007 at 05:57:13PM +0200, Markus Feldmann wrote:
> >>>
> >>>>I do not find the Entry,
> >>>><M> Generic IEEE 802.11 Networking Stack (mac80211)
> >>>>in the ".config" File.
> >>>>And i do not find any files in the Sources containig ATH5k?
> >>>config ATH5K
> >>>       tristate "Atheros 5xxx wireless cards support"
> >>>       depends on PCI && MAC80211 && WLAN_80211 && EXPERIMENTAL
> >>>
> >>>Did you select EXPERIMENTAL?
> >>What do you mean with EXPERIMENTAL?
> >>Have i downloaded the wrong Sources with git ?
> >>
> >>If so can you please post how you download the EXPERIMENTAL Sources?
> >
> >I mean did you answer "y" to this:
> >
> >	Prompt for development and/or incomplete code/drivers (EXPERIMENTAL) 
> >	[Y/n/?]
> >
> >How about this?
> >
> >	Wireless LAN (IEEE 802.11) (WLAN_80211) [Y/n/?]
> >
> >And either "y" or "m" to this?
> >
> >	Generic IEEE 802.11 Networking Stack (mac80211) (MAC80211 [M/n/y/?]
> >
> >Answering "n" to any of those will hide ATH5K from your choices.
> >
> I have all of this above enabled.
> 
> Do you also do this,
> 1.) git-clone 
> git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-2.6.git
> 2.) cd wireless-2.6
> 3.) git checkout -b everything origin/everything
> 
> At the third Point he says to me that there is nothing to do, because i 
> have got the newest. Maybe there is a Mistake?

That procedure works fine here.  I don't know what mistake you
are making.  Did you perhaps checkout one tree inside another?

John

P.S.  Make sure you select PCI in your config as well...
-- 
John W. Linville
linville@tuxdriver.com
