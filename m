Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:58953 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751665Ab1LUSSX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Dec 2011 13:18:23 -0500
Date: Wed, 21 Dec 2011 21:19:03 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: "Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: brcm: list of smatch warnings
Message-ID: <20111221181902.GG26771@mwanda> (sfid-20111221_191826_634931_BAA2C504)
References: <20111215112947.GB3906@elgon.mountain>
 <4EF21BA1.3020806@broadcom.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BXr400anF0jyguTS"
In-Reply-To: <4EF21BA1.3020806@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--BXr400anF0jyguTS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 21, 2011 at 06:47:13PM +0100, Arend van Spriel wrote:
> On 12/15/2011 12:29 PM, Dan Carpenter wrote:
> > Smatch still complains about the brcm driver.  Could you take a look at
> > these messages?  It's mostly just cleanups like doing the correct cast
> > for min_t() or handling the default cases on switch statements etc or
> > verifying that we broke out of a loop instead of coming to the end
> > without finding what we were looking for.
>=20
> As promised I took a look at the smatch complaints.
>=20
> > drivers/net/wireless/brcm80211/brcmsmac/phy/phy_cmn.c +1710 wlc_phy_txp=
ower_reg_limit_calc(50) error: potential null derefence 'txpwr_ptr1'.
> > drivers/net/wireless/brcm80211/brcmsmac/phy/phy_cmn.c +1719 wlc_phy_txp=
ower_reg_limit_calc(59) error: potential null derefence 'txpwr_ptr2'.
>=20
> However, I am not sure about these two. Reading the code these seem
> false positives. Could you confirm or correct me on these.

Yes.  You're obviously right.

regards,
dan carpenter


--BXr400anF0jyguTS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJO8iMWAAoJEOnZkXI/YHqRUSIQAIEGryseq9ETQTuxYZAHKF9X
jKram3ms0suZGg5oq9r8pvNOnAbib3KCNwwyz46YIiFI3qtCT0gIGw1jjk8EsDZT
uUjl3ZqsO0yzEjrwXrbr7zCFIIeY4oW5u73SnWT4nAg4lNLIPYBDSD2IzWCDKGCi
SV4dTnLIF/dk4kska1WTDy8JFzTiMPyckRewPNsOg1z4JLwtEbTor9cSTAYZb8K4
puPTPGqAAv5wXZwZrz1ZsdQPKersDtdzvR9XGRW92Bme7hkeBMAmHZ2GvDRxwTfS
ZJiS4tBLO0Oi6yW3JNHRxaksMyG/jVfUxYMn2zrLueFhyCB/+EGmYO7Qxo38a7Ty
/F7lXzYcmufw8BcY3son6COhNL/dcs7Yuu+/B7tVjcpmteIKNOu3pHfiz3kSIW0k
NZilWm9pB3bxgfLr0XDOv/KvzA1iMF+5IjGnSAZalzM64ToZ+ttdIrEZ3ZGvxDB/
7oh1BfE/4GEFzpA20h8fGxa2PRW0RDDgVhasBnebhIhLgt+xlkAl7Kb/F0/SUBcv
Tj/mpJmZfLsbdyb2Gf5sNXvoRhPR6pKLB+Q4NxBpMcXi1yUBEcau3DM1emiTNwyG
h62xekmzI7CpOm4AAPmDlMydT4yR7/iuUklWeWBCnjz9jw/mMYU05OXTcvDJEitH
qECLTrf3xpacf+8xjOOy
=iRZ6
-----END PGP SIGNATURE-----

--BXr400anF0jyguTS--
