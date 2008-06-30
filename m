Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:52552 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754428AbYF3Lgf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jun 2008 07:36:35 -0400
Subject: Re: [PATCH 1/1 V2] cfg80211: adding NONE regdomain
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>, linville@tuxdriver.com,
	yi.zhu@intel.com, linux-wireless@vger.kernel.org,
	Ester Kummer <ester.kummer@intel.com>
In-Reply-To: <1ba2fa240806300425i609ababfj22a76718d3857f85@mail.gmail.com> (sfid-20080630_132600_385419_2FD4B304)
References: <1214732604-4573-1-git-send-email-tomas.winkler@intel.com>
	 <43e72e890806300118me4b20bv2b91f30f91eaa7f3@mail.gmail.com>
	 <1ba2fa240806300152o6d5f7deby6d00a4421138177c@mail.gmail.com>
	 <43e72e890806300159j6c98ef9dpeac61d5aeca19f0e@mail.gmail.com>
	 <1214817730.5507.27.camel@johannes.berg>
	 <1ba2fa240806300425i609ababfj22a76718d3857f85@mail.gmail.com>
	 (sfid-20080630_132600_385419_2FD4B304)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-q91im58De9zLokPF50iH"
Date: Mon, 30 Jun 2008 13:35:47 +0200
Message-Id: <1214825747.5507.47.camel@johannes.berg> (sfid-20080630_133659_615040_BBCAA5FA)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-q91im58De9zLokPF50iH
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-06-30 at 14:25 +0300, Tomas Winkler wrote:

> The idea was ask troubled user to make change in modprobe.conf and not
> changing the code.

Yeah but IMHO you're solving the wrong problem. If we want any
credibility we shouldn't allow users to ignore any regdom that easily,
and this is system-wide. Also, iwlwifi partly caused this problem in the
first place by printing out eeprom channels rather than having users use
"iwlist wlan0 channel" to see which channels are usable. Or even iw,
which shows you which are disabled.

johannes

--=-q91im58De9zLokPF50iH
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIaMUPAAoJEKVg1VMiehFYFL4QAI4DWKrDuVc2Z0pgb2a9vFmZ
PdO210NMS2spwcWr9ycMx9xtEaCY/Z2NvVQq605LHjx6OoAcgo1ghbJ7yw3BVlgw
Y8Iw48e26JsmpTk0i9j+12zr/dD6JDsTgtMdXbybsureXd6h0IefJm2GBmNMYU6d
/uNGwQImFmCErZtsytbHS0oV96MDrcQ2uKvuhIOLJlIVw5a8Eu3z4IchZ0/dicNM
x27x1F2qNwbDkARlsknRENm12CcFnaQrxGm//zh3lSPp5q4otea7taww+szuEHzS
OkbllunWiqzJtaSpt7rMMp2JPORDG5LnSvQQ4NaO9pDSZIarglgyA5wPTXGw2pMf
XI4/j6TmCH2/t4DMEYMEOXIWE87ug++tJacNShs/kReox4nnWs6O0aJgAwz7YDai
3azVvn2Imc2RgOV5OwwMpR0MqcIRAzxj+RizwxwDw2Eq50gwQGXYmVxjM799rZAf
wSAEzRnFDIaftquJIlX9mVKS+WCjKx6CBc5GDAqBO0oyKQY1UmliCkcRPxjNcjYT
yS2c2ZYyyw03iYxprz2ETfV008CzG9FUGovNd8tPGfO4eo5ymMGwoHvP+YJrYqnD
zDDJTVdchiehGl1ung1NPHEp+p0LqF516x3WHffs7oS3fcTB731f+5ob17g3uuFV
exldqe6HfIKVevFwvF2c
=R9xv
-----END PGP SIGNATURE-----

--=-q91im58De9zLokPF50iH--

