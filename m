Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmailhost04.isp.att.net ([204.127.217.104]:56715 "EHLO
	fmailhost04.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752874AbZDKPgL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 11 Apr 2009 11:36:11 -0400
Message-ID: <49E0B8DA.8030708@lwfinger.net> (sfid-20090411_173615_138494_CD750C93)
Date: Sat, 11 Apr 2009 10:35:54 -0500
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

I just tested and my 4311/1 running b43legacy sends beacons on channel 1. The
problem is likely in the initialization of the 4306 units. That is something I
will be investigating.

As far as I can tell, it should be OK to submit the b43legacy beacon patches.

Larry
