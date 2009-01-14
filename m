Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:36134 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754430AbZANRng (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Jan 2009 12:43:36 -0500
Message-ID: <496E243F.1080500@lwfinger.net> (sfid-20090114_184342_945988_A581FCB0)
Date: Wed, 14 Jan 2009 11:43:27 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Lorenzo Nava <navalorenx@gmail.com>
CC: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org,
	Francesco Gringoli <francesco.gringoli@ing.unibs.it>
Subject: Re: [b43] opensource firmware
References: <9FB118DA-845D-4708-84F3-4D51837D8C68@gmail.com>
In-Reply-To: <9FB118DA-845D-4708-84F3-4D51837D8C68@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Lorenzo Nava wrote:

> Today we have also tested a new firmware version that works with
> WPA2-personal (both TKIP and CCMP) and WPA2-enterprise (EAP-TTLS)
> (tested on 4306 and 4318 PCI device). If anybody was interested please
> try new firmware with encryption and let us know if it works correctly,
> thanks!

On my BCM4318 (Linksys WPC54G, Ver 3) in a Cardbus format in a
WPA2-personal encrypted network with AES algorithm, it nearly worked.
With your firmware, it can scan and authenticate. It even gets an
DHCP-supplied IP address; however, I get no data through the link. In
addition, I see lots of PHY TRANSMISSION ERRORS. When I disable
hardware encryption (nohwcrypt=1), then it works.

Great job.

Larry
