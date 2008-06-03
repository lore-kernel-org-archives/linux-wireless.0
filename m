Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3939 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750751AbYFCO2l (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jun 2008 10:28:41 -0400
Date: Tue, 3 Jun 2008 10:03:42 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: libertas-dev@lists.infradead.org, Dan Williams <dcbw@redhat.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH, RESEND] libertas: unify various CF-related defines
Message-ID: <20080603140342.GA31553@tuxdriver.com> (sfid-20080603_162844_913951_5B6EF1F1)
References: <200805261250.50363.hs4233@mail.mn-solutions.de> <200806020925.05938.hs4233@mail.mn-solutions.de> <20080603005719.GA23853@tuxdriver.com> <200806031018.52362.hs4233@mail.mn-solutions.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <200806031018.52362.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 03, 2008 at 10:18:52AM +0200, Holger Schurig wrote:
> On Tuesday 03 June 2008 02:57:19 John W. Linville wrote:
> > Yes, but then I get this:
> >
> >   CC [M]  drivers/net/wireless/libertas/if_usb.o
> > drivers/net/wireless/libertas/if_usb.c: In function
> > =E2=80=98if_usb_reset_olpc_card=E2=80=99:
> > drivers/net/wireless/libertas/if_usb.c:158: warning: no return
> > statement in function returning non-void
> > drivers/net/wireless/libertas/if_usb.c: In function
> > =E2=80=98if_usb_probe=E2=80=99: drivers/net/wireless/libertas/if_us=
b.c:248:
> > warning: assignment from incompatible pointer type
> >
> > Are we out of sync?
>=20
> I dunno, because the patch that I posted via "RESEND" doesn't=20
> touch if_usb.c, it solely patches if_cs.c. So your problem must=20
> have been there independend of my patches.
>=20
> AFAIK I did not submit any if_usb.c - touching patch now for some=20
> months.

You're right, I'm sorry.  I neglected to delete if_usb.o, so the
warning "magically" went away when I rebuilt without your patch... :-(

John
--=20
John W. Linville
linville@tuxdriver.com
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
