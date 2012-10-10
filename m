Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from contumacia.investici.org ([178.255.144.35]:62561 "EHLO
	contumacia.investici.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752554Ab2JJAK7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Oct 2012 20:10:59 -0400
Date: Wed, 10 Oct 2012 02:10:24 +0200
From: Antonio Quartulli <ordex@autistici.org>
To: Mohammed Shafi <shafi.wireless@gmail.com>
Cc: Sujith Manoharan <c_manoha@qualcomm.com>,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Rodriguez Luis <rodrigue@qca.qualcomm.com>,
	ath9k-devel@lists.ath9k.org
Subject: Re: [RFC 1/2] ath9k_htc: Advertize allowed vif combinations
Message-ID: <20121010001024.GE22517@ritirata.org> (sfid-20121010_021103_684632_E7AE26D7)
References: <1348761132-8344-1-git-send-email-mohammed@qca.qualcomm.com>
 <20581.2614.43943.601901@gargle.gargle.HOWL>
 <50652E56.10303@qca.qualcomm.com>
 <20581.32544.134606.56158@gargle.gargle.HOWL>
 <20120929093118.GA3022@ritirata.org>
 <CAD2nsn20s3L8b8DT53JYAN-t4q5GpxUVzSCncTt1LQO3w=wsYw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ylS2wUBXLOxYXZFQ"
In-Reply-To: <CAD2nsn20s3L8b8DT53JYAN-t4q5GpxUVzSCncTt1LQO3w=wsYw@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--ylS2wUBXLOxYXZFQ
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 08, 2012 at 09:20:38PM +0530, Mohammed Shafi wrote:
> On Sat, Sep 29, 2012 at 3:01 PM, Antonio Quartulli <ordex@autistici.org> =
wrote:
> > On Fri, Sep 28, 2012 at 04:12:40 +0530, Sujith Manoharan wrote:
> >> Mohammed Shafi Shajakhan wrote:
> >> > oh yeah, you are saying that we will have some issues with IBSS
> >> > coexistence with other modes because of TSF sync.
> >>
> >> Yes, this is a problem.
> >
> > Is there anyway to overcome this problem? Can we bind the single TSF to=
 multiple
> > virtualTSF? or must the device somehow support us?
>=20
> Antonio, agained i checked with the ath9k_htc maintainer, he said the
> IBSS coexistence is not
> possible. So i would go with my current patch. Please do feel free to
> enhance. Currently
> i am working in some other project, not sure i would be able to take this=
 up.

Hi Mohammed,

thank you for having taken care of this. Is it possible to have more details
about this "impossibility"? I still have to understand, because on one side=
 we
all agreed on the fact that IBSS+AP coexistence will create problems on the=
 STA
(connected to the AP) because of the TSF jumps, but this would still "work"=
=2E On
the other side the maintainer is claiming this would not work at all :-) At=
 this
point, I'd like to clearly understand "why" he is claiming so: is it for the
same reason explained above (TSF jumps) or is there something else?

Cheers,


--=20
Antonio Quartulli

=2E.each of us alone is worth nothing..
Ernesto "Che" Guevara

--ylS2wUBXLOxYXZFQ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iEYEARECAAYFAlB0vPAACgkQpGgxIkP9cwcefACcDNiW1ZSHWigk1Nytv4aMcXbm
GXAAnjoHgzdJnjSTP7okBi/nQLgHFVbm
=GRQi
-----END PGP SIGNATURE-----

--ylS2wUBXLOxYXZFQ--
