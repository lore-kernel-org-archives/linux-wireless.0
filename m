Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:34786 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S2992771AbXBIT0c (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Feb 2007 14:26:32 -0500
Message-ID: <45CCCAE1.9080901@lwfinger.net>
Date: Fri, 09 Feb 2007 13:26:25 -0600
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: Joseph Jezak <josejx@gentoo.org>
CC: Michael Buesch <mb@bu3sch.de>, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>,
	Bcm43xx-dev@lists.berlios.de
Subject: Re: [PATCH] bcm43xx: Fix code for spec changes of 2/7/2007
References: <45cca236.+lL/rsW3DbM3elnk%Larry.Finger@lwfinger.net> <200702091811.40683.mb@bu3sch.de> <45CCF432.2070002@gentoo.org> <200702091829.51002.mb@bu3sch.de> <45CCBB93.2040703@lwfinger.net> <45CCC5DF.8010001@gentoo.org>
In-Reply-To: <45CCC5DF.8010001@gentoo.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Joe,

Joseph Jezak wrote:

> That's also part of the problem.  With the v4 driver, Broadcom dropped
> support for a number of older BPHY devices (4301/4303 and some 4306
> revisions).  Do we still want to support those?  Should I continue
> writing the specs for the uCode revision it's based on or should I
> combine them?

As my 4306 is a rev 1 and is likely a version dropped in the V4 driver, I have a special interest in
this question.

My plan is to continue to maintain bcm43xx-SoftMAC for at least the BPHY and 4306 revisions even
after d80211 becomes the in-kernel driver. Of course, I hope that we will have found the killer bugs
by that time, and that maintenance will only require following kernel API changes.

As the work will be yours, you should decide if you would rather maintain the V3 and V4 pages
separately, or denote the special requirements of each firmware flavor in a combined set of pages.

Larry
