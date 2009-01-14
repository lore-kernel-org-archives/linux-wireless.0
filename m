Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:38654 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759368AbZANRsz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Jan 2009 12:48:55 -0500
From: Michael Buesch <mb@bu3sch.de>
To: bcm43xx-dev@lists.berlios.de
Subject: Re: [b43] opensource firmware
Date: Wed, 14 Jan 2009 18:48:21 +0100
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Lorenzo Nava <navalorenx@gmail.com>,
	linux-wireless@vger.kernel.org
References: <9FB118DA-845D-4708-84F3-4D51837D8C68@gmail.com> <496E243F.1080500@lwfinger.net>
In-Reply-To: <496E243F.1080500@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200901141848.21574.mb@bu3sch.de> (sfid-20090114_184909_703510_54548A04)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 14 January 2009 18:43:27 Larry Finger wrote:
> Lorenzo Nava wrote:
> 
> > Today we have also tested a new firmware version that works with
> > WPA2-personal (both TKIP and CCMP) and WPA2-enterprise (EAP-TTLS)
> > (tested on 4306 and 4318 PCI device). If anybody was interested please
> > try new firmware with encryption and let us know if it works correctly,
> > thanks!
> 
> On my BCM4318 (Linksys WPC54G, Ver 3) in a Cardbus format in a
> WPA2-personal encrypted network with AES algorithm, it nearly worked.
> With your firmware, it can scan and authenticate. It even gets an
> DHCP-supplied IP address; however, I get no data through the link. In
> addition, I see lots of PHY TRANSMISSION ERRORS. When I disable
> hardware encryption (nohwcrypt=1), then it works.

Support for hardware crypto would require to reverse engineer the PCM firmware, first.
So we can't support hw-crypto, except on new devices that don't have a PCM anymore.
But these are not rev5 cores :)

-- 
Greetings, Michael.
