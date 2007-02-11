Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alnrmhc14.comcast.net ([206.18.177.54]:57306 "EHLO
	alnrmhc14.comcast.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752619AbXBKC2o (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Feb 2007 21:28:44 -0500
Message-ID: <45CE7BCA.6010107@gentoo.org>
Date: Sat, 10 Feb 2007 21:13:30 -0500
From: Joseph Jezak <josejx@gentoo.org>
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: Matthew Garrett <mjg59@srcf.ucam.org>,
	linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>,
	Bcm43xx-dev@lists.berlios.de,
	Larry Finger <larry.finger@lwfinger.net>
Subject: Re: [PATCH] bcm43xx: Fix code for spec changes of 2/7/2007
References: <45cca236.+lL/rsW3DbM3elnk%Larry.Finger@lwfinger.net>	<45CCCAE1.9080901@lwfinger.net>	<20070209213239.GA11650@srcf.ucam.org> <200702100655.51495.mb@bu3sch.de>
In-Reply-To: <200702100655.51495.mb@bu3sch.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> It's likely that old cards still work with v4 firmware, but we don't know and
> it has to be tested.
> 
> Care to do so?

I'm fairly sure the reason for dropping the old cards is that the 
on-board memory which holds the firmware isn't large enough to hold 
the newer firmware.  I can't find my documentation for that at the 
moment though.  Feel free to test and I'll confirm it later if I can 
find the info.

I'd suspect it doesn't work though since they provided a different 
firmware (ucode2) in the past.

-Joe
