Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:43462 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755381Ab2K0Ucy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Nov 2012 15:32:54 -0500
Date: Tue, 27 Nov 2012 21:32:45 +0100
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
Cc: Martin Schleier <drahemmaps@gmx.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [RFC 0/3] Add spectral scan support for Atheros AR92xx/AR93xx
Message-ID: <20121127203244.GA752@pandem0nium> (sfid-20121127_213305_460813_C37C2E36)
References: <1354042885-32688-1-git-send-email-siwu@hrz.tu-chemnitz.de>
 <loom.20121127T201036-82@post.gmane.org>
 <20121127194952.GA530@pandem0nium>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7AUc2qLy4jB3hD7Z"
In-Reply-To: <20121127194952.GA530@pandem0nium>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--7AUc2qLy4jB3hD7Z
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

On Tue, Nov 27, 2012 at 08:49:52PM +0100, Simon Wunderlich wrote:
> [...]
>
> The goal of this was to create the spectral scan feature based on public
> information, so the results are probably not optimal yet, but I hope that
> this will help to move Qualcomm/Atheros disclosing some information (this seems
> to be planned anyway[2]). Otherwise, maybe other people can help
> reverse-engineering this. :)

Just to clarify: I don't mean anyone should disassemble proprietary object files
or use proprietary source code and re-use these findings without permission to
create this feature - this would probably be illegal anyway.

By reverse-engineering, I mean we can already dump data spectral scan data with
this patchset, but the hard part is to interpret this data correctly - as you'll
find in the patches, there are a lot of bits which we don't know what they
mean, and maybe there is even more info hidden in these bits. I've uploaded
some samples taken on my hardware to the github repo, so anyone can use my
program, matlab, or just stare at these heaps of bytes to find some patterns and
try to interpret it. Actually I was just staring at the bytes myself and wrote
this visualizer to get a better idea what they could mean.

Of course, if we can some docs or support from QCA officially, this would be even
better. :)

Cheers,
	Simon

--7AUc2qLy4jB3hD7Z
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAlC1I2wACgkQrzg/fFk7axazSgCgonKBa6K9uiTrE2Cm0QdVX+S3
roAAoKvISSw2ITi1FiEC2iponTZHCCtt
=Dsd8
-----END PGP SIGNATURE-----

--7AUc2qLy4jB3hD7Z--
