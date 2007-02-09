Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:60156
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423238AbXBITRl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Feb 2007 14:17:41 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Joseph Jezak <josejx@gentoo.org>
Subject: Re: [PATCH] bcm43xx: Fix code for spec changes of 2/7/2007
Date: Fri, 9 Feb 2007 20:17:36 +0100
Cc: Larry Finger <larry.finger@lwfinger.net>, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>,
	Bcm43xx-dev@lists.berlios.de
References: <45cca236.+lL/rsW3DbM3elnk%Larry.Finger@lwfinger.net> <45CCBB93.2040703@lwfinger.net> <45CCC5DF.8010001@gentoo.org>
In-Reply-To: <45CCC5DF.8010001@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200702092017.36950.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 09 February 2007 20:05, Joseph Jezak wrote:
> > I'll agree to that as long as there is a clear indication of any differences between V3 and V4 firmware.
> 
> That's also part of the problem.  With the v4 driver, Broadcom 
> dropped support for a number of older BPHY devices (4301/4303 and 
> some 4306 revisions).  Do we still want to support those?  Should I 
> continue writing the specs for the uCode revision it's based on or 
> should I combine them?

If it's easily possible, please try to combine the old stuff
with the new v4 specs.
I think it's basically only dropped if() branches, right?

-- 
Greetings Michael.
