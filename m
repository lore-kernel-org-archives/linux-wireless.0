Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from basicbox7.server-home.net ([195.137.212.29]:46507 "EHLO
	basicbox7.server-home.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751690AbYJ1Hfp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Oct 2008 03:35:45 -0400
Message-ID: <4906B944.4010105@leemhuis.info> (sfid-20081028_083550_035307_58424396)
Date: Tue, 28 Oct 2008 08:03:32 +0100
From: Thorsten Leemhuis <fedora@leemhuis.info>
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: rt2400-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
Subject: Re: rtl2860 driver in mainline?
References: <20081028004915.GA3442@kroah.com>
In-Reply-To: <20081028004915.GA3442@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 28.10.2008 01:49, Greg KH wrote:
> So, on my quest to suck up every out-of-tree driver and get it into the
> main kernel tree (drivers/staging/ to start with), I've been pointed at
> the rtl2860 driver.

Does it really make sense to include a driver when a different one for 
mainline inclusion is being actively developed? It might give some 
developers the impression that it's worth spending time improving the 
rtl2860/2870 drivers -- which might be wasted time in the end.

> Does anyone know of a "cleaned up" version of this driver that is
> newer/better than the one on ralink's web site?  I found the
> 2008_0918_RT2860_Linux_STA_v1.8.0.0.tar.bz2 version there, and will
> start with that if no one else has yet.
> 
> Any pointers are appreciated.

You can find a few patches (needed for 2.6.26 and 2.6.27 iirc; not sure 
if they are enough to make it work on current mainline) for both rt2860 
and rt2870 in CVS for RPM Fusion:

http://cvs.rpmfusion.org/viewvc/rpms/rt2860-kmod/devel/?root=free
http://cvs.rpmfusion.org/viewvc/rpms/rt2870-kmod/devel/?root=free

HTH

CU
knurd
