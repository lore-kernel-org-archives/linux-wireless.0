Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:35387 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752336AbYFCOOq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jun 2008 10:14:46 -0400
Subject: Re: [PATCH, RESEND] libertas: unify various CF-related defines
From: Dan Williams <dcbw@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Holger Schurig <hs4233@mail.mn-solutions.de>,
	libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org
In-Reply-To: <20080603005719.GA23853@tuxdriver.com>
References: <200805261250.50363.hs4233@mail.mn-solutions.de>
	 <20080530154113.GB9490@tuxdriver.com>
	 <200806020925.05938.hs4233@mail.mn-solutions.de>
	 <20080603005719.GA23853@tuxdriver.com>
Content-Type: text/plain; charset=utf8
Date: Tue, 03 Jun 2008 10:14:16 -0400
Message-Id: <1212502456.3108.3.camel@localhost.localdomain> (sfid-20080603_161451_146215_F44F5E5E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2008-06-02 at 20:57 -0400, John W. Linville wrote:
> On Mon, Jun 02, 2008 at 09:25:05AM +0200, Holger Schurig wrote:
> > Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>
> >=20
> > ---
> >=20
> > John, this patch applies successfully for me on top of
> > wireless-testing v2.6.26-rc4-8765-g24e3ad4.
>=20
> Yes, but then I get this:
>=20
>   CC [M]  drivers/net/wireless/libertas/if_usb.o
> drivers/net/wireless/libertas/if_usb.c: In function =E2=80=98if_usb_r=
eset_olpc_card=E2=80=99:
> drivers/net/wireless/libertas/if_usb.c:158: warning: no return statem=
ent in function returning non-void
> drivers/net/wireless/libertas/if_usb.c: In function =E2=80=98if_usb_p=
robe=E2=80=99:
> drivers/net/wireless/libertas/if_usb.c:248: warning: assignment from =
incompatible pointer type
>=20
> Are we out of sync?

Holger's patch shouldn't touch if_usb.c at all; these errors would be
the OLPC reset card patch that Woodhouse posted a week or two back most
likely.

dan

--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
