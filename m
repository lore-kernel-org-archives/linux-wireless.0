Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:40632 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752817AbZAPPPp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Jan 2009 10:15:45 -0500
Date: Fri, 16 Jan 2009 10:14:03 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 13/13] cfg80211: Remove CONFIG_WIRELESS_OLD_REGULATORY
Message-ID: <20090116151403.GA10037@tuxdriver.com> (sfid-20090116_161547_997268_A7282FB2)
References: <1232064746-17134-6-git-send-email-lrodriguez@atheros.com> <1232064746-17134-7-git-send-email-lrodriguez@atheros.com> <1232064746-17134-8-git-send-email-lrodriguez@atheros.com> <1232064746-17134-9-git-send-email-lrodriguez@atheros.com> <1232064746-17134-10-git-send-email-lrodriguez@atheros.com> <1232064746-17134-11-git-send-email-lrodriguez@atheros.com> <1232064746-17134-12-git-send-email-lrodriguez@atheros.com> <1232064746-17134-13-git-send-email-lrodriguez@atheros.com> <1232064746-17134-14-git-send-email-lrodriguez@atheros.com> <1232098091.3854.37.camel@johannes>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1232098091.3854.37.camel@johannes>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jan 16, 2009 at 10:28:11AM +0100, Johannes Berg wrote:
> On Thu, 2009-01-15 at 16:12 -0800, Luis R. Rodriguez wrote:
> > This removal was scheduled for 2.6.29 but we decided to
> > keep it around a bit longer. Now that we are on road to
> > 2.6.30 lets remove it.
> 
> Alright, fine, I still run this because my distro hasn't picked up crda
> yet, but I guess that just means I need to get my distro to do that.

Distros should pick-up crda, true.  Still, I support Johannes' original
comments that keeping this is not a huge maintenance burden and that
we need not be too hasty to get rid of this.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
