Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:36371 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755010AbcBBQFw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Feb 2016 11:05:52 -0500
Date: Tue, 2 Feb 2016 17:05:38 +0100
From: Sebastian Reichel <sre@kernel.org>
To: Ross Green <rgkernel@gmail.com>, Shahar Patury <shaharp@ti.com>
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
	linux-wireless@vger.kernel.org, Guy Mishol <guym@ti.com>,
	Kalle Valo <kvalo@codeaurora.org>
Subject: wl12xx regression on 4.5 (was: Re: linux-4.5-rc1 TI pandboard-es
 wifi wlcore locks and reset)
Message-ID: <20160202160538.GA19990@earth> (sfid-20160202_170611_387410_D4AF93A7)
References: <CANfgCY2nHh+vZ=JOimJdKKKs2JgM-c7m+3ePZtS3XhqyXNkDUQ@mail.gmail.com>
 <CANfgCY2zVXrLGv=YDpNvqhhoj5U2kgqZ_VV1EBPVK78grra84Q@mail.gmail.com>
 <20160202043448.GA9514@earth>
 <CANfgCY21zzinD48DOHaZdkGdDWpuAtJN1T8ofmdwM=P4f-7=Yw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="azLHFNyN32YCQGCU"
In-Reply-To: <CANfgCY21zzinD48DOHaZdkGdDWpuAtJN1T8ofmdwM=P4f-7=Yw@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--azLHFNyN32YCQGCU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Ross,

Please don't top-post on kernel mailinglists. Use either inline
style or bottom posting.

On Tue, Feb 02, 2016 at 04:41:13PM +1100, Ross Green wrote:
> On Tue, Feb 2, 2016 at 3:34 PM, Sebastian Reichel <sre@kernel.org> wrote:
> > On Mon, Feb 01, 2016 at 11:38:38PM +1100, Ross Green wrote:
> >> On Mon, Jan 25, 2016 at 11:47 PM, Ross Green <rgkernel@gmail.com> wrot=
e:
> >> > Just tried the new kernel release on faithful pandaboard es with the
> >> > new 4.5-rc1 release.
> >> >
> >> > There is a problem with the wifi modules once the modules are loaded.
> >> > Looks like the wifi firmware gets loaded put no response after that
> >> > causing recovery action.
> >> >
> >> > the kernel 4.4 works quite happily with this board.
> >> >
> >> > Here is a dmesg dump in the attachment.
> >> >
> >> > Anyone have any ideas here?
>
> [...]
>=20
> If I get time, this evening, I'll see if I can give a bisect a try.

On N950 [wl1271 via SPI, using extra patches to init from DT] I get wifi
working again on 4.5-rc1 with 3719c17e1816 ("wlcore/wl18xx: fw logger
over sdio") reverted.

-- Sebastian

--azLHFNyN32YCQGCU
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJWsNPPAAoJENju1/PIO/qaXx4P+QHcn8Nh3stIMDgJOeGWbbmO
gBPWXnyaibIctKoCe68Or03wCq+0rz1K2wOpyGsxQQhp/7FCIiRMs3/c3Rdm6sjR
PpXq5Cs4cFCWuPvrxEf3sSPNa3P4H9QZ9W+PEJ3Ng2ZoIcsEgYNj5BBXkP+BGtVu
LJWDmd+0qKQS0BDvOFg/maLJn0242iJ7cmMMDk8iCLRT2RNVKDNGpHjljTArm/c9
GEl7l+pkO2M6EmCaM07A89oUsyT1GRbdjJ1TbCobxnd0aGCYezM696RLwZVKxLu2
Iqurtpp9Mf5MlZVqYEc6qG+50bTc2vUye9QDaKN5gj7R+hTzdr+nf8v91/qyiPz2
P5QqoQkjhs/SxDm5FWJ6uEkdRCH5dFXnxXLdRsNsDiuIZADeGdV7ei53CANu6Gnb
4eZJ1Suv4Gub8DJ11y0Vg5ySXoI14ZpB1DMxNLTZtIYddcvtgS/9jB22pWj+ClFP
fXg6Nw8Gs5oPCXRLdkarMgSL3VIYnzEHKo+wPsF478maPh8Gz/LcjEQXoZDyK7yh
tpoB7f8FsCFJia1C362hJLbmZCM14MhFmEAVNZw5uwxcdr7mMH6sMeVOgUryiZ5R
Y5p+KhtAHkPRyhVzpByeQYpQeFMsWx871tbW8VWmugXMp2QnhBIdOgvuxiLNKR1V
jmGN9cB/x+GSLrtjvrxu
=ucDv
-----END PGP SIGNATURE-----

--azLHFNyN32YCQGCU--
