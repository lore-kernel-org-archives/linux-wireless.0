Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from planck.djpig.de ([85.10.192.180]:2508 "EHLO planck.djpig.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754112AbXKKJqj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 Nov 2007 04:46:39 -0500
Date: Sun, 11 Nov 2007 10:27:03 +0100
From: Frank Lichtenheld <frank@lichtenheld.de>
To: Michael Buesch <mb@bu3sch.de>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] b43: silence a bogus gcc warning
Message-ID: <20071111092703.GQ2961@planck.djpig.de> (sfid-20071111_094643_075185_BC6AF16C)
References: <200711101614.03776.mb@bu3sch.de> <20071110152533.GC32472@tuxdriver.com> <200711101727.43736.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <200711101727.43736.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Nov 10, 2007 at 05:27:43PM +0100, Michael Buesch wrote:
> On Saturday 10 November 2007 16:25:33 John W. Linville wrote:
> > On Sat, Nov 10, 2007 at 04:14:03PM +0100, Michael Buesch wrote:
> > > From: Frank Lichtenheld <frank@lichtenheld.de>
> > >=20
> > > inititalise ret to 0 to avoid the following bogus warning:
> > >   CC [M]  drivers/net/wireless/b43/debugfs.o
> > > drivers/net/wireless/b43/debugfs.c: In function =E2=80=98b43_debu=
gfs_read=E2=80=99:
> > > drivers/net/wireless/b43/debugfs.c:355: warning: =E2=80=98ret=E2=80=
=99 may be used uninitialized in this function
> > >=20
> > > Signed-off-by: Frank Lichtenheld <frank@lichtenheld.de>
> > > Signed-off-by: Michael Buesch <mb@bu3sch.de>
> >=20
> > Isn't this what uninitialized_var() is for?

Erh, I didn't actually knew that existed, sorry.
OTOH in this case it is actually longer to write.

> I'd be OK with that, too.

Should I send a changed patch?

Gruesse,
--=20
=46rank Lichtenheld <frank@lichtenheld.de>
www: http://www.djpig.de/
-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
