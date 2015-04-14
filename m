Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx02.posteo.de ([89.146.194.165]:55929 "EHLO mx02.posteo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753409AbbDNVDN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Apr 2015 17:03:13 -0400
Message-ID: <552D808F.1080900@posteo.de> (sfid-20150414_230318_010208_8541D2EC)
Date: Tue, 14 Apr 2015 23:03:11 +0200
From: demos <demos@posteo.de>
MIME-Version: 1.0
To: openwrt-hackers@openwrt.org, linux-wireless@vger.kernel.org
Subject: Connecting
References: <552D79AE.3070509@gnunet.org>
In-Reply-To: <552D79AE.3070509@gnunet.org>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="NMX8l6ca5KTnHX97lOtWcjUJSn4BIOUFi"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--NMX8l6ca5KTnHX97lOtWcjUJSn4BIOUFi
Content-Type: multipart/mixed;
 boundary="------------020902070205000108010507"

This is a multi-part message in MIME format.
--------------020902070205000108010507
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

Connecting GNUnet with Openwrt
Is this the right place to forward this email?
Kind regards
Demos


-------- Weitergeleitete Nachricht --------
Betreff: Re: [GNUnet-developers] EDN
Datum: Tue, 14 Apr 2015 22:33:50 +0200
Von: Christian Grothoff <grothoff@gnunet.org>
An: demos <demos@posteo.de>, gnunet-developers@gnu.org

On 04/14/15 21:55, demos wrote:
> Concerning the support of openwrt:
> What do you think about the idea of crosschecking certain parts of code=

> for bugs (those parts that directly interact with one another?) togethe=
r
> with the Openwrt-developers. (I haven't asked them yet. Maybe it's
> better if you ask them directly?)

Well, our code largely just calls the TUN/TAP APIs of the Kernel right
now, so I don't know where we'd there touch with OpenWRT-logic.

> In my opinion this would be a win-win situation for both,
> because you both have experienced C developers.
> They get their code reviewed, you get your code reviewed.

I'm not sure this is terribly realistic: it takes quite some time to be
familiar with the codebase (and you can't review code without
understanding what it is supposed to do).  That knowledge doesn't
translate to a different project easily, you have the initial steep
learning curve each time.  So it doesn't quite sound like a win-win.

However, if the OpenWRT folks are interested in helping Bart (& Florian)
get GNUnet onto the WRT platform, that would be great and might be an
actual win-win (we gain a platform, they a capability).


Happy hacking!

Christian




--------------020902070205000108010507
Content-Type: application/pgp-keys;
 name="0xBF83D308.asc"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="0xBF83D308.asc"

-----BEGIN PGP PUBLIC KEY BLOCK-----
Version: GnuPG v2

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
6RZuhM6zOysUnqFV8YCKhz23
=3DcbYV
-----END PGP PUBLIC KEY BLOCK-----

--------------020902070205000108010507--

--NMX8l6ca5KTnHX97lOtWcjUJSn4BIOUFi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJVLYCPAAoJEJs2Xi2/g9MIiO8QAKJ7GTuFcCstrMWniNp6HGNx
/EC32X7EfccZtnrHuXe5Cz93X9eJo44/k4+2vje2avCph1n1Bkraje7iSjhx7QNK
nj7Z9XaghycKhlNtiHC/QslNYGMQWr9/fiEC7Q3FTRSBWJkwDIoJHUQk/aC4Umpn
uGQZKXJp/lurSo1Q0znFHuLPRgbrNLkkO3Hm7FE37N5RsydDrb6VQ0ChIF3LWhbl
RYjMilUR1bkJEeXNFQvhzPH2YqtC6eBJVVijtnMpuzNhOH84BysilqlociUjsqcw
OlEBSkFA9NXldvmLZDgmjzXEOQjcScPWjaAlfb1M0vT78kMaYsdSogALZtb2L+MC
P3kEMaeGdkQTJf2N2J7UYoeNwNaZPYhaS/OVgl9qhmvI4CuVLs2pQ2IvnzcL2xXG
ODFUDsQ8cbxf4fFmXyhFZS5I0dNM/LH3pDV3ClwSiyF1wp1KupDt43lqVH7xbkI8
iRPKVWMv/VTxV2bFL8s2Aa2YjoNwJ38/UMLrotZFRlBX/zSBQlyEWsOHKF1h8Xba
TocL1sOcQB+PMyEWDF4nxUeAkd5Hi1ox4J0V4vN5VPcXClqnhw8aJggdruvGMh9Z
4jZwg7aYkMx4B1XXPFFFfcgjVctbbphFBrnmIyO8RbcxHFhYnrFrO6uEM1ZtO7pG
P0Rv8Qz8vAyNGEOllxEk
=chz9
-----END PGP SIGNATURE-----

--NMX8l6ca5KTnHX97lOtWcjUJSn4BIOUFi--
