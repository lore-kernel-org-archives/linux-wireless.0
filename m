Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp2.cc.ic.ac.uk ([155.198.5.156]:43428 "EHLO
	smtp2.cc.ic.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756487AbXLRPeX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Dec 2007 10:34:23 -0500
Received: from 85-211-250-36.dsl.pipex.com ([85.211.250.36] helo=[192.168.0.2])
	by smtp2.cc.ic.ac.uk with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.67)
	(envelope-from <mark.williamson@imperial.ac.uk>)
	id 1J4dye-0003NO-Ki
	for linux-wireless@vger.kernel.org; Tue, 18 Dec 2007 15:03:24 +0000
Message-ID: <4767E141.7080801@imperial.ac.uk> (sfid-20071218_153428_191906_A6890286)
Date: Tue, 18 Dec 2007 15:03:29 +0000
From: Mark Williamson <mark.williamson@imperial.ac.uk>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Queries about acx-mac80211 master mode support on the AR7 platform
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I=92m currently following the Openwrt project (http://openwrt.org/) wit=
h=20
specific interest to the AR7 port. The hardworking developers on this=20
project have really brought support for this along: the unit works, the=
=20
ADSL component works, but the wireless support is still WIP. Until=20
recently the acx drivers (http://acx100.sourceforge.net/) were used to=20
drive the card on the unit; a specific pci-to-vlynq bridge had been=20
written to enable this to work on the AR7 platform. This worked well,=20
but there was no WPA support available; WEP was the only encryption=20
available with this driver.

Hence to address this, initial work was taken for the acx driver to=20
utilise the mac80211 stack and a new acx driver called acx-mac80211 was=
=20
written (http://acx100.sourceforge.net/wiki/Acx-mac80211).  IMHO this=20
still very much WIP and is nowhere near as stable as the original acx=20
driver. But, perhaps the largest sticking point is that the acx-mac8021=
1=20
driver, unlike acx, does not support AP (master) mode. I have struggled=
=20
to find out whether this is an issue in the acx-mac80211 driver=20
component or in fact the mac80211 does not support master mode at this=20
moment in time. Can anyone shed some light on this and help clear up my=
=20
ongoing confusion?

Regards,

Mark Williamson
-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
