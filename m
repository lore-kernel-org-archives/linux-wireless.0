Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.181]:50515 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757455AbXJJVzp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Oct 2007 17:55:45 -0400
Received: by py-out-1112.google.com with SMTP id u77so644768pyb
        for <linux-wireless@vger.kernel.org>; Wed, 10 Oct 2007 14:55:44 -0700 (PDT)
Message-ID: <43e72e890710101455k311c7de4x203d466bdbe73c97@mail.gmail.com> (sfid-20071010_225606_026838_58D571AE)
Date: Wed, 10 Oct 2007 17:55:43 -0400
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: Patch for Kernel and Ath5k
Cc: "Markus Feldmann" <feldmann_markus@gmx.de>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20071010210117.GP5962@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <feieb9$nvg$1@sea.gmane.org> <feih2c$21f$1@sea.gmane.org>
	 <200710101502.20202.hs4233@mail.mn-solutions.de>
	 <feike5$fod$1@sea.gmane.org> <feisop$i4m$1@sea.gmane.org>
	 <20071010173343.GI5962@tuxdriver.com> <470D17F2.7020906@gmx.de>
	 <20071010192709.GL5962@tuxdriver.com> <470D3438.7060206@gmx.de>
	 <20071010210117.GP5962@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/10/07, John W. Linville <linville@tuxdriver.com> wrote:
> Please respond on the list...
>
> On Wed, Oct 10, 2007 at 10:21:12PM +0200, Markus Feldmann wrote:
> > John W. Linville schrieb:
> > >Please respond on the list...
> > >
> > >On Wed, Oct 10, 2007 at 08:20:34PM +0200, Markus Feldmann wrote:
> > >>
> > >>John W. Linville schrieb:
> > >>>On Wed, Oct 10, 2007 at 05:57:13PM +0200, Markus Feldmann wrote:
> > >>>
> > >>>>I do not find the Entry,
> > >>>><M> Generic IEEE 802.11 Networking Stack (mac80211)
> > >>>>in the ".config" File.
> > >>>>And i do not find any files in the Sources containig ATH5k?
> > >>>config ATH5K
> > >>>       tristate "Atheros 5xxx wireless cards support"
> > >>>       depends on PCI && MAC80211 && WLAN_80211 && EXPERIMENTAL
> > >>>
> > >>>Did you select EXPERIMENTAL?
> > >>What do you mean with EXPERIMENTAL?
> > >>Have i downloaded the wrong Sources with git ?
> > >>
> > >>If so can you please post how you download the EXPERIMENTAL Sources?
> > >
> > >I mean did you answer "y" to this:
> > >
> > >     Prompt for development and/or incomplete code/drivers (EXPERIMENTAL)
> > >     [Y/n/?]
> > >
> > >How about this?
> > >
> > >     Wireless LAN (IEEE 802.11) (WLAN_80211) [Y/n/?]
> > >
> > >And either "y" or "m" to this?
> > >
> > >     Generic IEEE 802.11 Networking Stack (mac80211) (MAC80211 [M/n/y/?]
> > >
> > >Answering "n" to any of those will hide ATH5K from your choices.
> > >
> > I have all of this above enabled.
> >
> > Do you also do this,
> > 1.) git-clone
> > git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-2.6.git
> > 2.) cd wireless-2.6
> > 3.) git checkout -b everything origin/everything
> >
> > At the third Point he says to me that there is nothing to do, because i
> > have got the newest. Maybe there is a Mistake?
>
> That procedure works fine here.  I don't know what mistake you
> are making.  Did you perhaps checkout one tree inside another?
>
> John
>
> P.S.  Make sure you select PCI in your config as well...

Also, if you do:

git-branch

what do you get?
