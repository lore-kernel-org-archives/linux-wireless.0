Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate01.web.de ([217.72.192.221]:39516 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751016AbYISOzN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Sep 2008 10:55:13 -0400
From: Christian Lamparter <chunkeey@web.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: stlc45xx: mac80211 driver for N800 and N810
Date: Fri, 19 Sep 2008 16:58:46 +0200
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	Kalle Valo <kalle.valo@nokia.com>,
	linux-wireless@vger.kernel.org
References: <877i98iw4h.fsf@nokia.com> <43e72e890809182257r65da8757g1de0ce4f132bf019@mail.gmail.com> <1221814778.10419.23.camel@johannes.berg>
In-Reply-To: <1221814778.10419.23.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200809191658.46690.chunkeey@web.de> (sfid-20080919_165517_652043_8BD75B19)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 19 September 2008 10:59:38 Johannes Berg wrote:
> On Thu, 2008-09-18 at 22:57 -0700, Luis R. Rodriguez wrote:
> > > After the driver has received some serious cleanup I would like to try
> > > to to get it into wireless-testing tree. But I'll send another email
> > > later on.
> >
> > Cool! I thought n810 basically used a p54 type chipset over SPI?
>
> Yes, but the firmware (lower MAC) is sufficiently different that it
> would be painful to support in p54, afaict.
>
not that much... only the frequency calibration data is a bit different,
while most other data structures are more or less the same. Really!

Regards,
	Chr



