Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:54571 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756959AbZEDRX1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 May 2009 13:23:27 -0400
Subject: Re: [PATCH] add support for showing power constraint IE
From: Marcel Holtmann <marcel@holtmann.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1241456088.8683.62.camel@johannes.local>
References: <1241453167-3720-1-git-send-email-marcel@holtmann.org>
	 <1241453408.8683.53.camel@johannes.local>
	 <1241454909.2903.17.camel@localhost.localdomain>
	 <1241455125.8683.60.camel@johannes.local>
	 <1241455848.2903.18.camel@localhost.localdomain>
	 <1241456088.8683.62.camel@johannes.local>
Content-Type: text/plain
Date: Mon, 04 May 2009 10:23:15 -0700
Message-Id: <1241457795.2903.32.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

> > just re-based and added the patch for the WPA/RSN length checks. So we
> > should be good now in this area.
> 
> Thanks, applied, and really pushed out now.
> 
> Do you think I should cut a new release with all the shiny new parsing
> code, or will you work on more :)

one other thing that comes to my mind is to have a convenient "iw scan"
alias to just trigger scanning all all interfaces. The "dev wlan0" thing
is driving my crazy. And most people just have one card only anyway.

Do we really need the "dev" versus "phy" details here. I guess they are
needed in case someone renames "wlan0" to "phy0" by accident, but
personally I prefer that the "dev" one is optional and it falls back to
just use the interface name.

Regards

Marcel


