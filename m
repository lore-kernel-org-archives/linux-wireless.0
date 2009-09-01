Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:18316 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752597AbZIARiV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Sep 2009 13:38:21 -0400
Received: from mail.atheros.com ([10.10.20.104])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 01 Sep 2009 10:38:24 -0700
Date: Tue, 1 Sep 2009 10:38:23 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: =?iso-8859-1?Q?G=E1bor?= Stefanik <netrolller.3d@gmail.com>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	<linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 6/7] wireless: update mac80211 kconfig entry
Message-ID: <20090901173822.GG8261@mosca>
References: <1251820465-11104-1-git-send-email-lrodriguez@atheros.com>
 <20090901163300.GA29047@jm.kir.nu>
 <20090901171848.GF8261@mosca>
 <69e28c910909011028i25fba508t9e68fb24168193eb@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
In-Reply-To: <69e28c910909011028i25fba508t9e68fb24168193eb@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 01, 2009 at 10:28:35AM -0700, Gábor Stefanik wrote:
> On Tue, Sep 1, 2009 at 7:18 PM, Luis R. Rodriguez<lrodriguez@atheros.com> wrote:
> > On Tue, Sep 01, 2009 at 09:33:00AM -0700, Jouni Malinen wrote:
> >> On Tue, Sep 01, 2009 at 08:54:25AM -0700, Luis R. Rodriguez wrote:
> >> > +       SoftMAC devices. SoftMAC devices allow for a finer control of the
> >>
> >> Again, I don't really like the term "SoftMAC" here..
> >
> > What's a better term?
> >
> 
> "Software-based", "Software-MAC", "Software-defined", or anything that
> neither implies that the stack is designed for PrismGT (the
> capitalization "SoftMAC" comes from Intersil AFAIK), nor allows
> confusion with ieee80211softmac (which could result if we write it
> with all small letters as "softmac").

Indeed, I picked up 'SoftMAC' and 'FullMAC' terminology from the prism54 days
after they decided to move in that direction as others were or already had. For
better or for worse I have been using 'SoftMAC' throughout wireless.kernel.org
documentation to distinguish between 'FullMAC' cards. I really have not been
able to find any other suitable replacements, are there legal reasons to not use
such terms?

I thought 'mac80211' name was brilliant as it highlighted the main focus for the
module, to focus on the MAC frame processing, I just cannot think of any
description for it other than something to support SoftMAC cards.

  Luis
