Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:54627 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752408AbXKZQSt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Nov 2007 11:18:49 -0500
Message-ID: <474AF1E2.4050405@lwfinger.net> (sfid-20071126_161856_338247_A984AC9D)
Date: Mon, 26 Nov 2007 10:18:42 -0600
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?C=E9dric_Caumont?= <icare40@hotmail.com>
CC: John Linville <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>,
	wireless <linux-wireless@vger.kernel.org>,
	Broadcom Linux <bcm43xx-dev@lists.berlios.de>
Subject: Re: [PATCH V3] b43: Changes to enable BCM4311 rev 02 with wireless
 core	revision 13
References: <474ADA53.808@lwfinger.net> <BAY134-W383251EC52D7A2B85197DEB7750@phx.gbl>
In-Reply-To: <BAY134-W383251EC52D7A2B85197DEB7750@phx.gbl>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

C=E9dric Caumont wrote:
> Hello everyone
>=20
> I have just one question!
>=20
> I downloaded linux-2.6.24-rc3
>=20
> cd /usr/src/
> ln -sfn linux-2.6.24-rc3 linux
> cd linux
> patch -p1 < patch_v3.patch
>=20
> *********************************************************************=
************************
> can't find file to patch at input line 112
> Perhaps you used the wrong -p or --strip option?
> The text leading up to this was:
> --------------------------
> |Index: wireless-2.6/drivers/net/wireless/b43/wa.c

The patch is for the wireless-2.6 git tree. To use 2.6.24-rc3 from main=
line, there are some
additional patches needed. I will generate that patch and send it to yo=
u privately.

Larry

-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
