Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:53745 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756486Ab0CCUFO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Mar 2010 15:05:14 -0500
Received: by bwz1 with SMTP id 1so234473bwz.21
        for <linux-wireless@vger.kernel.org>; Wed, 03 Mar 2010 12:05:13 -0800 (PST)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [ipw3945-devel] iwl4965: 11a channels disabled in current wireless-testing
Date: Wed, 3 Mar 2010 21:05:08 +0100
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	reinette chatre <reinette.chatre@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>
References: <201002281534.11656.helmut.schaa@googlemail.com> <201003032008.47379.helmut.schaa@googlemail.com> <20100303192946.GC23920@tuxdriver.com>
In-Reply-To: <20100303192946.GC23920@tuxdriver.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201003032105.08938.helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Mittwoch 03 März 2010 schrieb John W. Linville:
> On Wed, Mar 03, 2010 at 08:08:47PM +0100, Helmut Schaa wrote:
> > Am Mittwoch 03 März 2010 schrieb reinette chatre:
> 
> > > $ iw reg get
> > > country 00:
> > > 	(2402 - 2472 @ 40), (3, 20)
> > > 	(2457 - 2482 @ 20), (3, 20), PASSIVE-SCAN, NO-IBSS
> > > 	(2474 - 2494 @ 20), (3, 20), NO-OFDM, PASSIVE-SCAN, NO-IBSS
> > > 	(5170 - 5250 @ 40), (3, 20), PASSIVE-SCAN, NO-IBSS
> > > 	(5735 - 5835 @ 40), (3, 20), PASSIVE-SCAN, NO-IBSS
> > 
> > Oops, that's what I get:
> > 
> > country 00:
> >         (2402 - 2472 @ 40), (3, 20)
> > 
> > Luis, is the world reg domain encoded in cfg80211 or in the regdb? Maybe
> > the regdb is too old or something like that?
> 
> Should be both -- start w/ the one encoded in the kernel and request
> an update from userland if it is available.
> 
> Hth!

It does indeed. I moved crda out of the way so that it cannot get called
anymore and after loading cfg80211, mac80211 and iwlagn I had all the
channels set up the same way as Reinette (and that is how I expected it to
be).

So I guess it's my regdb that's outdated.

Thanks,
Helmut
