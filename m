Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from narfation.org ([79.140.41.39]:42207 "EHLO v3-1039.vlinux.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933620AbcBYTch (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Feb 2016 14:32:37 -0500
From: Sven Eckelmann <sven@narfation.org>
To: Peter Oh <poh@codeaurora.org>
Cc: "Valo, Kalle" <kvalo@qca.qualcomm.com>,
	"Oh, Peter" <poh@qca.qualcomm.com>, linux-wireless@vger.kernel.org,
	ath10k@lists.infradead.org
Subject: Re: [PATCH v3] ath10k: set MAC timestamp in management Rx frame
Date: Thu, 25 Feb 2016 20:32:33 +0100
Message-ID: <12890529.ZzYcJYx9dF@sven-edge> (sfid-20160225_203242_718763_E6248BC9)
In-Reply-To: <56CF4DA3.8030803@codeaurora.org>
References: <4c705dc7a2c0aa857da4e6eaf6e8ed47c354b9ea.1456351768.git.poh@qca.qualcomm.com> <87k2lsd9zv.fsf@kamboji.qca.qualcomm.com> <56CF4DA3.8030803@codeaurora.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart2016203.862zcHdUiS"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart2016203.862zcHdUiS
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

On Thursday 25 February 2016 10:53:23 Peter Oh wrote:
> > I see new warnings:
> > 
> > drivers/net/wireless/ath/ath10k/wmi.c:2199:16: warning: restricted __le32
> > degrades to integer
> > drivers/net/wireless/ath/ath10k/wmi.c:2201:41: warning: restricted __le32
> > degrades to integer
> > drivers/net/wireless/ath/ath10k/wmi.c:2201:41: warning: cast to restricted
> > __le32
> > drivers/net/wireless/ath/ath10k/wmi.c:2201:41: warning: restricted __le32
> > degrades to integer
> 
> Do I have a way to run this check before submitting a patch such as
> checkpatch.pl?

Looks like sparse with -D__CHECK_ENDIAN__ [1]

You may also try smatch [2]

Kind regards,
	Sven

[1] https://www.kernel.org/doc/Documentation/sparse.txt
[2] http://smatch.sourceforge.net/
--nextPart2016203.862zcHdUiS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCgAGBQJWz1bRAAoJEF2HCgfBJntGcZsQAJsPdIOJ00eLc0MbEkasaYrW
3zyq4QuQOD8AkNqlbg9wtKLMi73zHsjx3fjSFUn7xYJ1pa8mXKuNMYAK7dBen9f6
0FEWdh0FFERMrZv6dzToOg27pLfawMKdJX0JZ4PTQq9lhO9pcxUUOawdexZTV7BO
n46lAG9qt83A5fGt5qgiFDNRg57EQmiy7wtY6qwQZgrdaEuruZdw0Jqq1cb4dEi+
QkppQvTMhaKHiRmse6906KJ3Cd8dEA5Ti8KVVfuxtpE4IFujT3pbL//cO7HV7Keq
mYTgKtqQl4M0Lqj6PZ0NxrYitInQAgRJsYAdu6507lQIFEZkXz9KOWicRYBGmkUv
r1d8/UFwPBvmZD21ztt/4nxogzFhKHrXQQqXyHNYLNJi434RlwkM7TxUxSAJNHtH
qjMQ35z1UuJcrmWPjJTA7cRQ6hs0gKrmDmdFgNJx/jNOPP+eM+DDjFW0ghQJMwhY
pyIeZubh4qRXIsoHfA+/xabQTCV3KKe80xkM8E5J28oReQd6APTgYfBP8wBtyHX/
NOiKjNrpbNOXONUI4AsFnlJuKtnqFufEKymucTkmguFplE5ltDQqE9++WtvnOS8b
Rsjn3dMdoOU3PAnuUBN6eC9W5F5OEmlm5XDJ83zOlKLgVtzPny5G62W8BLfpOqPQ
5bwFvVGvapHew8BzsYBh
=HViL
-----END PGP SIGNATURE-----

--nextPart2016203.862zcHdUiS--

