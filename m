Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:54058 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751999Ab0ATSUx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jan 2010 13:20:53 -0500
Subject: Re: [PATCH] iw: add country IE parsing
From: Marcel Holtmann <marcel@holtmann.org>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org
In-Reply-To: <1264009908-27195-1-git-send-email-lrodriguez@atheros.com>
References: <1264009908-27195-1-git-send-email-lrodriguez@atheros.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 20 Jan 2010 10:20:28 -0800
Message-ID: <1264011628.5591.211.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Luis,

> I've considered showing only the channel set from the Country IE
> but since cfg80211 now mangles contigious channel sets together
> it seems more useful for iw to just display the individual triplets
> separately so this patch is left intact. The triplet print is
> kept since technically speaking this should also show the
> regulatory extension stuff when one is found.

looks like this with my Apple Airport if anyone cares:

	Country: CA	Environment: Indoor/Outdoor
	Country IE triplets:
		Channels [1 - 11]

Regards

Marcel


