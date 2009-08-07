Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:39168 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932511AbZHGOqH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Aug 2009 10:46:07 -0400
Date: Fri, 7 Aug 2009 10:37:26 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Michael Buesch <mb@bu3sch.de>
Cc: wireless <linux-wireless@vger.kernel.org>,
	bcm43xx-dev@lists.berlios.de,
	gregor kowski <gregor.kowski@gmail.com>
Subject: Re: [PATCH] b43: Fix hardware key index handling
Message-ID: <20090807143726.GB7545@tuxdriver.com>
References: <200908061036.50631.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200908061036.50631.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 06, 2009 at 10:36:50AM +0200, Michael Buesch wrote:
> This fixes the hardware encryption keys index and array size handling.
> 
> Thanks to Gregor Kowski for reporting this issue.
> 
> Signed-off-by: Michael Buesch <mb@bu3sch.de>
> 
> ---
> 
> This should probably go as a bugfix.
> (Does this actually fix the PHY transmission errors? I don't see them anymore...
> Note that you need to enable debugging to see them.)

It's getting a bit late in the cycle, especially for a patch so large
and (at least to me) non-obvious.  What is the actual bug being fixed?
What is the effect of leaving it for 2.6.32?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
