Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:34531 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752011AbZHSPPL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Aug 2009 11:15:11 -0400
Date: Wed, 19 Aug 2009 11:01:38 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH v5 00/33] wireless: kconfig updates
Message-ID: <20090819150138.GB5905@tuxdriver.com>
References: <1250530052-14783-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1250530052-14783-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 17, 2009 at 01:26:59PM -0400, Luis R. Rodriguez wrote:
> This is revision number 5 on the wireless kconfig updates, I apologize
> for the spam but I had to rebase based on reviews on some earlier
> patches. In this series I've removed the .ko references for modules
> both in the commit logs and in the kconfig entries, I've also
> made the changes pointed out in the TI kconfig, and left the comments
> on the mac80211 and cfg80211 kconfig simpler based on johill's feedback.
> 
> I left out the patch that selects cfg80211 when you select mac80211
> as there is an issue there that is still under review (building cfg80211
> and mac80211 built-in but rfkill as a module).

I'm sorry, I know you've put some effort into this.  A lot of it seems
fine, even welcome.  But I don't really see the point of grouping
everything by manufacturer -- it just seems to add an extra level of
organization for no particular reason...?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
