Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmailhost06.isp.att.net ([204.127.217.106]:46470 "EHLO
	fmailhost06.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753112AbZESDdr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 May 2009 23:33:47 -0400
Message-ID: <4A122882.2070409@lwfinger.net>
Date: Mon, 18 May 2009 22:33:22 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: Stefano Brivio <stefano.brivio@polimi.it>,
	Michael Buesch <mb@bu3sch.de>,
	wireless <linux-wireless@vger.kernel.org>,
	Broadcom Linux <bcm43xx-dev@lists.berlios.de>
Subject: Re: [PATCH 2/2 V2] b43legacy: Fix locking problem
References: <4A0DD306.30705@lwfinger.net> <20090518200354.GK2814@tuxdriver.com>
In-Reply-To: <20090518200354.GK2814@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John W. Linville wrote:
> 
> This conflicted w/ a patch from Johannes, and I couldn't easily
> figure-out how to resolve them.  Since his claimed to fix something
> else along with this problem, I just applied his.
> 
> Also, please don't refer to commit IDs directly, especially ones
> that aren't already in linux-2.6.  Instead, please refer to the
> patch subject.  If the commit is already in linux-2.6, then a short
> reference to the commit ID is acceptable.

Sorry about the commit ID. I thought I had the title in there as well, but it
appears not.

It was good to use the patch from Johannes. In addition to fixing another
problem, he also had the opportunity to fix the locking problem that he broke.

BTW, b43legacy works in 2.6.30-rc6-wl.

Larry
