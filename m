Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:36509 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751397Ab0GLP0v (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Jul 2010 11:26:51 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 12 Jul 2010 08:26:51 -0700
Date: Mon, 12 Jul 2010 08:26:50 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Michael Wu <aluminum.tape@gmail.com>,
	Christian Lamparter <chunkeey@googlemail.com>
Subject: Re: [PATCH] wireless: mark adm8211 and p54 orphaned
Message-ID: <20100712152650.GE3492@tux>
References: <1278947189-14833-1-git-send-email-lrodriguez@atheros.com>
 <4C3B3342.3060801@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <4C3B3342.3060801@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jul 12, 2010 at 08:22:42AM -0700, Larry Finger wrote:
> On 07/12/2010 10:06 AM, Luis R. Rodriguez wrote:
> > Michael has been out of the scene for a while now, these
> > drivers are really orphaned so mark them as such.
> >
> > Cc: Michael Wu<aluminum.tape@gmail.com>
> > Cc: Larry Finger<Larry.Finger@lwfinger.net>
> > Cc: Christian Lamparter<chunkeey@googlemail.com>
> > Signed-off-by: Luis R. Rodriguez<lrodriguez@atheros.com>
> > ---
> >   MAINTAINERS |    6 ++----
> >   1 files changed, 2 insertions(+), 4 deletions(-)
> >
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index a07a49d..6ed6135 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -4270,11 +4269,10 @@ F:	include/scsi/osd_*
> >   F:	fs/exofs/
> >
> >   P54 WIRELESS DRIVER
> > -M:	Michael Wu<flamingice@sourmilk.net>
> >   L:	linux-wireless@vger.kernel.org
> >   W:	http://prism54.org
> >   T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mwu/mac80211-drivers.git
> > -S:	Maintained
> > +S:	Orphan
> >   F:	drivers/net/wireless/p54/
> 
> Despite Michael's absence, p54 is still maintained. Christian is the most 
> obvious choice for the position. If he is not willing to take on the 
> responsibility, then I will.

Awesome! If either of you guys do decide to do so, please send a
respective patch.

  Luis
