Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f53.google.com ([209.85.216.53]:35587 "EHLO
	mail-qw0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751262Ab2BOPUD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Feb 2012 10:20:03 -0500
Date: Wed, 15 Feb 2012 13:21:31 -0200
From: Gustavo Padovan <gustavo@padovan.org>
To: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	linux-bluetooth@vger.kernel.org
Subject: Re: pull request: bluetooth 2012-02-15
Message-ID: <20120215152131.GA19931@joana> (sfid-20120215_162008_516553_553F72EE)
References: <20120215141249.GA28935@x220.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5vNYLRcllDrimb99"
In-Reply-To: <20120215141249.GA28935@x220.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--5vNYLRcllDrimb99
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi John,

* Johan Hedberg <johan.hedberg@gmail.com> [2012-02-15 16:12:49 +0200]:

> Hi John,
>=20
> Here's one (hopefully) last set of important Bluetooth fixes intended
> for 3.3:
>=20
> - One important SSP fix which fixes security level upgrade handling
>   (this was breaking connections with many devices).
> - An update to btusb fixing invalid flag usage with usb_submit_urb() as
>   well as one new vendor ID for a Broadcom device.
> - One compilation warning fix for a bogus inline declaration
> - Fix proper timeout value for l2cap_set_timer and sk_sndtimeo and
>   hci_conn_put
> - Fix a lockdep warning with Bluetooth sockets
> - Deadlock fix in hci_conn_hold
> - RFCOMM reference counting fix
> - QUIRK_NO_RESET fix which was breaking suspend with some laptops
> - Two fixes related to synchronization with cancel_delayed_work()
>=20
> Johan
>=20
> ---
>=20
> The following changes since commit c27111e5b8d6b1e9296f7075cdc35872f672b5=
24:
>=20
>   rtlwifi: Modify rtl_pci_init to return 0 on success (2012-02-09 15:17:2=
9 -0500)
>=20
> are available in the git repository at:
>=20
>   git://git.kernel.org/pub/scm/linux/kernel/git/jh/bluetooth.git master

Acked-by: Gustavo F. Padovan <padovan@profusion.mobi>

	Gustavo

--5vNYLRcllDrimb99
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPO817AAoJEPs3PUX4s20oVTIP/jtZxIPCacrcHgfGxxaq8wV1
P5MHqKbq7fAzgkSPCEMp+VGQIBzqGg+VnC5sqmlJl+VvIjDC8lHm6cwoPm8iS820
BB4sRFK7tEmGJ2lQBNwRIQTqtr+nqs9Ck4oU3VH7EV1fMugyJCdXsaL7SYIvSri8
RnZW1nZuhCW+IOsATJFYMGR5nAnhkzWPe1AT7YCqXsY7TugAnrnLpBfHnhkMYF3b
aSemiqEDMI5B9OKfT4wIyNuSdS7LvjWv4PEsFB8MjF7Qj51i0RzB94f6vEm2LtsC
NRGFcLX8LfyheVLSFF1ow4HAIZZ6V61JM4u/M95HjDsKDL0FpoVfx2ChZUC2AAVj
HqTtrm85Jod9SZQbO7L//D3bZCaNOnXAGljiB/9hx6Z/mE2H3Eh9BeKxdnoEsUvI
FKKy90VuYpXp+IFbMpHUS75ACNwG/pYVmcGeS8joEdvW3SaPyQDK9aUd9Bum3RbV
kDV2PWttKIeFYF8JfgWRdfYSPDz5Wn8oi8MhXWswinERRx+M/XcVYTlCb+goYB51
HVofIitV1QDIAu3Xinh0ufQuKHleoTb6d/o8lP1p1He4tqb+ep/ylBSktBv4Tdhs
yPnui1M1lpFP5svOKu44mF2YHl7RjzJPD71jXZc7qfPKZRRg7zcMx3rgzANgl/e/
UsJr30lYxNsQQqnnR8xA
=6CGB
-----END PGP SIGNATURE-----

--5vNYLRcllDrimb99--
