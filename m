Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:33812 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752139AbZHBJS6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Aug 2009 05:18:58 -0400
Subject: Re: Unsupported PHY on B43
From: Johannes Berg <johannes@sipsolutions.net>
To: Luis Correia <luis.f.correia@gmail.com>
Cc: Michael Buesch <mb@bu3sch.de>, linux-wireless@vger.kernel.org
In-Reply-To: <efe7343f0908020214m6d8b2518n51d4264943ce273a@mail.gmail.com>
References: <efe7343f0908020214m6d8b2518n51d4264943ce273a@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-MCo28bfCgkxTqUmARs28"
Date: Sun, 02 Aug 2009 11:18:52 +0200
Message-Id: <1249204732.2007.49.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-MCo28bfCgkxTqUmARs28
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2009-08-02 at 10:14 +0100, Luis Correia wrote:

> b43-phy1: Broadcom 4322 WLAN found (core revision 16)
> b43-phy1 ERROR: FOUND UNSUPPORTED PHY (Analog 8, Type 4, Revision 4)
> b43: probe of ssb0:0 failed with error -95
> Broadcom 43xx driver loaded [ Features: PML, Firmware-ID: FW13 ]

This is an 11n phy.

> I'm available to test drivers, patches, git kernels, the whole lot.

There's nothing available beyond what you have.

johannes

--=-MCo28bfCgkxTqUmARs28
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKdVn2AAoJEODzc/N7+QmalO4P/iWd+E++JRJRhR+re6hBUK6R
6soraVWh/7oln7y00m8I3VzqBKTnnNGDOrDx+F9VPkySffL4YKo9KqmE8po+E19J
4sb0lSOtiR6OG1so1zI8vG3GpAfpjV2RkVEa7xClvHDhhgftvQVkjzU7N+3uYrpT
uDFwtwDQsROiz+AVVwHhUmkX51PaYd96o8OPTA8HPB1bvhpclruyC7t8GHqnaOcx
cFNuBfXqx4+mzfXKA9iWGgL67aUNGSNWAeIbq9bVrvfMzca4KAiVmSVVWXDmNb1a
5NqSIkGk9FvqzgsAm9Id+zLfUtHXazZ0uY84UI7XmrUhrT4ndpQtX7TiAmSP6kk5
6/cFSQDTrzGkakZ3xfXgL84z3bn0aqM1YUsPq69N2cUqjmlHZaA7MHCRW2iSruKK
miEkfWU6NrTB3QiYLPnMWnWmc04GzB2boR7oEdGD/IrIe34wp6724Aftm8uHyT2q
TzCLl/Vtoz76tgzO7cNLjipTeuRoMAdwjBFzG6Hns8vjTR/cJ4WeYgSPdv8PHJo3
8JYiiRciKAQXSXPlhz305VRYpuoq37A6crXda40uNolOoEVjxX1yw6tbfhqcWEMH
Gq8xcA0BWCdakKI/5ohpPoBkVlFoVUFFgmEL9Nxi1hTFcgU6dSQaBCvoUgv18ZBI
GWfN38aGhChi/S5McDnN
=euoM
-----END PGP SIGNATURE-----

--=-MCo28bfCgkxTqUmARs28--

