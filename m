Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:44671 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753080AbZCFTp3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Mar 2009 14:45:29 -0500
Date: Fri, 6 Mar 2009 14:40:45 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Gabor Juhos <juhosg@openwrt.org>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: linux-next: Tree for March 6 (ath9k)
Message-ID: <20090306194045.GE3712@tuxdriver.com> (sfid-20090306_204534_146541_CAFDF746)
References: <20090306191311.697e7b97.sfr@canb.auug.org.au> <49B17320.8010000@oracle.com> <49B17B12.3050200@openwrt.org> <49B17C4E.3000004@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <49B17C4E.3000004@oracle.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Mar 06, 2009 at 11:41:02AM -0800, Randy Dunlap wrote:
> Gabor Juhos wrote:
> > Randy Dunlap =EDrta:
> >> Stephen Rothwell wrote:
> >>> Hi all,
> >>>
> >>> Linus' release of -rc7 seems to have stirred people up a bit ...
> >>>
> >>> Changes since 20090305:
> >>
> >> when CONFIG_RFKILL=3Dn, ath9k/virtual.c causes:
> >>
> >> (.text+0x224e83): undefined reference to `ath_radio_disable'
> >> (.text+0x224e8b): undefined reference to `ath_radio_enable'
> >>
> >>
> >=20
> > Hi,
> >=20
> > I have submitted a patch for this already:
> > http://marc.info/?l=3Dlinux-wireless&m=3D123633468314970&w=3D2
> >=20
> > Should I send it to somewhere else as well?
>=20
> It hasn't propagated into the linux-next merging yet...

He just sent it today (or overnight).  I'll get it into wireless-next.

John

P.S.  I'm starting to think that RFKILL should just be mandatory...
--=20
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
