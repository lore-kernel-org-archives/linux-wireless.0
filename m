Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 80-190-117-144.ip-home.de ([80.190.117.144]:58273 "EHLO
	bu3sch.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752537Ab0LLPgo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 12 Dec 2010 10:36:44 -0500
Subject: Re: [PATCH 2/2] ssb: Save sprom image for dump of device at
 alternate location
From: Michael =?ISO-8859-1?Q?B=FCsch?= <mb@bu3sch.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: John W Linville <linville@tuxdriver.com>,
	b43-dev@lists.infradead.org, linux-wireless@vger.kernel.org
In-Reply-To: <4D04EA37.50309@lwfinger.net> (sfid-20101212_162839_223659_FFFFFFFFD389D611)
References: <4d044307.Ipm73VWEgifFrF0m%Larry.Finger@lwfinger.net>
	 (sfid-20101212_043513_712988_FFFFFFFF9320429C) <1292144592.11817.7.camel@maggie>
	 <4D04EA37.50309@lwfinger.net>
	 (sfid-20101212_162839_223659_FFFFFFFFD389D611)
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 12 Dec 2010 16:36:25 +0100
Message-ID: <1292168185.3572.4.camel@maggie>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2010-12-12 at 09:28 -0600, Larry Finger wrote: 
> >> +	if (bus->sprom_data) {
> >> +		sprom = bus->sprom_data;
> >> +		err = 0;
> >> +	} else {
> > 
> > This branch is dead now, or do I miss something?
> 
> I kept it for those devices with SPROMs that are not PCI. If there are none,
> then it can de removed.

Ah ok. Seems it would still be needed for pcmcia. At least with the
current implementation.

-- 
Greetings Michael.

