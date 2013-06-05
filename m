Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ht1.myhostedexchange.com ([69.50.2.37]:38999 "EHLO
	ht1.hostedexchange.local" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754118Ab3FELB6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Jun 2013 07:01:58 -0400
Date: Wed, 5 Jun 2013 13:00:01 +0200
From: Antonio Quartulli <antonio@open-mesh.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: Antonio Quartulli <ordex@autistici.org>,
	Nicolas Cavallari <Nicolas.Cavallari@lri.fr>,
	Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath6kl-devel@qca.qualcomm.com" <ath6kl-devel@qca.qualcomm.com>
Subject: Re: ath6kl_mgmt_tx with NULL chan
Message-ID: <20130605110001.GD2349@open-mesh.com> (sfid-20130605_130202_433728_9B44A3DC)
References: <1370241587-2609-1-git-send-email-ordex@autistici.org>
 <1370271547.8227.16.camel@jlt4.sipsolutions.net>
 <51ACB068.8070006@lri.fr>
 <20130603171430.GE1226@ritirata.org>
 <8738swkhho.fsf@kamboji.qca.qualcomm.com>
 <20130605100332.GB2349@open-mesh.com>
 <87ppw0j22p.fsf@kamboji.qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="T7mxYSe680VjQnyC"
In-Reply-To: <87ppw0j22p.fsf@kamboji.qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--T7mxYSe680VjQnyC
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 05, 2013 at 03:15:26AM -0700, Kalle Valo wrote:
> But when modifying that code, please add a check to make sure that
> channel 0 is not used by accident.

Ok, maybe I'll send another patch for this. I don't want to mix a new behav=
iour
with a fix.


Thanks a lot!


Cheers,

--=20
Antonio Quartulli

=2E.each of us alone is worth nothing..
Ernesto "Che" Guevara

--T7mxYSe680VjQnyC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBCAAGBQJRrxoxAAoJEADl0hg6qKeOTW0P/A+YV99V+ZyAWbqlhJ0OiVrq
jx5fQkZwJRsUQdS6Z1l94LzX6UERlIZheQ+4dYRNfZz7ju631cwVvNHj0mZOzEDO
n3yZTGhyDv5fgzJ+HXAJrs+fY/2dnm9FRwLvHsTEmlYxRJ1ZTvLzaRx+z7Wf7y/b
uSKl9WVuIBf60GuxpYsiAFocjYov4O17Ivoi2YPeuVzKnusARkwuElyDoih1MnJ5
J4xDg38oQfdNfQhBqCMsh1j0jz++WxTeeeFB+igRJAnMcDoq4xuX+a86JgIDy2gt
iH6iluSj7B4BqbS+ABmL0MMF4NdLpdlO7Z/4UYPuaRE4goVMyDFIJODtS0xXYlE7
alnbuEJAyqirOyBtNz1AO16Vz0GeZRVajzy4OTfYHfa2/xNB72ia4DANSg+feRFY
77pc/JAcJSkAHPZ1u+tF89LEJeWi74qAGD7jUZMONc3Ka7eWHqrkEZBsT8Tb242n
Me8FfG1AtYAH88hjOgQequdMsnN99cQP/7OAB3Wk2241AvyR9jp3HZmrwHrp0P1g
gJ4ZNdESJazV6RKxZVs8Eqe22HN4oZN5k0IiAyGA8UnTJVDgCzfF238dFu505ItQ
Qzjv+M0CH4K6s7Qbxw+bBom4Oojeg2TYUsy4wWyFrXjVsccvwxLsIoSIyWaXpuIK
6nv0S+GIq5dkYSQaGRUu
=dAAm
-----END PGP SIGNATURE-----

--T7mxYSe680VjQnyC--
