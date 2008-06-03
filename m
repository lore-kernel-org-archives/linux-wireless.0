Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:2943 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752113AbYFCB21 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Jun 2008 21:28:27 -0400
Date: Mon, 2 Jun 2008 20:57:19 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: libertas-dev@lists.infradead.org, Dan Williams <dcbw@redhat.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH, RESEND] libertas: unify various CF-related defines
Message-ID: <20080603005719.GA23853@tuxdriver.com> (sfid-20080603_032832_601088_FDD8FED8)
References: <200805261250.50363.hs4233@mail.mn-solutions.de> <20080530154113.GB9490@tuxdriver.com> <200806020925.05938.hs4233@mail.mn-solutions.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <200806020925.05938.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jun 02, 2008 at 09:25:05AM +0200, Holger Schurig wrote:
> Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>
>=20
> ---
>=20
> John, this patch applies successfully for me on top of
> wireless-testing v2.6.26-rc4-8765-g24e3ad4.

Yes, but then I get this:

  CC [M]  drivers/net/wireless/libertas/if_usb.o
drivers/net/wireless/libertas/if_usb.c: In function =E2=80=98if_usb_res=
et_olpc_card=E2=80=99:
drivers/net/wireless/libertas/if_usb.c:158: warning: no return statemen=
t in function returning non-void
drivers/net/wireless/libertas/if_usb.c: In function =E2=80=98if_usb_pro=
be=E2=80=99:
drivers/net/wireless/libertas/if_usb.c:248: warning: assignment from in=
compatible pointer type

Are we out of sync?

John
--=20
John W. Linville
linville@tuxdriver.com
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
