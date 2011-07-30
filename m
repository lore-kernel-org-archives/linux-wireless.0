Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from home.keithp.com ([63.227.221.253]:37914 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752588Ab1G3AwG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Jul 2011 20:52:06 -0400
From: Keith Packard <keithp@keithp.com>
To: "Guy\, Wey-Yi" <wey-yi.w.guy@intel.com>
Cc: Intel Linux Wireless <ilw@linux.intel.com>,
	"linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] iwlagn: check for !priv->txq in iwlagn_wait_tx_queue_empty
In-Reply-To: <1311686528.5579.145.camel@wwguy-huron>
References: <1311622702-4807-1-git-send-email-keithp@keithp.com> <1311621715.5579.138.camel@wwguy-huron>  <yunvcuqunzd.fsf@aiko.keithp.com> <1311627547.13973.2.camel@wwguy-ubuntu>  <yunvcup35gx.fsf@aiko.keithp.com> <1311686528.5579.145.camel@wwguy-huron>
Date: Fri, 29 Jul 2011 17:52:03 -0700
Message-ID: <yuny5zgegjw.fsf@aiko.keithp.com> (sfid-20110730_025211_056125_E6A6500B)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Tue, 26 Jul 2011 06:22:08 -0700, "Guy, Wey-Yi" <wey-yi.w.guy@intel.com> =
wrote:

> commit 94f9b97be5b3bf67392e43fb7f567721b09142c2
> Author: Johannes Berg <johannes.berg@intel.com>
> Date:   Thu Jul 14 16:48:54 2011 +0200
>=20
>     mac80211: be more careful in suspend/resume

Yup, that fixed it. Thanks for figuring it out.

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFOM1WzQp8BWwlsTdMRArqQAKDEA9Z/dXUVoYq033woR+KuAsrdwwCeL/OI
p5cn/ap3WRX+tiWQTcvyIYo=
=LUNa
-----END PGP SIGNATURE-----
--=-=-=--
