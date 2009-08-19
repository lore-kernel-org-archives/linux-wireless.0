Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:38901 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751000AbZHSSCh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Aug 2009 14:02:37 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 19 Aug 2009 11:02:39 -0700
Date: Wed, 19 Aug 2009 11:02:35 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v5 00/33] wireless: kconfig updates
Message-ID: <20090819180235.GA7126@mosca>
References: <1250530052-14783-1-git-send-email-lrodriguez@atheros.com>
 <20090819150138.GB5905@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20090819150138.GB5905@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 19, 2009 at 08:01:38AM -0700, John W. Linville wrote:
> On Mon, Aug 17, 2009 at 01:26:59PM -0400, Luis R. Rodriguez wrote:
> > This is revision number 5 on the wireless kconfig updates, I apologize
> > for the spam but I had to rebase based on reviews on some earlier
> > patches. In this series I've removed the .ko references for modules
> > both in the commit logs and in the kconfig entries, I've also
> > made the changes pointed out in the TI kconfig, and left the comments
> > on the mac80211 and cfg80211 kconfig simpler based on johill's feedback.
> >
> > I left out the patch that selects cfg80211 when you select mac80211
> > as there is an issue there that is still under review (building cfg80211
> > and mac80211 built-in but rfkill as a module).
> 
> I'm sorry, I know you've put some effort into this.  A lot of it seems
> fine, even welcome.  But I don't really see the point of grouping
> everything by manufacturer -- it just seems to add an extra level of
> organization for no particular reason...?

Well at first I didn't really intend to group them by manufacturer really,
I just tried to get rid of clutter and wanted to group related drivers
together to make it easier to find for users. After a few iterations the
manufacturer grouping just happened naturally, and later it also just seemed
natural to remove the typical postfix "wireless device support" or the like.

I welcome others to try to clean the stuff up some more in a different
way but I think you may end up with something very similar.

  Luis
