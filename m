Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:33610 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752147AbZELRy7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 May 2009 13:54:59 -0400
Subject: Re: [RFT v9] rfkill: rewrite
From: Johannes Berg <johannes@sipsolutions.net>
To: Will Keaney <keaneyw@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <4A09B130.9000106@gmail.com>
References: <1242030669.6930.10.camel@johannes.local>
	 <4A09B130.9000106@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-7tn/xLuSMRXLpbXIcxbY"
Date: Tue, 12 May 2009 19:52:44 +0200
Message-Id: <1242150764.11924.0.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-7tn/xLuSMRXLpbXIcxbY
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-05-12 at 13:26 -0400, Will Keaney wrote:

> >  * rfkill-input pointlessly is a separate module
> >  =20
> Please leave rfkill-input available as a module, at least until the bug
> I reported in my previous e-mail 'Soft Lockup With rfkill_input and
> thinkpad_acpi' is resolved.  Otherwise it will render Thinkpads, and
> possibly other systems, unusable with rfkill enabled.

I certainly will not, but I will help you solve the problem _after_ this
patch. For sure not before this patch.

johannes

--=-7tn/xLuSMRXLpbXIcxbY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKCbdmAAoJEODzc/N7+Qmas50P/ArLpkYQMUw5/01Z04mqmyVZ
X4MtIssGCEVmshCHRaDr2OAZRzOS0bNDQ6Dq0uEE9GgQlR5C/ngNHlMQU5QVxfSK
3s7Z9K+/8I/1aYZ5+TPB57IKnHA9+sqiywrb0d8U6zMmcJo4FbIu2N5bkAPi6f9d
Bh5rzoC9reUHtd6uBNkpDlipqLS8j4YUYlMI6nZiifHZ7m8gAn1cCf7kk1hHns67
+YbFaDp8ZJPRtTLbH6Qvj1N966fTWErNPw0nh43Sl3/ibraPqLOtqNYt6ZkfAvmf
HT+HVSQskOby/gMDRk9rTEhXCCSfTiovugQ/RUxVDtjHXmiLsofTRi+l7yXX5zQP
nsDqLXF/l1kLnE92mQM0vSUPukMpUQwjyVgEDa5uA/+Z8a8I2fxEhRsetfeb7b5+
x4pCww5EVyPYI2C9lv+mIbUKmQ71do8dQiVWEpL/QdOFlOgaNzCkCFvVLN+ZVq2l
PnlEs168CzVgjqgQFInFKrLGdGvXGKMW5YUB8XPhQPyq1D356SqIKSqCSGTs2/8C
D3nVh4vVq40mFl3o4WuoAgd7QZSgAeRu+NOdK6PvzZzl259hNHWRRkq8yxVbGV+K
mEYHsKkeK6Ie4zK0nosAanGxO+1gPlSfQ0CWJvv6EiV9fzhPAvbvMqyVF11zBMWq
DQYR0EYQq7Yl9mbgXSaj
=lTqk
-----END PGP SIGNATURE-----

--=-7tn/xLuSMRXLpbXIcxbY--

