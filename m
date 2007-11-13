Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:42256 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756196AbXKMP0p (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Nov 2007 10:26:45 -0500
Subject: Re: [PATCH] b43: Output message at startup if hardware switch for
	radio is off
From: Dan Williams <dcbw@redhat.com>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: linux-wireless@vger.kernel.org, Michael Buesch <mb@bu3sch.de>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	John Linville <linville@tuxdriver.com>,
	Bcm43xx-dev@lists.berlios.de
In-Reply-To: <200711121336.42389.hs4233@mail.mn-solutions.de>
References: <4734e389.AF3t4zZIQw1IryOf%Larry.Finger@lwfinger.net>
	 <200711101624.50808.mb@bu3sch.de>
	 <200711121336.42389.hs4233@mail.mn-solutions.de>
Content-Type: text/plain; charset=utf-8
Date: Tue, 13 Nov 2007 10:22:29 -0500
Message-Id: <1194967349.2955.25.camel@localhost.localdomain> (sfid-20071113_152650_900702_D011DEEA)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2007-11-12 at 13:36 +0100, Holger Schurig wrote:
> > Well... Pressing the rfkill button is the _FIRST_ thing that I
> > would do, if the device does not work. I'm wondering why
> > people have a problem with that. On other operating systems
> > it's the very same. On Windows there is no dmesg.
>=20
> On Windows, the "Wireless Network Connection" wizard displays
>=20
> -----------------------------------------------------
> No wireless networks were found in range
>=20
> Make sure the wireless switch on your computer is on.
> To see an updated list, click "Refresh network list".
> -----------------------------------------------------
>=20
> The Linux =C3=A4quivalent would be NetworkManager or the KDE tools fo=
r=20
> this job.
>=20
>=20
> That's at least displayed on the WinXP Embedded device that I=20
> just created :-)

Good thought; NM should probably replace the "You're disconnected"
notification dialog at startup with text that reads similar to remind
the user that the killswitch is on.

Dan


-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
