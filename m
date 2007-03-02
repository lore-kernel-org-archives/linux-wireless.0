Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:61610 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S2992645AbXCBRXq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Mar 2007 12:23:46 -0500
Message-ID: <45E85D9C.4090602@lwfinger.net>
Date: Fri, 02 Mar 2007 11:23:40 -0600
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: Pavel Roskin <proski@gnu.org>, linux-wireless@vger.kernel.org,
	bcm43xx-dev@lists.berlios.de
Subject: Re: Assertion failed in ieee80211softmac_wx_get_rate
References: <1172816819.26330.12.camel@dv> <20070302135734.GB6676@tuxdriver.com>
In-Reply-To: <20070302135734.GB6676@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John W. Linville wrote:
> 
> It is in linux-2.6, wireless-2.6, and wireless-dev.  If you don't
> want to use those trees, you should be able to apply the patch to
> the tree you are using.

If you wish to run bcm43xx-softmac from either the mb (Michael Buesch) or the wireless-dev trees,
you can get a patch to update them to the current state of my code at
ftp://lwfinger.dynalias.org/patches/update_mb_0302.patch. This patch not only includes the things
that are in the wireless-2.6 tree, but changes that are in progress.

FYI, I have compile-, but not yet run-tested this tree with these changes.

Larry

