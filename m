Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ogre.sisk.pl ([217.79.144.158]:40935 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751640AbXLHUvB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 Dec 2007 15:51:01 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: bcm43xx-dev@lists.berlios.de, "John H." <mistamaila@gmail.com>
Subject: Re: b43 continues to have issue with APs at times
Date: Sat, 8 Dec 2007 22:09:56 +0100
Cc: Michael Buesch <mb@bu3sch.de>, linux-wireless@vger.kernel.org,
	Larry Finger <larry.finger@lwfinger.net>
References: <5b9417770712081222y4f0ab1va51910faf16fb068@mail.gmail.com> <200712082135.11685.mb@bu3sch.de>
In-Reply-To: <200712082135.11685.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200712082209.57069.rjw@sisk.pl> (sfid-20071208_205108_717601_C052B5A7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday, 8 of December 2007, Michael Buesch wrote:
> On Saturday 08 December 2007 21:22:37 John H. wrote:
> > I have this problem at two different locations with two different
> > access points.  2.6.23.1 kernel, and sometimes until I actually power
> > down the AP and restart it, wpa_supplicant and such just times out on
> > the AP.
> > 
> > Any ideas?

Have you tried to change the distance from the AP (like moving closer to it
when the wpa_supplicant is appearing to have problems)?

Rafael
