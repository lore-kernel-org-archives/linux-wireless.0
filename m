Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bues.ch ([80.190.117.144]:40422 "EHLO bues.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726917AbeHWVnO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 23 Aug 2018 17:43:14 -0400
Date: Thu, 23 Aug 2018 20:11:47 +0200
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: prabhu <d.praabhu@gmail.com>, linux-wireless@vger.kernel.org,
        b43-dev@lists.infradead.org
Subject: Re: [Regression]BCM4312 is broken in kernel 4.18[Root cause found]
Message-ID: <20180823201147.393b1d53@wiggum> (sfid-20180823_201224_993297_55C76711)
In-Reply-To: <CAHnrWRruLuuPN+bYc4NqO515W8+wHoCPH16ULsnJV_JrD+9oEw@mail.gmail.com>
References: <CAHnrWRruLuuPN+bYc4NqO515W8+wHoCPH16ULsnJV_JrD+9oEw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 boundary="Sig_/mUnukoH7V3gXL1iBQIWMKM5"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Sig_/mUnukoH7V3gXL1iBQIWMKM5
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 23 Aug 2018 23:00:53 +0530
prabhu <d.praabhu@gmail.com> wrote:

> The following commits introduce this regression in 4.18
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit=
/?id=3D66cffd6daab76caebab26eb803b92182414fc182


Ok. Kalle, can you please revert the commit
66cffd6daab76caebab26eb803b92182414fc182
?

--=20
Michael

--Sig_/mUnukoH7V3gXL1iBQIWMKM5
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEihRzkKVZOnT2ipsS9TK+HZCNiw4FAlt++OMACgkQ9TK+HZCN
iw6ZIxAAsEGcsbY8XzAciHd6Us6Abu63fQ7LrYO1wa5c2HtVFdBqHf5raswdteNK
oXFGMCuq9nZlGb8N/32wI6eYcIFEXiYemU9m+9PY06RcFu0A7VqYLOsJY864UPV9
aR3vG1F/ARHkRBe0Q4mHeWXxIkUckwr0IoS4qKSHZ3zcPPu2rZwxXZHiji0mI74h
DCLF6/dlAgT3RMVfc74o2txWj4RdTMvNDqd1recdW6INxNWrmJ74yYids4esgQ3I
vcx4oSNugB8bcz4SapwPwypH6xgJ+bHgu2Bt4t6aRVB4w9Y8MEn3Wjt99vT3YlS0
ff4Z6/3NfiZBTk41gSEXu2eosD0BApx7WfWtlfxmAClNxDYEKEgm78KWu6JIEHjN
ow1HoRFJD3YNLEjSasLuG1BOe4/nqnUtQ3bLOqb7xUzRZgiNbH1Ow8PG53euIby4
+PvIz4viCQITUiI4mCnqS29RglZLRGgb2YdLf1WjSMF2glwfyfA+eWFLspFK2rVW
4agBdRqpRZ1UfS6vEJ8xu9i7LYpEEjvW2FyYjpmUPbK41c2HUk1hCRS7Kw9dMPyS
zN2uMFKC8Q3Qi839OSEHwlfQz/3wj0Xm6+pli+B2e8mIAM4HdyJmYZMLyKx02nwD
sxiFZw/YM6UECcHbO7eG4h+CFy15oR5GKaAphEEK19DlylUY6N4=
=v10W
-----END PGP SIGNATURE-----

--Sig_/mUnukoH7V3gXL1iBQIWMKM5--
