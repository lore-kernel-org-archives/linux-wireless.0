Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.48]:43243 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753808Ab0KXTeA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Nov 2010 14:34:00 -0500
Subject: Re: [PATCH 1/1] compat-wireless: apply changes needed after
 wl1271->wl12xx renaming
From: Luciano Coelho <luciano.coelho@nokia.com>
To: "ext Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <AANLkTi=pPT84kCOzEbUX+5nTwn4tM=Z-kmYae9Nirv-1@mail.gmail.com>
References: <1290438027-20179-1-git-send-email-luciano.coelho@nokia.com>
	 <1290438027-20179-2-git-send-email-luciano.coelho@nokia.com>
	 <AANLkTinrKyw-EHKrt5WKbHjbiQUM7Vhz3MR3n8OdWpzf@mail.gmail.com>
	 <1290592410.25710.4.camel@chilepepper>
	 <AANLkTi=pPT84kCOzEbUX+5nTwn4tM=Z-kmYae9Nirv-1@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 24 Nov 2010 21:33:53 +0200
Message-ID: <1290627233.12170.0.camel@powerslave>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-11-24 at 08:58 -0800, ext Luis R. Rodriguez wrote:
> On Wed, Nov 24, 2010 at 1:53 AM, Luciano Coelho
> <luciano.coelho@nokia.com> wrote:
> > Hi Luis,
> >
> >
> > On Mon, 2010-11-22 at 10:13 -0800, ext Luis R. Rodriguez wrote:
> >> On Mon, Nov 22, 2010 at 7:00 AM,  <luciano.coelho@nokia.com> wrote:
> >> > From: Luciano Coelho <luciano.coelho@nokia.com>
> >> >
> >> > This patch changes the occurrences of wl1271 in the Makefile, README and in
> >> > the scripts to wl12xx, since the driver has been renamed.
> >> >
> >> > Also remove the wl1271_ prefix from the filenames.
> >> >
> >> > Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
> >>
> >> Applied and pushed, thanks!
> >
> > It seems that the wl12xx file name changes are now in linux-next.  I
> > guess it's okay to include this patch in compat-wireless now.
> >
> > Sorry for the trouble!
> 
> Its already there, thanks!

Ah, yes, now I see that you have already reverted the revert ;)

Thanks, dude!

-- 
Cheers,
Luca.

