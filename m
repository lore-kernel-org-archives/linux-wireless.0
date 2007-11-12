Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:27990 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758257AbXKLMgt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Nov 2007 07:36:49 -0500
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] b43: Output message at startup if hardware switch for radio is off
Date: Mon, 12 Nov 2007 13:36:42 +0100
Cc: Michael Buesch <mb@bu3sch.de>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	John Linville <linville@tuxdriver.com>,
	Bcm43xx-dev@lists.berlios.de
References: <4734e389.AF3t4zZIQw1IryOf%Larry.Finger@lwfinger.net> <200711101624.50808.mb@bu3sch.de>
In-Reply-To: <200711101624.50808.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Message-Id: <200711121336.42389.hs4233@mail.mn-solutions.de> (sfid-20071112_123653_364292_FB85D065)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Well... Pressing the rfkill button is the _FIRST_ thing that I
> would do, if the device does not work. I'm wondering why
> people have a problem with that. On other operating systems
> it's the very same. On Windows there is no dmesg.

On Windows, the "Wireless Network Connection" wizard displays

-----------------------------------------------------
No wireless networks were found in range

Make sure the wireless switch on your computer is on.
To see an updated list, click "Refresh network list".
-----------------------------------------------------

The Linux =E4quivalent would be NetworkManager or the KDE tools for=20
this job.


That's at least displayed on the WinXP Embedded device that I=20
just created :-)
-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
