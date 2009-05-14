Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:47173 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750842AbZENSCA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 May 2009 14:02:00 -0400
Subject: Re: [ipw3945-devel] iwlwifi 5150 uCode available
From: reinette chatre <reinette.chatre@intel.com>
To: =?ISO-8859-1?Q?G=E1bor?= Stefanik <netrolller.3d@gmail.com>
Cc: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>
In-Reply-To: <69e28c910905141046q1e0248b1qb00ad3b9335ed31e@mail.gmail.com>
References: <1242321566.32358.19.camel@rc-desk>
	 <b170af450905141022q29f7a8cfl1c079e473f575c49@mail.gmail.com>
	 <1242322940.32358.31.camel@rc-desk>
	 <b170af450905141043r50c4831eh73999eef98bea7bf@mail.gmail.com>
	 <69e28c910905141046q1e0248b1qb00ad3b9335ed31e@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 14 May 2009 11:08:33 -0700
Message-Id: <1242324513.32358.45.camel@rc-desk>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2009-05-14 at 10:46 -0700, Gábor Stefanik wrote:
> 2009/5/14 Rafał Miłecki <zajec5@gmail.com>:
> > W dniu 14 maja 2009 19:42 użytkownik reinette chatre
> > <reinette.chatre@intel.com> napisał:
> >> Hi,
> >>
> >> On Thu, 2009-05-14 at 10:22 -0700, Rafał Miłecki wrote:
> >>> 2009/5/14 reinette chatre <reinette.chatre@intel.com>:
> >>> > uCode for Intel Wireless WiFi Link 5150AGN is now available for download
> >>> > from http://intellinuxwireless.org/?n=Downloads
> >>>
> >>> Changelog is top secret as usually? ;)
> >>
> >> Nope ... this is the very first release of this uCode for this
> >> particular hardware. A changelog does not make sense in this case.
> >>
> >>
> >>> Should this fix
> >>> http://www.intellinuxwireless.org/bugzilla/show_bug.cgi?id=1946 (wrong
> >>> command queue)?
> >>
> >>
> >> This bug is against 5100/5300 hardware, so this uCode is not what you
> >> are looking for. We are working on getting uCode for 5100/5300 hardware
> >> (that includes a fix for this bug) out the door.
> >>
> >> Reinette
> >
> > Ah, I gone wrong with that numbers understanding. Maybe putting
> > supported hardware in ucode's README would be a good idea? :)
> > Currently visiting http://intellinuxwireless.org/?n=Downloads doesn't
> > provide much help about choosing right firmware for 5100/5300(/5200?).
> > Or at last some short info on download page?
> >
> > --
> > Rafał Miłecki
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
> 
> Perhaps if this is also for 5350, 

No - 5000 is correct ucode for 5350. Yes ... it is confusing and I just
changed the webpage to help out with this. 

Reinette

