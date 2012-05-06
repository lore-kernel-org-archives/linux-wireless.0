Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from latitanza.investici.org ([82.94.249.234]:36450 "EHLO
	latitanza.investici.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752922Ab2EFJ5L (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 May 2012 05:57:11 -0400
Date: Sun, 6 May 2012 11:57:51 +0200
From: Antonio Quartulli <ordex@autistici.org>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"Venkataraman, Meenakshi" <meenakshi.venkataraman@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: iwlwifi warn_slowpath with 3.*
Message-ID: <20120506095750.GB21716@ritirata.org> (sfid-20120506_115715_189286_2F18EB50)
References: <CANUX_P0XhRQNVMQKtrw4j1UT9S=CMcjApCyNsdHHtLVME3jeEQ@mail.gmail.com>
 <20120504142006.GA2040@ritirata.org>
 <CANUX_P28EcqDVXQkSrGk2fetf=Evf2Yd_Fg9Czwb1jEPpdgTWg@mail.gmail.com>
 <CANUX_P0ygFyDjOo1Thygw_dEiHKPPiH4=GDKN4ncX3vwy0ujrw@mail.gmail.com>
 <20120506075433.GA1288@ritirata.org>
 <CANUX_P09Bx=kZ+OoHLTdZgJy_rJOQvutg3yVrBLHzPzV=KMQsg@mail.gmail.com>
 <20120506085637.GB1288@ritirata.org>
 <20120506091526.GA2086@ritirata.org>
 <CANUX_P1Sg6=NNYoRJ+zOHyjiyKXfY=q+R4eDpqLtTC3DaodbfQ@mail.gmail.com>
 <CANUX_P0g5TAQ=+VO0EXUvVhNOf6zy-h7KQLocLY0RaVAaJo2FQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+g7M9IMkV8truYOl"
In-Reply-To: <CANUX_P0g5TAQ=+VO0EXUvVhNOf6zy-h7KQLocLY0RaVAaJo2FQ@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--+g7M9IMkV8truYOl
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, May 06, 2012 at 12:26:38PM +0300, Emmanuel Grumbach wrote:
> >>> >
> >>> > Can you please test the patch I sent to you (which was good but not=
 enough)
> >>> > And add this one too ?
> >>>
> >>> Ok, I'll also leave the print.patch.
> >>> I'll report the result.
> >>>
> >>
> >> The WARNING is gone :)
> >>
> >> I attached the dmesg log anyway (debug was off, but there
> >> are all the prints you introduced).
> >>
> >> To be sure, I also removed all the IWL_ERR you added and tried to rebo=
ot (in
> >> order to see whether the printings were affecting synchronization).
> >>
> >
> > Glad to hear.
> >
> > You can also remove everything. Reapply the second patch, and here is
> > a new version of this patch after cleaning.
>=20
> I meant, reapply the first patch (the one that zeroes the TBs).

Do you think thise patches should be backported for stable? Doesn't seem to=
 be
trivial..

> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=20
Antonio Quartulli

=2E.each of us alone is worth nothing..
Ernesto "Che" Guevara

--+g7M9IMkV8truYOl
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQEcBAEBAgAGBQJPpkseAAoJEFMQTLzJFOZF+VcIAIVyQdPV8DeU2XzYGMAYjh93
oOwXCLllsMl9bv/z81t7vucKzOzCxOhGJPUPE9Ydt6Et8S6BvrXbg5CTYEZtkjRW
sKu4ypB5XvUXt6YyT/iLOcHUOfddTDAKZ6sipPLIzAzjiutBvxTm3HC7jG8fmNVy
gBwGnlsHX6obZuo+I5mTFb/RACAEAonl2E9XZZtY5HDI0SOIaQQjTMoH4FwX6DOS
qI2v82Tx4u4hzXEmggPFEGutEuOygNY/Njnl30B5dQdmpVgFstntumTO9KzWHP5h
VtdlSVZxq6lY/clH3iOpXMPpp29SChbevvqF6XaOkhwWSf/ABCT6ck5iSNUb0dw=
=0+Mk
-----END PGP SIGNATURE-----

--+g7M9IMkV8truYOl--
