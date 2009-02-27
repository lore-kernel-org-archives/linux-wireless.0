Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:47562 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755360AbZB0SpX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Feb 2009 13:45:23 -0500
Date: Fri, 27 Feb 2009 13:41:58 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: Fwd: b43* linux driver, more ids dev
Message-ID: <20090227184157.GE3687@tuxdriver.com> (sfid-20090227_194525_521296_82056BF2)
References: <ee588a540902270946h13e03b6el71de5237a458b7a3@mail.gmail.com> <ee588a540902270955j214d98d2uf58858d12a7787cc@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <ee588a540902270955j214d98d2uf58858d12a7787cc@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Feb 27, 2009 at 06:55:15PM +0100, Xose Vazquez Perez wrote:
> fwd to linux-wireless@vger.kernel.org
>=20
>=20
> ---------- Forwarded message ----------
> From: Xose Vazquez Perez <xose.vazquez@gmail.com>
> Date: Fri, Feb 27, 2009 at 18:46
> Subject: b43* linux driver, more ids dev
> To: mb@bu3sch.de, Larry.Finger@lwfinger.net,
> johannes@sipsolutions.net, stefano.brivio@polimi.it
>=20
>=20
> hi,
>=20
> are there any trouble with these devices ? why are they not =A0inside
> b43* drivers ?
>=20
> PCI_VENDOR_ID_BROADCOM, 0x4313
> PCI_VENDOR_ID_BROADCOM, 0x4315
> PCI_VENDOR_ID_BROADCOM, 0x432a
> PCI_VENDOR_ID_BROADCOM, 0x432b
> PCI_VENDOR_ID_BROADCOM, 0x432c
> PCI_VENDOR_ID_BROADCOM, 0x432d
>=20
>=20
> taken from the vendor's driver src:
> http://www.broadcom.com/docs/linux_sta/hybrid-portsrc-x86_32-v5_10_27=
_14.tar.gz
>=20
> more info at: http://www.broadcom.com/support/802.11/linux_sta.php

If I'm not mistaken, that driver only covers hardware that is _not_
supported by b43 or b43legacy today.

John
--=20
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
