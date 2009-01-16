Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:38244 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752634AbZAPJO7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Jan 2009 04:14:59 -0500
Subject: Re: [PATCH 04/13] cfg80211: export freq_reg_info()
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1232065614-18007-1-git-send-email-lrodriguez@atheros.com> (sfid-20090116_012725_745779_3C46C304)
References: <1232065614-18007-1-git-send-email-lrodriguez@atheros.com>
	 (sfid-20090116_012725_745779_3C46C304)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-78Dw6NdwcIfkiDErlsga"
Date: Fri, 16 Jan 2009 10:14:26 +0100
Message-Id: <1232097266.3854.11.camel@johannes> (sfid-20090116_101506_885567_3E5327D4)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-78Dw6NdwcIfkiDErlsga
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-01-15 at 16:26 -0800, Luis R. Rodriguez wrote:

> @@ -846,29 +846,9 @@ static int freq_reg_info_regd(struct wiphy *wiphy, u=
32 center_freq,
> =20
>  	return !max_bandwidth;
>  }
> +EXPORT_SYMBOL(freq_reg_info);

that kinda seems to be in the wrong spot.

I also don't quite understand what you need this for?

johannes

--=-78Dw6NdwcIfkiDErlsga
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJcE/tAAoJEKVg1VMiehFYBKQQAIUb7OhPLzXT2ja4WGk6WYpE
gSQctaMbLRizJqCF7vOf3C6j6vEC3GcA+JpmYJ7xisyVTI47o02IJe77H4Ky965R
lIxYQQAfWfbGLLEJPkticFsKSZKFjvdCAkv2/Ckzx6hTBEwXjdk1lOg+qzpt12wP
/pR9FAGBPMgTYSo/agg/NZUkm02Ji3t5BZKZbGVIsW6zyRKv3dssDlIKrboHbFwF
VWPvBIyzuwah9BWTsBo32mRkf7fHrJk0gOwhwcW2ilRyy+DoOazCrm7scpiI4e+z
BdFEbQxxL8877TQPnacC9TkifxtFWPzOTG5oZpdT4OLyym6EckOZmSFUW1sR+FkX
T939/uGlR1y8O68BQ80Y3XirqZVkIyQ9Ft/LvvFRUMupb2dSr9UOkzFPLYFP+a+U
41xAyAStTAR8vOWFLUP421k2EcvCAY7FVMuRNAoo9vj29YOxXMnBFJ1QZ5hz8q0B
35YiuRr7HkLhzLo2VYnLlGyzXKqVHpXbkH15hqJH/WeSh1RfuHzD2PXK1duc85D4
k/ytTrc8i/B60IdsRtHmnVAY6liRVbHJzeDkgeYmmsVIKDbv52k9UhLi61VD8ayq
S5JmirWsMxqpIu0gM+DXXAb6EJ+KkURB/y1wjMjIvFhnGRkNdEj749DpnoXN17Zs
eLBUyzaStZ6y56yCsHfv
=cPWu
-----END PGP SIGNATURE-----

--=-78Dw6NdwcIfkiDErlsga--

