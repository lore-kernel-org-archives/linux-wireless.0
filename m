Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lennier.cc.vt.edu ([198.82.162.213]:50519 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932773Ab0CLXtE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Mar 2010 18:49:04 -0500
To: Florian Mickler <florian@mickler.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Marcel Holtmann <marcel@holtmann.org>,
	Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	Randy Dunlap <rdunlap@xenotime.net>,
	Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH 2/2] enhance sysfs rfkill interface
In-Reply-To: Your message of "Fri, 12 Mar 2010 23:39:25 +0100."
             <20100312233925.74effc7d@schatten.dmk.lab>
From: Valdis.Kletnieks@vt.edu
References: <1268416988-24862-1-git-send-email-florian@mickler.org> <1268416988-24862-2-git-send-email-florian@mickler.org> <1268416988-24862-3-git-send-email-florian@mickler.org> <20100312182209.GB8736@core.coreip.homeip.net> <20100312215743.7671d173@schatten.dmk.lab> <20100312212025.GA17712@core.coreip.homeip.net>
            <20100312233925.74effc7d@schatten.dmk.lab>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1268437699_4034P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Date: Fri, 12 Mar 2010 18:48:19 -0500
Message-ID: <12058.1268437699@localhost>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--==_Exmh_1268437699_4034P
Content-Type: text/plain; charset=us-ascii

On Fri, 12 Mar 2010 23:39:25 +0100, Florian Mickler said:
> On Fri, 12 Mar 2010 13:20:26 -0800
> Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:

> > You are not updating but reading... Are you concerned about seeing
> > a partial write to u32? It does not happen.
> > 
> Hm.. You shure? On every arch that supports wireless drivers? 

If a u32 load or store from memory isn't atomic, the Linux kernel is screwed
anyhow.  Hint - imagine if every 32-bit reference had to be treated the way
we currently treat 64-bit references on a 32-bit system.

--==_Exmh_1268437699_4034P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFLmtLDcC3lWbTT17ARAoUlAJ9PMVZS/+1dk+OT8hIJsrR6bUma8gCeOdwy
g1K5M60opaPiEDX8C19AbIs=
=Rkjv
-----END PGP SIGNATURE-----

--==_Exmh_1268437699_4034P--

