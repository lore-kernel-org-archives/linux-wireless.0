Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:41881 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758122AbXK0QEt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Nov 2007 11:04:49 -0500
Subject: Re: [PATCH (2.6.24) 0/3] last minute iwlwifi fixes
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: John Linville <linville@tuxdriver.com>, Zhu Yi <yi.zhu@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Ian Schram <ischram@telenet.be>
In-Reply-To: <1ba2fa240711270800p3312246as51b0a23f77e81f3@mail.gmail.com> (sfid-20071127_160007_928799_20A09CD4)
References: <20071126225416.467939000@sipsolutions.net>
	 <1ba2fa240711270654r276657ch4e56e543a3c4a427@mail.gmail.com>
	 <1196175476.6058.25.camel@johannes.berg>
	 <1ba2fa240711270800p3312246as51b0a23f77e81f3@mail.gmail.com>
	 (sfid-20071127_160007_928799_20A09CD4)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-b6k68PIp/+2DnaJYTI/X"
Date: Tue, 27 Nov 2007 17:04:31 +0100
Message-Id: <1196179471.6058.41.camel@johannes.berg> (sfid-20071127_160458_230123_D2C125C2)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-b6k68PIp/+2DnaJYTI/X
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Tue, 2007-11-27 at 18:00 +0200, Tomas Winkler wrote:

> I found it, there was a patch by Ian Schram <ischram@telenet.be>
> '[PATCH] allow changing mac_addr by userspace'
> It should work I nacked it just because I wanted to remove a filed he
> was using, it never happened so I think we can apply it
> for 24 and then I get back to rework it.
> I'll resend it rebased to current everything.

Great, thanks. Actually, John will probably prefer if you send him a
version against .24 as well. John, please drop 2 and 3 of this series
then in favour of that patch.

johannes

--=-b6k68PIp/+2DnaJYTI/X
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR0xADqVg1VMiehFYAQIlHg/8CbVAZbX6lDvkrEG46rJPDcwXxcKoCstB
pQE9xecpsEM+suv3ryM8gmPni+BfP21qJQkctOZjaohCw+pmt/cS0oCuEp6xojjw
qnuQqBHBY8PNBbyRGFhq69DwqHUbPSafI/Dnad1AYdjUbwa87zvCBXgv1PeZcmsV
0/1kQQ/obqxzLIq7SFhLMfCl38p7WsfUW8a7BPskXj59s56Q3JmoSZ4TJKEjsbC5
QGPgj53bh81cCEZoBUOFyUr2lyAuP/azQPxJwo3WgKfZrBkYy1Rfl2gUHhzLan0g
IwbDnyyk9TXc+TRXu5S84eFOrQ/S71IcxqYPUIhYeqwBGyqOqQ0OFznwaJNdPrXi
S/HeicyWbvtE5mivm/fZPel2h0+EDkp4etaZIpFrVl+GQI1q2q1zVYP4aue3qiEP
gtvl4yAECKk97EHeeRI7EF3mOv3BtpRLNlkatFufaQDy1LNoFPZChbvBz3U8oiep
qcwitpz1z9af/0KpxfsQAJy3mrmQsxubdBhhhS5+kzZZURRZ4S4PA2royGP/znzm
IYBuRs3BJtxKQ21i1dsN/yyo6crQbh2X9B5dpqYgkLEvPY9hglvlT2Zxoecm4zEa
a1qBrgWzJfEkEGWnsO3ZN5uopuftKpUMCXaXP6xsxwYq70Pcit1qsd0MIiWaPqiw
Eu6lBd1BjfQ=
=jaP2
-----END PGP SIGNATURE-----

--=-b6k68PIp/+2DnaJYTI/X--

