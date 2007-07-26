Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:64339 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964808AbXGZSuF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jul 2007 14:50:05 -0400
Message-ID: <46A8ECD6.30204@lwfinger.net>
Date: Thu, 26 Jul 2007 13:49:58 -0500
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless@vger.kernel.org, Bcm43xx-dev@lists.berlios.de,
	Michael Buesch <mb@bu3sch.de>
Subject: Re: [PATCH] bcm43xx-mac80211: Fix specs typo for baseband attenuation
References: <46a8ccbd.wNQamvQ9e0RJ0XZK%Larry.Finger@lwfinger.net> <20070726172138.GA6068@tuxdriver.com> <46A8E044.6080206@lwfinger.net> <20070726181334.GB6068@tuxdriver.com>
In-Reply-To: <20070726181334.GB6068@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John W. Linville wrote:
> 
> Hmmm...well, if you asked to revert it on bcm43xx, why is it appropriate here?

AFAIK, the V4 specs have always had the typo, thus there was no patch introducing this error - it is 
original. On the other hand, the V3 specs were modified fairly late in the process, which led to the 
bcm43xx patch that needed to be reverted. I suspect that the V3 changes may have been the result of 
making them match the V4 specs. If that is the case, it made both of them wrong.

No matter, the change is needed to make some older cards work. Now I know why bcm43xx-mac80211 never 
worked on my BCM4306 until today.

Larry
