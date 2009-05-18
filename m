Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:59704 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793AbZERUPN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 May 2009 16:15:13 -0400
Date: Mon, 18 May 2009 16:03:54 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Stefano Brivio <stefano.brivio@polimi.it>,
	Michael Buesch <mb@bu3sch.de>,
	wireless <linux-wireless@vger.kernel.org>,
	Broadcom Linux <bcm43xx-dev@lists.berlios.de>
Subject: Re: [PATCH 2/2 V2] b43legacy: Fix locking problem
Message-ID: <20090518200354.GK2814@tuxdriver.com>
References: <4A0DD306.30705@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4A0DD306.30705@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, May 15, 2009 at 03:39:34PM -0500, Larry Finger wrote:
> Commit abb1d2bca0fc429c136747a64e675dd4d8906f36 introduced a locking
> problem in b43legacy that caused the system to freeze upon booting.
> 
> Signed-off-by: Larry Finger@lwfinger.net
> ---
> 
> John,
> 
> This is 2.6.31 material. I hope that you do not have trouble with
> this patch. While on the road, my normal method is not available.
> 
> This is resent as V2 to eliminate some patch offsets that resulted
> from the changes in V2 of patch 1.
> 
> Larry

This conflicted w/ a patch from Johannes, and I couldn't easily
figure-out how to resolve them.  Since his claimed to fix something
else along with this problem, I just applied his.

Also, please don't refer to commit IDs directly, especially ones
that aren't already in linux-2.6.  Instead, please refer to the
patch subject.  If the commit is already in linux-2.6, then a short
reference to the commit ID is acceptable.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
