Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmailhost04.isp.att.net ([207.115.11.54]:60062 "EHLO
	fmailhost04.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750953AbZDNEOS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Apr 2009 00:14:18 -0400
Message-ID: <49E40D88.3050709@lwfinger.net> (sfid-20090414_061422_652568_EE73F0A2)
Date: Mon, 13 Apr 2009 23:14:00 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: David Ellingsworth <david@identd.dyndns.org>
CC: Michael Buesch <mb@bu3sch.de>,
	Broadcom Wireless <bcm43xx-dev@lists.berlios.de>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: b43legacy AP
References: <30353c3d0904100736g69782d46g18d99edd0dd0660d@mail.gmail.com>	 <49DF9E38.5030801@lwfinger.net>	 <30353c3d0904101349o915439arffb652b98e245e10@mail.gmail.com> <30353c3d0904110756qfc35928x265db523bd1f86be@mail.gmail.com>
In-Reply-To: <30353c3d0904110756qfc35928x265db523bd1f86be@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

David Ellingsworth wrote:
> I wanted to report that I've finally been successful at getting
> b43legacy to beacon properly. Originally, I had configured hostapd to
> use channel 1. After reading the list of bugs for the bwi driver,
> shown here: http://leaf.dragonflybsd.org/cgi/web-man?command=bwi , I
> had the inclination to try channel 6. It appears b43legacy might have
> the same bugs as the bwi driver as I immediately began seeing beacons
> once I started using channel 6.

I finally got a chance to test my BCM4306/2 that uses b43legacy. It works just
fine as an AP using channel 1. At least on my device, it does not have the
problem of the bwi driver.

Larry
