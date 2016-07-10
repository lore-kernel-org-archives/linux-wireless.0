Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from betelgeuse.uberspace.de ([185.26.156.37]:35908 "EHLO
	betelgeuse.uberspace.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753273AbcGJMzT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Jul 2016 08:55:19 -0400
Subject: Re: Problem: iwlwifi: Microcode SW error detected. Restarting
 0x2000000
To: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
References: <57820E4A.3010102@ytvwld.de>
 <0BA3FCBA62E2DC44AF3030971E174FB346688F92@hasmsx107.ger.corp.intel.com>
 <57822467.30500@ytvwld.de>
 <0BA3FCBA62E2DC44AF3030971E174FB346689061@hasmsx107.ger.corp.intel.com>
 <57822F84.7060103@ytvwld.de>
 <0BA3FCBA62E2DC44AF3030971E174FB3466890C6@hasmsx107.ger.corp.intel.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	linuxwifi <linuxwifi@intel.com>
From: Niklas Sombert <niklas@ytvwld.de>
Message-ID: <57824594.7030202@ytvwld.de> (sfid-20160710_145526_670406_5A13E60F)
Date: Sun, 10 Jul 2016 14:54:44 +0200
MIME-Version: 1.0
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB3466890C6@hasmsx107.ger.corp.intel.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="d8h4trT6CnpCHth3iGUITxab3PnqM44ot"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--d8h4trT6CnpCHth3iGUITxab3PnqM44ot
Content-Type: multipart/mixed; boundary="jkwGRvtH7eMXX7tgj8dPA0hpATCHC1wKb"
From: Niklas Sombert <niklas@ytvwld.de>
To: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
 linuxwifi <linuxwifi@intel.com>
Message-ID: <57824594.7030202@ytvwld.de>
Subject: Re: Problem: iwlwifi: Microcode SW error detected. Restarting
 0x2000000
References: <57820E4A.3010102@ytvwld.de>
 <0BA3FCBA62E2DC44AF3030971E174FB346688F92@hasmsx107.ger.corp.intel.com>
 <57822467.30500@ytvwld.de>
 <0BA3FCBA62E2DC44AF3030971E174FB346689061@hasmsx107.ger.corp.intel.com>
 <57822F84.7060103@ytvwld.de>
 <0BA3FCBA62E2DC44AF3030971E174FB3466890C6@hasmsx107.ger.corp.intel.com>
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB3466890C6@hasmsx107.ger.corp.intel.com>

--jkwGRvtH7eMXX7tgj8dPA0hpATCHC1wKb
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Emmanuel Grumbach wrote:
> Thanks -this is the same bug as https://bugzilla.kernel.org/show_bug.cg=
i?id=3D114501 then.
> Seems really Bluetooth related.

Yes, I can confirm that this problem doesn't occur when I rename
/lib/firmware/intel/ibt-hw-37.8.10-fw-1.10.3.11.e.bseq to something else.=



--jkwGRvtH7eMXX7tgj8dPA0hpATCHC1wKb--

--d8h4trT6CnpCHth3iGUITxab3PnqM44ot
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJXgkWdAAoJEIOFK7hVFsHHudUH/2htTSV9GdwTByxY/CHil6Ix
2v3BdqDNDa3WVcd97rTsqG2tOcUxo2xMZm4mpeZSAVWwj2VujwHx9bLnhnJxqpfN
pwlHYirCDa63BQvQamTnFftZBjFb/jkmARbkNKxcJB1249aCaa82wnUqHztuQfku
eS3V41jjGmNtraR4aYFyvYwzcgIHFH/+IR9S1iYPrCcFitcwrwOLQHgMcOiV5A6f
W423AtZP5PY910kwW5OXDkD4La28UCkiy0DK1ct0XNZVV35iEIYEE9kgZJQT5lDr
qzdHXHW5TEc4X1FVjPeKcnTZkFcMKtp2dkIaChqUVOzubP7BAiAkvvIkjKo8jzA=
=FP/9
-----END PGP SIGNATURE-----

--d8h4trT6CnpCHth3iGUITxab3PnqM44ot--
