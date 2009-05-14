Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:47604 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752047AbZENVPQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 May 2009 17:15:16 -0400
Subject: Re: [BUG] scans can still hang with -EBUSY on iwl3945
From: Johannes Berg <johannes@sipsolutions.net>
To: reinette chatre <reinette.chatre@intel.com>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>,
	iwlwifi maling list <ipw3945-devel@lists.sourceforge.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1242335658.32358.112.camel@rc-desk>
References: <1241179203.8086.3.camel@maxim-laptop>
	 <1241193513.10498.97.camel@rc-desk> <1241208792.7082.47.camel@maxim-laptop>
	 <1241227946.5192.3.camel@maxim-laptop>
	 <1241374060.13562.37.camel@johannes.local>
	 <1241387163.10486.6.camel@maxim-laptop>
	 <1241421545.6866.2.camel@johannes.local>
	 <1242161643.26484.2.camel@maxim-laptop>
	 <1242169824.5146.31.camel@maxim-laptop>
	 <1242169934.14227.16.camel@johannes.local>
	 <1242335658.32358.112.camel@rc-desk>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-sat1QGO+ccWh/mQxtBa7"
Date: Thu, 14 May 2009 23:14:44 +0200
Message-Id: <1242335684.5799.14.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-sat1QGO+ccWh/mQxtBa7
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-05-14 at 14:14 -0700, reinette chatre wrote:

> I am not convinced. When mac80211 requests a scan from the driver
> checking if rfkill is enabled is the first thing it does and it will
> return an error in this case. See iwl_mac_hw_scan().
>=20
> Maxim, please ensure your driver is compiled with debug support
> (CONFIG_IWLWIFI_DEBUG) and load the driver with debug=3D0x2. We should se=
e
> debug messages that will guide us here.

debug=3D0x803 would be more useful I think. Or maybe 0x802.

I wish I had the ftrace thing for mac80211 ready already... oh well.

johannes

--=-sat1QGO+ccWh/mQxtBa7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKDInAAAoJEODzc/N7+QmaaPsP/2HLoVxCsTdt92B+DI3ORlJ/
RoGUrP9qiPrboCeZlB7+Pr2L9igX2T7WcnxTVWxh7QzeCpKlbqZJzcWJNwm2KfeM
8MUIeVr6AFV8FFjf4j6REbNiAkWNDqwXMTXd3gFxlpdYumv1vE+PCR7YEie50bb7
fErm+WhmGM3SkRyK4eNUp2isayQj8AiGJsYAwe/CvjkH0LUm8YSBNrxKrWXzcPWZ
GGsOaAu1RpPcMohHZpSiC/iRkxb+EktKxgp6iwNqoZSGgtfdJS52ezHa6QxQUqOm
SqSZPyrh1bDQ4sHDzxtvA8B6T25AIY2mml65JHwhfc9SmqY6DhgWnlzhOVkiEZLw
+zLccYrxalFry4u9B9OeifWDE9hbF9kIn4fjIYo+wgCnxvm9E1gqBYNk/UZ+uTgJ
5tUdMxf6O4IgC/0Kc/BPZyBTRCLNnQE3S+TvFD0HVppxcVmMAytnrNjbB2N+sRAD
Q7y+JrjAJSM4+7VrAfzEX2Yt69NIVAuV11gWUL9YNDiVQNPTP524/dcKyNsSc7eP
e8oo6IORTn76L2/njFGy8HAV7RYrsK47Lb4zgm4C6HJBZdJ5XpjYU1WXfnaW+L9R
9mluaFv+7u/tPacmmSIwlWC56NE2hHEBfDONYQzPGMNB3x4mQ9FBNKHbP41JNLDh
P6YSuC76qriWlVYY2/92
=C9Oy
-----END PGP SIGNATURE-----

--=-sat1QGO+ccWh/mQxtBa7--

