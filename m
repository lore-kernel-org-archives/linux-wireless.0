Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:47488
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752397AbXKKLZF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 Nov 2007 06:25:05 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Frank Lichtenheld <frank@lichtenheld.de>
Subject: Re: [PATCH] b43: silence a bogus gcc warning
Date: Sun, 11 Nov 2007 12:23:54 +0100
Cc: "John W. Linville" <linville@tuxdriver.com>,
	bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
References: <200711101614.03776.mb@bu3sch.de> <200711101727.43736.mb@bu3sch.de> <20071111092703.GQ2961@planck.djpig.de>
In-Reply-To: <20071111092703.GQ2961@planck.djpig.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Message-Id: <200711111223.55055.mb@bu3sch.de> (sfid-20071111_112511_645193_2D69BDB2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 11 November 2007 10:27:03 Frank Lichtenheld wrote:
> On Sat, Nov 10, 2007 at 05:27:43PM +0100, Michael Buesch wrote:
> > On Saturday 10 November 2007 16:25:33 John W. Linville wrote:
> > > On Sat, Nov 10, 2007 at 04:14:03PM +0100, Michael Buesch wrote:
> > > > From: Frank Lichtenheld <frank@lichtenheld.de>
> > > >=20
> > > > inititalise ret to 0 to avoid the following bogus warning:
> > > >   CC [M]  drivers/net/wireless/b43/debugfs.o
> > > > drivers/net/wireless/b43/debugfs.c: In function =E2=80=98b43_de=
bugfs_read=E2=80=99:
> > > > drivers/net/wireless/b43/debugfs.c:355: warning: =E2=80=98ret=E2=
=80=99 may be used uninitialized in this function
> > > >=20
> > > > Signed-off-by: Frank Lichtenheld <frank@lichtenheld.de>
> > > > Signed-off-by: Michael Buesch <mb@bu3sch.de>
> > >=20
> > > Isn't this what uninitialized_var() is for?
>=20
> Erh, I didn't actually knew that existed, sorry.
> OTOH in this case it is actually longer to write.
>=20
> > I'd be OK with that, too.
>=20
> Should I send a changed patch?

Yes.

--=20
Greetings Michael.
-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
