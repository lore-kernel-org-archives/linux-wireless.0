Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:52182 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755992AbZJASaF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Oct 2009 14:30:05 -0400
Date: Thu, 1 Oct 2009 14:28:41 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] staging: Add proper selection of WIRELESS_EXT and
	WEXT_PRIV
Message-ID: <20091001182840.GF2895@tuxdriver.com>
References: <4AC4F363.4080404@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4AC4F363.4080404@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 01, 2009 at 01:22:27PM -0500, Larry Finger wrote:
> After the incorporation of the patch entitled "wext: refactor", some
> of the wireless drivers in drivers/staging fail to build because they
> need to have CONFIG_WIRELESS_EXT and CONFIG_WEXT_PRIV defined.
> 
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> ---
> 
> John,
> 
> I know that Greg K-H maintains staging, but I sent this to you because
> your tree is the only one affected at the moment. Greg is Cc'd.
> 
> Larry

Hmmm...OK, I suppose I'll just carry this one -- I doubt if it will
cause a problem during the 2.6.33 merge window unless one of these
drivers actually disappears from staging anyway...

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
