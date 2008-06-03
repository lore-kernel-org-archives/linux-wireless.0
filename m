Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:4380 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752078AbYFCP3V (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jun 2008 11:29:21 -0400
Date: Tue, 3 Jun 2008 10:59:26 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Dan Williams <dcbw@redhat.com>
Cc: Holger Schurig <hs4233@mail.mn-solutions.de>,
	libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH, RESEND] libertas: unify various CF-related defines
Message-ID: <20080603145926.GA22160@tuxdriver.com> (sfid-20080603_172924_752080_293CCAF3)
References: <200805261250.50363.hs4233@mail.mn-solutions.de> <20080530154113.GB9490@tuxdriver.com> <200806020925.05938.hs4233@mail.mn-solutions.de> <20080603005719.GA23853@tuxdriver.com> <1212502456.3108.3.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1212502456.3108.3.camel@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 03, 2008 at 10:14:16AM -0400, Dan Williams wrote:
> On Mon, 2008-06-02 at 20:57 -0400, John W. Linville wrote:
> > On Mon, Jun 02, 2008 at 09:25:05AM +0200, Holger Schurig wrote:
> > > Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>
> > >=20
> > > ---
> > >=20
> > > John, this patch applies successfully for me on top of
> > > wireless-testing v2.6.26-rc4-8765-g24e3ad4.
> >=20
> > Yes, but then I get this:
> >=20
> >   CC [M]  drivers/net/wireless/libertas/if_usb.o
> > drivers/net/wireless/libertas/if_usb.c: In function =E2=80=98if_usb=
_reset_olpc_card=E2=80=99:
> > drivers/net/wireless/libertas/if_usb.c:158: warning: no return stat=
ement in function returning non-void
> > drivers/net/wireless/libertas/if_usb.c: In function =E2=80=98if_usb=
_probe=E2=80=99:
> > drivers/net/wireless/libertas/if_usb.c:248: warning: assignment fro=
m incompatible pointer type
> >=20
> > Are we out of sync?
>=20
> Holger's patch shouldn't touch if_usb.c at all; these errors would be
> the OLPC reset card patch that Woodhouse posted a week or two back mo=
st
> likely.

Indeed...I just sent a one-liner to fix the warning.  I'll fold it
into the original before the actual merge to davem.

John
--=20
John W. Linville
linville@tuxdriver.com
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
