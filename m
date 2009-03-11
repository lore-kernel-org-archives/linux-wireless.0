Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:33233 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753745AbZCKSad (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Mar 2009 14:30:33 -0400
Date: Wed, 11 Mar 2009 14:19:36 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Gabor Juhos <juhosg@openwrt.org>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: linux-next: Tree for March 6 (ath9k)
Message-ID: <20090311181935.GD8761@tuxdriver.com> (sfid-20090311_193037_861154_0A260A9F)
References: <20090306191311.697e7b97.sfr@canb.auug.org.au> <49B17320.8010000@oracle.com> <49B17B12.3050200@openwrt.org> <49B17C4E.3000004@oracle.com> <20090306194045.GE3712@tuxdriver.com> <49B7F2B0.1000702@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <49B7F2B0.1000702@oracle.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Mar 11, 2009 at 10:19:44AM -0700, Randy Dunlap wrote:
> John W. Linville wrote:
> > On Fri, Mar 06, 2009 at 11:41:02AM -0800, Randy Dunlap wrote:
> >> Gabor Juhos wrote:
> >>> Randy Dunlap =EDrta:
> >>>> Stephen Rothwell wrote:
> >>>>> Hi all,
> >>>>>
> >>>>> Linus' release of -rc7 seems to have stirred people up a bit ..=
=2E
> >>>>>
> >>>>> Changes since 20090305:
> >>>> when CONFIG_RFKILL=3Dn, ath9k/virtual.c causes:
> >>>>
> >>>> (.text+0x224e83): undefined reference to `ath_radio_disable'
> >>>> (.text+0x224e8b): undefined reference to `ath_radio_enable'
> >>>>
> >>>>
> >>> Hi,
> >>>
> >>> I have submitted a patch for this already:
> >>> http://marc.info/?l=3Dlinux-wireless&m=3D123633468314970&w=3D2
> >>>
> >>> Should I send it to somewhere else as well?
> >> It hasn't propagated into the linux-next merging yet...
> >=20
> > He just sent it today (or overnight).  I'll get it into wireless-ne=
xt.
> >=20
> > John
> >=20
> > P.S.  I'm starting to think that RFKILL should just be mandatory...
>=20
>=20
> This build error still happens in linux-next-20090311.

That fix is in wireless-next-2.6 as of yesterday.  I guess it was a
little too late for yesterday's linux-next build -- sorry!

John
--=20
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
