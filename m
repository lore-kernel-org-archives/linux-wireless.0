Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rwcrmhc13.comcast.net ([216.148.227.153]:47728 "EHLO
	rwcrmhc13.comcast.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992795AbXBIT7F (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Feb 2007 14:59:05 -0500
Message-ID: <45CCD280.9070501@gentoo.org>
Date: Fri, 09 Feb 2007 14:58:56 -0500
From: Joseph Jezak <josejx@gentoo.org>
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: Larry Finger <Larry.Finger@lwfinger.net>, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>,
	Bcm43xx-dev@lists.berlios.de
Subject: Re: [PATCH] bcm43xx: Fix code for spec changes of 2/7/2007
References: <45cca236.+lL/rsW3DbM3elnk%Larry.Finger@lwfinger.net> <200702091945.25187.mb@bu3sch.de> <45CCC8B5.3060108@gentoo.org> <200702092026.43006.mb@bu3sch.de>
In-Reply-To: <200702092026.43006.mb@bu3sch.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>> This is correct.  Why do you think it's a specs bug?
> 
> Because
> a) The old one made more sense to me.
> b) Write MMIO register 0x3? I mean. What is that?
>    Could this be PHY or radio register 0x3?
> 

Apologies.  You are correct that this should be PHY Register 0x3, 
not MMIO offset 0x3.  I've corrected this in the specs.

-Joe
