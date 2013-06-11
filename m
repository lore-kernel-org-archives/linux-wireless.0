Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f50.google.com ([209.85.214.50]:50431 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754347Ab3FKTtO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Jun 2013 15:49:14 -0400
Received: by mail-bk0-f50.google.com with SMTP id ik8so2253967bkc.23
        for <linux-wireless@vger.kernel.org>; Tue, 11 Jun 2013 12:49:12 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: linville@tuxdriver.com
Subject: Re: [PATCH] carl9170: make use of the new rate control API
Date: Tue, 11 Jun 2013 21:49:09 +0200
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Thomas =?utf-8?q?H=C3=BChn?= <thomas@net.t-labs.tu-berlin.de>,
	linux-wireless@vger.kernel.org, nbd@nbd.name
References: <1370966237-27716-1-git-send-email-thomas@net.t-labs.tu-berlin.de> <1E3747D2-BD9C-4136-B17F-9227E24136D5@net.t-labs.tu-berlin.de> <1370978668.8356.67.camel@jlt4.sipsolutions.net>
In-Reply-To: <1370978668.8356.67.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201306112149.09768.chunkeey@googlemail.com> (sfid-20130611_214918_018140_18F53E6D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday, June 11, 2013 09:24:28 PM Johannes Berg wrote:
> On Tue, 2013-06-11 at 21:17 +0200, Thomas Hühn wrote:
> > Hi Christian,
> > 
> > I have not seen that patch in wireless-next, that's why I overlooked it... sorry.
You are right and it's not in wireless-testing.git either. That's a bit odd.

John,

was this patch overlooked/lost or was there a problem with it?
(Or: can you please put it into wireless-next)

> > > carl9170 already supports the new rate control API (Patch from 2013-04-23).
> > > <http://permalink.gmane.org/gmane.linux.kernel.wireless.general/107657>
> > > 
> > > Can you please tell me what you think is missing?
> > > 
> > 
> > You patch looks good to me.
> > As I just saw an ath9k patch for rcu protection when ieee80211_get_tx_rates() is called.
> > Should this be done in carl9170 as well ?
> 
> I think that patch is wrong actually, probably should just do the rcu
> protection inside the function. However the patch is completely wrong
> anyway (C isn't python) so ...
Uh, that's confusing. We are now talking about the patch from Thomas, right?
If so: the previous "new rate control api" feature patch for carl9170 should
be fine in this regard.

Regards,
	Chr
