Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f175.google.com ([74.125.82.175]:47677 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750888AbaB0IaW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Feb 2014 03:30:22 -0500
Received: by mail-we0-f175.google.com with SMTP id q59so2573792wes.20
        for <linux-wireless@vger.kernel.org>; Thu, 27 Feb 2014 00:30:20 -0800 (PST)
Message-ID: <530EF796.4030400@gmail.com> (sfid-20140227_093026_317813_860CF2C1)
Date: Thu, 27 Feb 2014 10:30:14 +0200
From: Emmanuel Grumbach <egrumbach@gmail.com>
MIME-Version: 1.0
To: linville@tuxdriver.com
CC: linux-wireless@vger.kernel.org
Subject: Re: pull request: iwlwifi 2014-02-27
References: <530EE0EA.5030105@gmail.com> <530EE2B9.4020708@gmail.com>
In-Reply-To: <530EE2B9.4020708@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="4lssSBbnIeIc4qlE3bDUmWDJcw4VTGxhG"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--4lssSBbnIeIc4qlE3bDUmWDJcw4VTGxhG
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable



On 02/27/2014 09:01 AM, Emmanuel Grumbach wrote:
>=20
>=20
> On 02/27/2014 08:53 AM, Emmanuel Grumbach wrote:
>> Hi John,
>>
>> I have two fixes for 3.14.
>> Johannes fixes a long standing bug in the AMPDU status reporting.
>> Max fixes the listen time which was way too long and causes trouble to=
 several APs.
>>
>> Please pull - thanks
>>
>>   emmanuel
>>
>> The following changes since commit ec6f678c74dbdb06a6a775bbb00f1d26c17=
c404b:
>>
>>   iwlwifi: dvm: clear IWL_STA_UCODE_INPROGRESS when assoc fails (2014-=
02-20 19:16:27 +0200)
>>
>> are available in the git repository at:
>>
>>   git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-fixes.=
git master
>>
>> for you to fetch changes up to d8105a24fce48b7b016e868923000871f4196e6=
3:
>>
>=20
> Made a minor change in the commit message of one of the patches - new H=
EAD:082e29cb547474aa19c028d75d81bc5d873774f4.
>=20
>=20

yet another one - new HEAD: 143582c6847cb285b361804c613127c25de60ca4


--4lssSBbnIeIc4qlE3bDUmWDJcw4VTGxhG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJTDveZAAoJEC0Llv5uNjIBOkEQAIBQF2nl9ixiq9jeE8B8sE7P
m9T1CzfbaHYmzir1tT3HafRBqGDrirdf38pT5S9CWFnvFjF0oVLNlE7jR0VHA48Y
/mNspCw2qyI4apYWnROxEN73QNKgFAD5GZFW1nGW2vURG2x+HQ2PV/m9VEnRLV/B
TS//1ZgiAwx2WcYowvjEHzv9w22Ktn4apDo+LXqvKmnNYY6eBmu7yI9SI0eA2B9u
49iKZugDixYCNiyYRVzYdDaRvIMPfGC0S7onT2M3Sfckn+kj7luPAEqqLKb80yVu
6kxIJWNJk5VqDtk8fekKvSqDlkI8auu1HxseuNvqseD6Azh+IGXW3tJMribMIMpl
7gW75wbndTu0TPELawdMriS5PAYkjcMxxoi8jPd7lvUODBlvcl7CuoztncsCNn+S
5kvZtPFAZLxcP6TpprDA3dr6Q6+VGn4IVSeCKDxA9fqT9FgjqzU9EmL6aiDn6SFj
h0U9NiIjeyU0I+OZljZt2tTdHP64OReGwv6CPU8pNVAFY0azh71b3NenWNV0s/RQ
12ew5glYO4m0F926IKCMeqg6wk0pgCu9Pj/450OXy+8QXRZgdJ6q/7kxJcuZKzUk
lVlR8pSWvGiMh74GZ2eivbEAQE7g7NGvr0ZBmBdzaOZxyD+vZj1rKaJKI2NoEHRQ
X+TAluPBYO5z2ke7gh3V
=zxoZ
-----END PGP SIGNATURE-----

--4lssSBbnIeIc4qlE3bDUmWDJcw4VTGxhG--
