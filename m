Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:47316 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757772AbZEDQu7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 May 2009 12:50:59 -0400
Subject: Re: [PATCH] add support for showing power constraint IE
From: Marcel Holtmann <marcel@holtmann.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1241455125.8683.60.camel@johannes.local>
References: <1241453167-3720-1-git-send-email-marcel@holtmann.org>
	 <1241453408.8683.53.camel@johannes.local>
	 <1241454909.2903.17.camel@localhost.localdomain>
	 <1241455125.8683.60.camel@johannes.local>
Content-Type: text/plain
Date: Mon, 04 May 2009 09:50:48 -0700
Message-Id: <1241455848.2903.18.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

> > > > +static void print_powerconstraint(const uint8_t type, uint8_t len, const uint8_t *data)
> > > > +{
> > > > +	printf(" %d db\n", data[0]);
> > > 
> > > s/db/dB/ -- fixed, applied and pushed, thanks.
> > 
> > so how sure are you that you pushed it? I don't see it.
> 
> Sorry, seems I didn't hit enter. Definitely pushed now.

just re-based and added the patch for the WPA/RSN length checks. So we
should be good now in this area.

Regards

Marcel


