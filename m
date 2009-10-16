Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:58339 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751118AbZJPLih (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Oct 2009 07:38:37 -0400
Subject: Re: [WIP, RFC] libertas: allow scanning via "iw"
From: Johannes Berg <johannes@sipsolutions.net>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <200910141652.11203.hs4233@mail.mn-solutions.de>
References: <200910141652.11203.hs4233@mail.mn-solutions.de>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-4oD/HUtxHZnQl1RPoAbb"
Date: Fri, 16 Oct 2009 18:50:11 +0900
Message-Id: <1255686611.4095.323.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-4oD/HUtxHZnQl1RPoAbb
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-10-14 at 16:52 +0200, Holger Schurig wrote:
> Do not apply, but please look at the code and comment harshly :-)

> =20
> +#ifdef TODO
>  	/* Scan results list */
>  	struct list_head network_list;
>  	struct list_head network_free_list;
>  	struct bss_descriptor *networks;
> +#endif

It'd be easier to read and see what the patch does if you actually
removed all the stuff that is no longer necessary :)

johannes

--=-4oD/HUtxHZnQl1RPoAbb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJK2EHPAAoJEODzc/N7+Qma0tYP/iv9EQ0Fg6hhKHli9C4odDLI
vKnX8j6gdapHW3mUmqJSDIiHYTcMZEX1jFmMau5Cn2VMd7R8aDz3A9rRCfxWWBNe
IoO+GDHMq+RfEc+v7jMwZNcnZXKN8zjwW429bE6oZ8/Ac+kb1crSsmHT9poONNqr
3r/ayCjNdlXkG6mTlS2m8Ecg7E05aIG987rckKSRjWM7UPPMZ+FPjvJT+VU7ySPt
Um5GuEhmItT/NGh1W4lPGmSEogiZP5SUtGrI0ANIg2WsACZPqv+db5GhJn5eeMv1
bP4CxxFwT1E2iZo0ABKG29S7MJOrDKcrDgl7LqHVNo4C89PbnxHMzdbUzKUPlc7B
EotGNNxE9dPNHj/tUCWkkVhqBOT8ZdzYhKUw3gGpzw0JJ8hYci0thvPDQUtEEofj
xIRl/2I2Xs+Kh8HtbsxEzMsMZ0rDLt++0shBfONQxPbHEE4HxANeVT15lAy/noDh
GHP2uiIr6Is7tNR4pswhq48e9mG30EtFsBLG/B+YC7lXCcqBSYP8FOsTmcJsfr5y
wsM8kXEwedmJBty9h7+F6hRktwdPN5jDyExhwGHIFtqn3jFXp/lcqL5uN+SVxNPq
PLZ6H3AJHjgWpx1eOfArY9T6SSmB1uWfD27S6Icp5KjOE9Mfk5NASSMHKvBqXHrI
FK8Qazp4O+VXSWo8uy0A
=lHS/
-----END PGP SIGNATURE-----

--=-4oD/HUtxHZnQl1RPoAbb--

