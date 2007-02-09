Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rwcrmhc14.comcast.net ([216.148.227.154]:55923 "EHLO
	rwcrmhc14.comcast.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946616AbXBIR3x (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Feb 2007 12:29:53 -0500
Message-ID: <45CCF4A3.3080306@gentoo.org>
Date: Fri, 09 Feb 2007 17:24:35 -0500
From: Joseph Jezak <josejx@gentoo.org>
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: John Linville <linville@tuxdriver.com>, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org, Bcm43xx-dev@lists.berlios.de,
	Michael Buesch <mb@bu3sch.de>
Subject: Re: [PATCH] bcm43xx: Fix code for spec changes of 2/7/2007
References: <45cca236.+lL/rsW3DbM3elnk%Larry.Finger@lwfinger.net>
In-Reply-To: <45cca236.+lL/rsW3DbM3elnk%Larry.Finger@lwfinger.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

 >  	dprintk(KERN_INFO PFX "Detected PHY: Version: %x, Type %x, 
Revision %x\n",

You should change this too, the "Version" text should read "Analog" 
instead.

-Joe
