Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:2233 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751547AbXKJPZy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Nov 2007 10:25:54 -0500
Date: Sat, 10 Nov 2007 10:25:33 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Michael Buesch <mb@bu3sch.de>
Cc: Frank Lichtenheld <frank@lichtenheld.de>,
	bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] b43: silence a bogus gcc warning
Message-ID: <20071110152533.GC32472@tuxdriver.com> (sfid-20071110_152558_005532_0FFD450B)
References: <200711101614.03776.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <200711101614.03776.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Nov 10, 2007 at 04:14:03PM +0100, Michael Buesch wrote:
> From: Frank Lichtenheld <frank@lichtenheld.de>
>=20
> inititalise ret to 0 to avoid the following bogus warning:
>   CC [M]  drivers/net/wireless/b43/debugfs.o
> drivers/net/wireless/b43/debugfs.c: In function =E2=80=98b43_debugfs_=
read=E2=80=99:
> drivers/net/wireless/b43/debugfs.c:355: warning: =E2=80=98ret=E2=80=99=
 may be used uninitialized in this function
>=20
> Signed-off-by: Frank Lichtenheld <frank@lichtenheld.de>
> Signed-off-by: Michael Buesch <mb@bu3sch.de>

Isn't this what uninitialized_var() is for?

--=20
John W. Linville
linville@tuxdriver.com
-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
