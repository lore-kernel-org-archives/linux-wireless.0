Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:4859 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790AbYFCITD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jun 2008 04:19:03 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH, RESEND] libertas: unify various CF-related defines
Date: Tue, 3 Jun 2008 10:18:52 +0200
Cc: libertas-dev@lists.infradead.org, Dan Williams <dcbw@redhat.com>,
	linux-wireless@vger.kernel.org
References: <200805261250.50363.hs4233@mail.mn-solutions.de> <200806020925.05938.hs4233@mail.mn-solutions.de> <20080603005719.GA23853@tuxdriver.com>
In-Reply-To: <20080603005719.GA23853@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Message-Id: <200806031018.52362.hs4233@mail.mn-solutions.de> (sfid-20080603_101909_606227_3E3D7C59)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 03 June 2008 02:57:19 John W. Linville wrote:
> Yes, but then I get this:
>
>   CC [M]  drivers/net/wireless/libertas/if_usb.o
> drivers/net/wireless/libertas/if_usb.c: In function
> =E2=80=98if_usb_reset_olpc_card=E2=80=99:
> drivers/net/wireless/libertas/if_usb.c:158: warning: no return
> statement in function returning non-void
> drivers/net/wireless/libertas/if_usb.c: In function
> =E2=80=98if_usb_probe=E2=80=99: drivers/net/wireless/libertas/if_usb.=
c:248:
> warning: assignment from incompatible pointer type
>
> Are we out of sync?

I dunno, because the patch that I posted via "RESEND" doesn't=20
touch if_usb.c, it solely patches if_cs.c. So your problem must=20
have been there independend of my patches.

AFAIK I did not submit any if_usb.c - touching patch now for some=20
months.
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
